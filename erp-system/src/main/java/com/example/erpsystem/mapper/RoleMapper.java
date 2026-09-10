package com.example.erpsystem.mapper;

import com.example.erpsystem.entity.Role;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface RoleMapper {
    /**
     * 查询所有角色
     */
    List<Role> selectAll();

    /**
     * 根据ID查询角色
     */
    Role selectById(@Param("id") Long id);

    /**
     * 新增角色
     */
    int insert(Role role);

    /**
     * 更新角色
     */
    int update(Role role);

    /**
     * 删除角色
     */
    int deleteById(@Param("id") Long id);
    //新增带搜索的分页查询方法，和你刚加的Controller对应
    List<Role> selectAllWithSearch(
            @Param("roleName") String roleName,
            @Param("roleCode") String roleCode
    );

    Role selectByRoleCode(String roleCode);

}