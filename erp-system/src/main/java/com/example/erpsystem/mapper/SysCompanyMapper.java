package com.example.erpsystem.mapper;

import com.example.erpsystem.entity.SysCompany;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface SysCompanyMapper {
    int insert(SysCompany company);
    int updateById(SysCompany company);
    int deleteById(@Param("id") Long id);
    SysCompany selectById(@Param("id") Long id);
    List<SysCompany> selectList(@Param("keyword") String keyword,
                                @Param("offset") Integer offset,
                                @Param("limit") Integer limit);
    Long countList(@Param("keyword") String keyword);
    List<SysCompany> selectAllNormal(); // 状态正常（用于下拉）
}
