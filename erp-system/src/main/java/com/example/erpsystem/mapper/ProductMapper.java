package com.example.erpsystem.mapper;

import com.example.erpsystem.entity.Product;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface ProductMapper {

    List<Product> getList(String keyword);

    int insert(Product product);

    int update(Product product);

    Product selectById(Long id);

    int deleteById(Long id);

    // 在现有ProductMapper.java中添加
    @Select("SELECT * FROM product WHERE sku_code = #{skuCode} AND status = 1")
    Product selectBySkuCode(String skuCode);
}