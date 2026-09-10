package com.example.erpsystem.service;

import com.example.erpsystem.entity.Supplier;
import com.example.erpsystem.mapper.SupplierMapper;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class SupplierService {
    @Autowired
    private SupplierMapper supplierMapper;

    public PageInfo<Supplier> getList(int pageNum, int pageSize, String keyword) {
        PageHelper.startPage(pageNum, pageSize);
        return new PageInfo<>(supplierMapper.getList(keyword));
    }

    public int add(Supplier supplier) { return supplierMapper.insert(supplier); }
    public int update(Supplier supplier) { return supplierMapper.update(supplier); }
    public Supplier getById(Long id) { return supplierMapper.selectById(id); }
    public int delete(Long id) { return supplierMapper.deleteById(id); }
}