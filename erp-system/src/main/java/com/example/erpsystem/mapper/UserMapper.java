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
    // 角色来源改为 sys_user_company_role（三元关系：用户-公司-角色）
    //@Delete("DELETE FROM sys_user_company_role WHERE user_id = #{userId}")
    //void deleteUserRoles(@Param("userId") Long userId);

    @Insert("<script>"
            + "INSERT INTO sys_user_company_role(user_id, company_id, role_id) VALUES "
            + "<foreach collection='roleIds' item='rid' separator=','>(#{userId}, 1, #{rid})</foreach>"
            + "</script>")
    void insertUserRoles(@Param("userId") Long userId, @Param("roleIds") List<Long> roleIds);

    /**
     * 批量插入用户角色关联
     */

    // 替换原 insertUserRoles 方法
    int insertUserCompanyRoles(@Param("userId") Long userId, @Param("companyId") Long companyId, @Param("roleIds") List<Long> roleIds);

    int deleteUserCompanyRoles(@Param("userId") Long userId, @Param("companyId") Long companyId);

    /**
     * 查询用户角色编码列表（用于登录返回）
     */
    // 角色编码：取用户在任一公司拥有的角色（去重）
    @Select("SELECT DISTINCT r.role_code FROM sys_role r "
            + "JOIN sys_user_company_role ucr ON r.id = ucr.role_id "
            + "WHERE ucr.user_id = #{userId} AND r.status = 1")
    List<String> selectRoleCodesByUserId(@Param("userId") Long userId);

    @Select("SELECT DISTINCT r.id FROM sys_role r "
            + "JOIN sys_user_company_role ucr ON r.id = ucr.role_id "
            + "WHERE ucr.user_id = #{userId} AND r.status = 1")
    List<Long> selectRoleIdsByUserId(@Param("userId") Long userId);

    /** 多公司：返回用户可访问的公司（含各公司角色），供登录返回 */
    @Select("SELECT DISTINCT ucr.company_id AS companyId, c.company_name AS companyName, "
            + "r.id AS roleId, r.role_code AS roleCode "
            + "FROM sys_user_company_role ucr "
            + "JOIN sys_company c ON c.id = ucr.company_id "
            + "JOIN sys_role r ON r.id = ucr.role_id "
            + "WHERE ucr.user_id = #{userId} AND c.status = '1' AND r.status = 1 "
            + "ORDER BY ucr.company_id, r.id")
    List<com.example.erpsystem.entity.SysUserCompanyRole> selectCompaniesByUserId(@Param("userId") Long userId);

    @Update("UPDATE sys_user SET dept_id = #{deptId} WHERE id = #{userId}")
    void updateDeptId(@Param("userId") Long userId, @Param("deptId") Long deptId);
}
