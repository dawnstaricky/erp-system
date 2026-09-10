package com.example.erpsystem.mapper;

import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface SysUserDeptMapper {
    /**
     * 新增用户-部门关联
     */
    @Insert("""
        INSERT INTO sys_user_dept (user_id, dept_id, is_main)
        VALUES (#{userId}, #{deptId}, #{isMain})
    """)
    void insert(@Param("userId") Long userId, @Param("deptId") Long deptId, @Param("isMain") Integer isMain);

    /**
     * 删除用户所有部门关联
     */
    @Delete("DELETE FROM sys_user_dept WHERE user_id = #{userId}")
    void deleteByUserId(Long userId);

    /**
     * 查询用户所有部门ID（包含主部门）
     */
    @Select("""
        SELECT dept_id FROM sys_user_dept WHERE user_id = #{userId} ORDER BY is_main DESC
    """)
    List<Long> selectDeptIdsByUserId(Long userId);

    /**
     * 查询部门下所有用户ID
     */
    @Select("""
        SELECT user_id FROM sys_user_dept WHERE dept_id = #{deptId}
    """)
    List<Long> selectUserIdsByDeptId(Long userId);

    /**
     * 设置用户主部门
     */
    @Update("""
        UPDATE sys_user_dept SET is_main = 0 WHERE user_id = #{userId}
    """)
    void resetMainDept(@Param("userId") Long userId);

    /**
     * 查询用户主部门ID（兼容原有sys_user.dept_id逻辑）
     */
    @Select("""
        SELECT dept_id FROM sys_user_dept WHERE user_id = #{userId} AND is_main = 1
    """)
    Long selectMainDeptId(Long userId);
}