package com.example.erpsystem.mapper;

import com.example.erpsystem.entity.SysDepartment;
import org.apache.ibatis.annotations.*;

import java.util.List;
import java.util.Map;

@Mapper
public interface SysDepartmentMapper {
    @Select("""
        SELECT * FROM sys_department 
        WHERE status = 1 
        ORDER BY sort ASC, id ASC
    """)
    List<SysDepartment> selectAllNormal();

    @Select("""
        SELECT * FROM sys_department WHERE id = #{id}
    """)
    SysDepartment selectById(Long id);

    @Insert("""
        INSERT INTO sys_department (dept_name, parent_id, sort, leader, phone, email, status)
        VALUES (#{deptName}, #{parentId}, #{sort}, #{leader}, #{phone}, #{email}, #{status})
    """)
    @Options(useGeneratedKeys = true, keyProperty = "id")
    void insert(SysDepartment dept);

    @Update("""
        UPDATE sys_department 
        SET dept_name = #{deptName}, parent_id = #{parentId}, sort = #{sort},
            leader = #{leader}, phone = #{phone}, email = #{email}, status = #{status},
            updated_at = NOW()
        WHERE id = #{id}
    """)
    void updateById(SysDepartment dept);

    @Delete("DELETE FROM sys_department WHERE id = #{id}")
    void deleteById(Long id);

    // 查部门下的用户（用于部门管理展示）
    @Select("""
        SELECT u.id, u.username, u.real_name, u.phone
        FROM sys_user u
        JOIN sys_user_dept ud ON u.id = ud.user_id
        WHERE ud.dept_id = #{deptId} AND u.status = 1
    """)
    List<Map<String, Object>> selectUsersByDeptId(Long deptId);
}