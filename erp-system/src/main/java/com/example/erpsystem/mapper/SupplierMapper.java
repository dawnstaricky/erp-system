package com.example.erpsystem.mapper;

import com.example.erpsystem.entity.Supplier;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface SupplierMapper {
    List<Supplier> getList(String keyword);
    int insert(Supplier supplier);
    int update(Supplier supplier);
    Supplier selectById(Long id);
    int deleteById(Long id);
    // 在现有SupplierMapper.java中添加
    @Select("SELECT * FROM supplier WHERE supplier_code = #{code} AND status = 1")
    Supplier selectByCode(String code);
}