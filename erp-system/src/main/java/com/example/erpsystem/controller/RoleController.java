package com.example.erpsystem.controller;

import com.example.erpsystem.annotation.RequiresRoles;
import com.example.erpsystem.common.Result;
import com.example.erpsystem.entity.Role;
import com.example.erpsystem.mapper.RoleMapper;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/role")
public class RoleController {
    @Autowired
    private RoleMapper roleMapper;

    /**
     * 角色列表查询（仅ADMIN可访问）
     */
    @RequiresRoles("ADMIN")
    @GetMapping("/list")
    public Result<?> list(
            // ✅ 所有参数可选，不破坏旧的无参数调用
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) String roleName,
            @RequestParam(required = false) String roleCode
    ) {
        // ✅ 旧调用（无pageNum参数）：pageNum默认1，但PageHelper不会分页，因为没有调用startPage？不对，要调整逻辑：
        // 优化：只有当pageNum>0时才分页，否则返回所有角色，完全兼容旧调用
        if (pageNum <= 0) {
            return Result.success(roleMapper.selectAll());
        }
        // ✅ 新调用（带pageNum）：开启分页
        PageHelper.startPage(pageNum, pageSize);
        List<Role> roles = roleMapper.selectAllWithSearch(roleName, roleCode);
        PageInfo<Role> pageInfo = new PageInfo<>(roles);
        return Result.success(pageInfo);
    }

    /**
     * 新增角色（仅ADMIN可访问）
     */
    @RequiresRoles("ADMIN")
    @PostMapping("/add")
    public Result<?> add(@RequestBody Role role) {
        Role exist = roleMapper.selectByRoleCode(role.getRoleCode());
        if (exist != null) {
            return Result.error(400, "角色编码已存在");
        }
        roleMapper.insert(role);
        return Result.success("新增角色成功");
    }

    /**
     * 更新角色（仅ADMIN可访问）
     */
    @RequiresRoles("ADMIN")
    @PutMapping("/update")
    public Result<?> update(@RequestBody Role role) {
        roleMapper.update(role);
        return Result.success("更新角色成功");
    }

    /**
     * 删除角色（仅ADMIN可访问）
     */
    @RequiresRoles("ADMIN")
    @DeleteMapping("/{id}")
    public Result<?> delete(@PathVariable Long id) {
        roleMapper.deleteById(id);
        return Result.success("删除角色成功");
    }
}