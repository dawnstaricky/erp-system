package com.example.erpsystem.controller;

import com.example.erpsystem.annotation.RequiresRoles;
import com.example.erpsystem.common.Result;
import com.example.erpsystem.entity.User;
import com.example.erpsystem.mapper.SysUserDeptMapper;
import com.example.erpsystem.service.UserService;
import com.example.erpsystem.util.JwtUtil;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
public class UserInfoController {

    @Autowired
    private JwtUtil jwtUtil;

    @Autowired
    private UserService userService;

    @Autowired
    private SysUserDeptMapper sysUserDeptMapper;

    /* ========== 已有接口（保留） ========== */

    @GetMapping("/user/info")
    public Result<User> getCurrentUser(HttpServletRequest request) {
        String username = (String) request.getAttribute("username");
        User user = userService.getSafeUserByUsername(username);
        if (user != null) {
            return Result.success(user);
        }
        return Result.error(401, "用户不存在");
    }

    /* ========== 新增接口 ========== */

    /**
     * 当前登录用户修改密码
     * 前端传参：oldPassword、newPassword（query 或 form 表单）
     */
    @PostMapping("/user/change-password")
    public Result<?> changePassword(@RequestParam String oldPassword,
                                    @RequestParam String newPassword,
                                    HttpServletRequest request) {
        try {
            String username = resolveUsername(request);
            User user = userService.getUserByUsername(username);
            if (user == null) return Result.error(401, "用户不存在");
            userService.changePassword(user.getId(), oldPassword, newPassword);
            return Result.success("密码修改成功，请重新登录");
        } catch (RuntimeException e) {
            return Result.error(500, e.getMessage());
        }
    }

    /**
     * 当前登录用户修改个人信息（仅 phone/email/avatar）
     */
    @PutMapping("/user/profile")
    public Result<?> updateProfile(@RequestBody User user,
                                   HttpServletRequest request) {
        try {
            String username = resolveUsername(request);
            User current = userService.getUserByUsername(username);
            if (current == null) return Result.error(401, "用户不存在");
            user.setId(current.getId());
            userService.updateSelfProfile(user);
            return Result.success("个人信息更新成功");
        } catch (RuntimeException e) {
            return Result.error(500, e.getMessage());
        }
    }

    /**
     * 管理员新增用户（默认密码 123456）
     */
    @PostMapping("/admin/user/add")
    public Result<?> addUser(@RequestBody User user) {
        System.out.println("[ADD_USER] 进入方法, username=" + user.getUsername()); // ✅ 看是否打印
        try {
            userService.addUser(user);
            Long userId = user.getId(); // ✅ 拿到自增ID

            // 3. 保存新的多部门关联
            if (user.getDeptIds() != null && !user.getDeptIds().isEmpty()) {
                // 2. 删除原有部门关联
                //sysUserDeptMapper.deleteByUserId(user.getId());
                for (Long deptId : user.getDeptIds()) {
                    // 如果是主部门，is_main=1，否则0
                    int isMain = deptId.equals(user.getMainDeptId()) ? 1 : 0;
                    sysUserDeptMapper.insert(userId, deptId, isMain);
                }
                // 同步更新sys_user.dept_id（兼容旧逻辑）
                userService.updateDeptId(userId, user.getMainDeptId());
            }
            return Result.success("新增成功，默认密码：123456");
        } catch (RuntimeException e) {
            return Result.error(500, e.getMessage());
        }
    }

    /**
     * 管理员修改用户信息（realName/deptId/phone/email/avatar/role/status）
     */
    @PutMapping("/admin/user/update")
    public Result<?> updateUser(@RequestBody User user) {
        try {
            userService.updateUserInfo(user);
            // 3. 保存新的多部门关联
            if (user.getDeptIds() != null && !user.getDeptIds().isEmpty()) {
                // 2. 删除原有部门关联
                sysUserDeptMapper.deleteByUserId(user.getId());
                for (Long deptId : user.getDeptIds()) {
                    // 如果是主部门，is_main=1，否则0
                    int isMain = deptId.equals(user.getMainDeptId()) ? 1 : 0;
                    sysUserDeptMapper.insert(user.getId(), deptId, isMain);
                }
                // 同步更新sys_user.dept_id（兼容旧逻辑）
                userService.updateDeptId(user.getId(), user.getMainDeptId());
            }
            return Result.success("更新成功");
        } catch (RuntimeException e) {
            return Result.error(500, e.getMessage());
        }
    }

    /**
     * 管理员查询用户列表
     */
    @GetMapping("/admin/user/list")
    public Result<Map<String, Object>> getUserList(
            @RequestParam(required = false) String keyword,
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize) {
        List<User> list = userService.getList(keyword, pageNum, pageSize);
        int total = userService.getCount(keyword);
        // 清空密码再返回
        list.forEach(u -> u.setPassword(null));
        Map<String, Object> data = new HashMap<>();
        data.put("list", list);
        data.put("total", total);
        return Result.success(data);
    }

    /**
     * 管理员删除用户
     */

    @RequiresRoles("ADMIN")
    @DeleteMapping("/admin/user/{userId}")
    public Result<?> deleteUser(@PathVariable Long userId) {
        try {
            // 简单防误删：至少保留一个管理员
            User target = userService.getSafeUserById(userId);
            if (target == null) return Result.error(500, "用户不存在");
            // 这里可再加"不能删最后一个admin"的判断，先留简单版
            userService.updateUserInfo(new User() {{
                setId(userId); setStatus(0);
            }}); // 软删除：置为停用
            return Result.success("用户已停用");
        } catch (Exception e) {
            return Result.error(500, e.getMessage());
        }
    }

    /* ========== 私有方法 ========== */

    /**
     * 从请求头 Token 中解析当前用户名
     */
    private String resolveUsername(HttpServletRequest request) {
        String auth = request.getHeader("Authorization");
        if (auth == null || !auth.startsWith("Bearer ")) {
            throw new RuntimeException("未登录或Token格式错误");
        }
        String token = auth.substring(7);
        return jwtUtil.getUsernameFromToken(token);
    }

    /**
     * 分配角色
     */
    @RequiresRoles("ADMIN")
    @PostMapping("/user/assign-roles")
    public Result<?> assignRoles(@RequestParam Long userId,
                                 @RequestParam Long companyId,
                                 @RequestBody List<Long> roleIds) {
        userService.assignRoles(userId, companyId, roleIds);
        return Result.success("角色分配成功");
    }

    @GetMapping("/user/{userId}/roles")
    public Result<?> getUserRoles(@PathVariable Long userId) {
        List<String> roleIds = userService.selectRoleCodesByUserId(userId);
        return Result.success(roleIds);
    }

    @GetMapping("/user/{userId}/roleIds")
    public Result<?> getUserRoleIds(@PathVariable Long userId) {
        List<Long> roleIds = userService.selectRoleIdsByUserId(userId);
        return Result.success(roleIds);
    }

    @GetMapping("/user/depts/{userId}")
    public Result<?> getUserDepts(@PathVariable Long userId) {
        // 查用户所有部门ID
        List<Long> deptIds = sysUserDeptMapper.selectDeptIdsByUserId(userId);
        //List<Long> deptIds = new ArrayList<>();
        //deptIds.add(1L);
        // 查主部门ID
        Long mainDeptId = sysUserDeptMapper.selectMainDeptId(userId);
        Map<String, Object> data = new HashMap<>();
        data.put("deptIds", deptIds);
        data.put("mainDeptId", mainDeptId);
        return Result.success(data);
    }
}