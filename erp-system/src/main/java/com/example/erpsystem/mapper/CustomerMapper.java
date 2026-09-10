package com.example.erpsystem.mapper;

import com.example.erpsystem.entity.Customer;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface CustomerMapper {
    List<Customer> getList(String keyword);
    int insert(Customer customer);
    int update(Customer customer);
    Customer selectById(Long id);
    int deleteById(Long id);

    @Select("SELECT * FROM customer WHERE customer_code = #{code} AND status = 1")
    Customer selectByCode(String code);
}