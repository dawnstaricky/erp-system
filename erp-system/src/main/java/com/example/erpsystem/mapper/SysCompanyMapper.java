package com.example.erpsystem.mapper;

import com.example.erpsystem.entity.*;
import org.apache.ibatis.annotations.*;
import java.util.List;

@Mapper
public interface SysCompanyMapper {

    List<SysCompany> selectList(@Param("companyName") String companyName, @Param("status") String status);
    SysCompany selectById(@Param("id") Long id);
    List<SysCompany> selectAll();
    int insert(SysCompany c);
    int updateById(SysCompany c);
    int deleteById(@Param("id") Long id);

}
