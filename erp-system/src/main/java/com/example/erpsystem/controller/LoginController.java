package com.example.erpsystem.controller;

import com.example.erpsystem.common.Result;
import com.example.erpsystem.entity.LoginDTO;
import com.example.erpsystem.entity.User;
import com.example.erpsystem.mapper.SysCompanyMapper;
import com.example.erpsystem.mapper.SysUserCompanyRoleMapper;
import com.example.erpsystem.service.UserService;
import com.example.erpsystem.util.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.Arrays;

@RestController
public class LoginController {

    @Autowired
    private UserService userService;
    @Autowired
    private JwtUtil jwtUtil;
    @Autowired
    private SysUserCompanyRoleMapper userCompanyRoleMapper;
    @Autowired
    private SysCompanyMapper companyMapper;

    /**
     * 组装"当前用户可进入的公司列表"。
     * - 管理员(ADMIN)不绑定公司 → companies 为空，前端仅展示管理类菜单
     * - 业务用户 → 返回其被分配到且状态正常的公司，含在该公司的角色 code
     */
    private List<Map<String, Object>> buildCompanies(Long userId, List<String> roles) {
        boolean isAdmin = roles != null && roles.contains("ADMIN");
        if (isAdmin) {
            return Collections.emptyList(); // 管理员不绑定具体公司
        }
        List<Map<String, Object>> list = userCompanyRoleMapper.selectCompanyRolesByUserId(userId);
        // roleCodes 为逗号分隔字符串，拆分为 List 供前端使用
        for (Map<String, Object> m : list) {
            Object rc = m.get("roleCodes");
            if (rc instanceof String && ((String) rc).length() > 0) {
                m.put("roleCodes", Arrays.asList(((String) rc).split(",")));
            } else {
                m.put("roleCodes", Collections.emptyList());
            }
        }
        return list;
    }

    @PostMapping("/login")
    public Result<Map<String, Object>> login(@RequestBody LoginDTO loginDTO) {
        User user = userService.login(loginDTO.getUsername(), loginDTO.getPassword());
        if (user == null) {
            return Result.error(401, "用户名或密码错误");
        }
        List<String> roles = userService.selectRoleCodesByUserId(user.getId());
        String token = jwtUtil.generateToken(
                user.getUsername(), user.getId(), user.getRealName(), roles);

        Map<String, Object> data = new HashMap<>();
        data.put("token", token);
        data.put("tokenHead", "Bearer ");
        data.put("userId", user.getId());
        data.put("username", user.getUsername());
        data.put("realName", user.getRealName());
        data.put("roles", roles);
        data.put("role", roles.isEmpty() ? null : roles.get(0));
        data.put("companies", buildCompanies(user.getId(), roles)); // 前端下拉用
        return Result.success(data);
    }

    @GetMapping("/login")
    public Result<Map<String, Object>> login(@RequestParam String username,
                                             @RequestParam String password) {
        LoginDTO dto = new LoginDTO();
        dto.setUsername(username);
        dto.setPassword(password);
        return login(dto);
    }

    /** 获取当前用户信息（前端 useUserStore.fetchUserInfo 调用） */
    @GetMapping("/user/info")
    public Result<Map<String, Object>> info(HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        String username = (String) request.getAttribute("username");
        List<String> roles = (List<String>) request.getAttribute("roles");

        Map<String, Object> data = new HashMap<>();
        data.put("userId", userId);
        data.put("username", username);
        data.put("roles", roles);
        if (userId != null) {
            data.put("companies", buildCompanies(userId, roles));
            // 拉取用户基础信息（部门、姓名等）
            try {
                User u = userService.getById(userId);
                if (u != null) data.put("realName", u.getRealName());
            } catch (Exception ignored) {}
        }
        return Result.success(data);
    }

    @GetMapping("/test")
    public Result<String> test(HttpServletRequest request) {
        String username = (String) request.getAttribute("username");
        return Result.success("你好，" + username + "！Token验证通过。");
    }
}
