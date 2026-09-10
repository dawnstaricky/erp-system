package com.example.erpsystem.mapper;

import com.example.erpsystem.entity.SysUserCompanyRole;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface SysUserCompanyRoleMapper {

    int insert(SysUserCompanyRole ucr);

    int deleteByUser(@Param("userId") Long userId);

    int delete(@Param("id") Long id);

    List<SysUserCompanyRole> selectByUser(@Param("userId") Long userId);

    /** 取某用户在某公司的角色 code 列表（权限校验用） */
    List<String> selectRoleCodes(@Param("userId") Long userId, @Param("companyId") Long companyId);

    /** 取某用户可进入的公司列表（带公司名称） */
    List<SysUserCompanyRole> selectCompaniesByUser(@Param("userId") Long userId);

    /** 取某用户可进入的公司及其角色 code 集合（用于登录返回） */
    List<Map<String, Object>> selectCompanyRolesByUserId(@Param("userId") Long userId);
}
