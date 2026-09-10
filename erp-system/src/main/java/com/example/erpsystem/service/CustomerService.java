package com.example.erpsystem.service;

import com.example.erpsystem.entity.Customer;
import com.example.erpsystem.mapper.CustomerMapper;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class CustomerService {
    @Autowired
    private CustomerMapper customerMapper;

    public PageInfo<Customer> getList(int pageNum, int pageSize, String keyword) {
        PageHelper.startPage(pageNum, pageSize);
        return new PageInfo<>(customerMapper.getList(keyword));
    }

    public int add(Customer customer) { return customerMapper.insert(customer); }
    public int update(Customer customer) { return customerMapper.update(customer); }
    public Customer getById(Long id) { return customerMapper.selectById(id); }
    public int delete(Long id) { return customerMapper.deleteById(id); }
}