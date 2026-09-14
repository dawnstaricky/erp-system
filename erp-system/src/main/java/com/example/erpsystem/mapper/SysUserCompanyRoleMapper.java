package com.example.erpsystem.mapper;

import com.example.erpsystem.entity.*;
import org.apache.ibatis.annotations.*;
import java.util.List;

@Mapper
public interface SysUserCompanyRoleMapper {

    List<SysUserCompanyRole> selectCompaniesByUserId(@Param("userId") Long userId);
    List<Long> selectCompanyIdsByUserId(@Param("userId") Long userId);
    SysUserCompanyRole selectByUserCompany(@Param("userId") Long userId, @Param("companyId") Long companyId);
    int insert(SysUserCompanyRole r);
    int insertBatch(@Param("list") List<SysUserCompanyRole> list);
    int deleteByUserId(@Param("userId") Long userId);
    int deleteByUserCompany(@Param("userId") Long userId, @Param("companyId") Long companyId);

}
