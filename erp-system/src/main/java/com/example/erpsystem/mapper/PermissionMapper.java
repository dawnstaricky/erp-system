package com.example.erpsystem.mapper;

import com.example.erpsystem.entity.Permission;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface PermissionMapper {
    List<Permission> selectAll();
    Permission selectById(@Param("id") Long id);
    int insert(Permission permission);
    int update(Permission permission);
    int deleteById(@Param("id") Long id);

    // 按接口路径+方法查所需角色编码
    List<String> selectRolesByApi(@Param("apiPath") String apiPath,
                                  @Param("apiMethod") String apiMethod);

    // 按角色ID查该角色拥有的权限
    List<Permission> selectByRoleId(@Param("roleId") Long roleId);

    // ✅ 新增：分页查询
    List<Permission> selectPage(@Param("permissionName") String permissionName,
                                @Param("apiPath") String apiPath,
                                @Param("offset") int offset,
                                @Param("pageSize") int pageSize);

    // ✅ 新增：查询总数
    long selectCount(@Param("permissionName") String permissionName,
                     @Param("apiPath") String apiPath);
}