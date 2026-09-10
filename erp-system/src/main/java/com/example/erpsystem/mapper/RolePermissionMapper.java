package com.example.erpsystem.mapper;

import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface RolePermissionMapper {
    // 删除角色的所有权限
    @Delete("DELETE FROM sys_role_permission WHERE role_id = #{roleId}")
    void deleteByRoleId(@Param("roleId") Long roleId);

    // 批量插入角色权限
    void insertBatch(@Param("roleId") Long roleId,
                     @Param("permissionIds") List<Long> permissionIds);
}