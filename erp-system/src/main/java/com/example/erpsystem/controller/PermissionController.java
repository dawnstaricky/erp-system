package com.example.erpsystem.controller;

import com.example.erpsystem.annotation.RequiresRoles;
import com.example.erpsystem.common.Result;
import com.example.erpsystem.entity.Permission;
import com.example.erpsystem.mapper.PermissionMapper;
import com.example.erpsystem.mapper.RolePermissionMapper;
import lombok.Data;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/permission")
public class PermissionController {
    @Autowired
    private PermissionMapper permissionMapper;

    @Autowired
    private RolePermissionMapper rolePermissionMapper;

    /**
     * 权限列表查询
     */
    @RequiresRoles("ADMIN")
    @GetMapping("/list")
    public Result<?> list(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) String permissionName,
            @RequestParam(required = false) String apiPath) {
        //return Result.success(permissionMapper.selectAll());
        int offset = (pageNum - 1) * pageSize;

        // ✅ 分页查询
        List<Permission> list = permissionMapper.selectPage(permissionName, apiPath, offset, pageSize);
        long total = permissionMapper.selectCount(permissionName, apiPath);

        // ✅ 返回前端期待的格式 { list, total }
        Map<String, Object> data = new HashMap<>();
        data.put("list", list);
        data.put("total", total);
        return Result.success(data);
    }

    /**
     * 新增权限
     */
    @RequiresRoles("ADMIN")
    @PostMapping("/add")
    public Result<?> add(@RequestBody Permission permission) {
        permissionMapper.insert(permission);
        return Result.success("新增成功");
    }

    /**
     * 更新权限
     */
    @RequiresRoles("ADMIN")
    @PutMapping("/update")
    public Result<?> update(@RequestBody Permission permission) {
        permissionMapper.update(permission);
        return Result.success("更新成功");
    }

    /**
     * 删除权限
     */
    @RequiresRoles("ADMIN")
    @DeleteMapping("/{id}")
    public Result<?> delete(@PathVariable Long id) {
        permissionMapper.deleteById(id);
        return Result.success("删除成功");
    }

    /**
     * 获取角色权限
     */
    @RequiresRoles("ADMIN")
    @GetMapping("/role/{roleId}")
    public Result<List<Permission>> getRolePermissions(@PathVariable Long roleId) {
        return Result.success(permissionMapper.selectByRoleId(roleId));
    }

    /**
     * 分配角色权限
     */
    @RequiresRoles("ADMIN")
    @PostMapping("/assign")
    public Result<?> assignRolePermissions(@RequestBody RolePermissionDTO dto) {
        // 先删除原有权限
        rolePermissionMapper.deleteByRoleId(dto.getRoleId());
        // 插入新权限
        if (dto.getPermissionIds() != null && !dto.getPermissionIds().isEmpty()) {
            rolePermissionMapper.insertBatch(dto.getRoleId(), dto.getPermissionIds());
        }
        return Result.success("权限分配成功");
    }

    /**
     * DTO类
     */
    @Data
    public static class RolePermissionDTO {
        private Long roleId;
        private List<Long> permissionIds;
    }
}