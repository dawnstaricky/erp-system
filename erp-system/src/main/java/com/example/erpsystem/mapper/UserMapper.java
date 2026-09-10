package com.example.erpsystem.mapper;

import com.example.erpsystem.entity.User;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface UserMapper {

    // 按用户名查询（由 XML 实现，不再用注解，避免和 XML 重复）
    User findByUsername(@Param("username") String username);

    // 新增
    int insert(User user);

    // 按ID查询
    User selectById(@Param("id") Long id);

    // 管理员修改用户信息
    int updateById(User user);

    // 修改密码
    int updatePassword(@Param("id") Long id, @Param("password") String password);

    // 按用户名查询（XML里也定义了，供新增用户时查重用）
    User selectByUsername(@Param("username") String username);

    // 列表查询
    List<User> selectList(@Param("keyword") String keyword,
                          @Param("offset") int offset,
                          @Param("pageSize") int pageSize);

    // 总数
    int count(@Param("keyword") String keyword);

    /**
     * 删除用户所有角色关联
     */
    @Delete("DELETE FROM user_role WHERE user_id = #{userId}")
    void deleteUserRoles(@Param("userId") Long userId);

    /**
     * 批量插入用户角色关联
     */
    void insertUserRoles(@Param("userId") Long userId, @Param("roleIds") List<Long> roleIds);

    /**
     * 查询用户角色编码列表（用于登录返回）
     */
    @Select({
            "SELECT r.role_code FROM sys_role r",
            "LEFT JOIN user_role ur ON r.id = ur.role_id",
            "WHERE ur.user_id = #{userId} AND r.status = 1"
    })
    List<String> selectRoleCodesByUserId(@Param("userId") Long userId);

    @Select({
            "SELECT r.id FROM sys_role r",
            "LEFT JOIN user_role ur ON r.id = ur.role_id",
            "WHERE ur.user_id = #{userId} AND r.status = 1"
    })
    List<Long> selectRoleIdsByUserId(@Param("userId") Long userId);

    @Update("UPDATE sys_user SET dept_id = #{deptId} WHERE id = #{userId}")
    void updateDeptId(@Param("userId") Long userId, @Param("deptId") Long deptId);
}
