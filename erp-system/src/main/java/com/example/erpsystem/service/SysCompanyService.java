package com.example.erpsystem.service;
import com.example.erpsystem.entity.SysCompany;
import com.github.pagehelper.PageInfo;
import java.util.List;
public interface SysCompanyService {
    PageInfo<SysCompany> page(String companyName, String status, int pageNum, int pageSize);
    SysCompany getById(Long id);
    List<SysCompany> listAll();
    void add(SysCompany c);
    void update(SysCompany c);
    void delete(Long id);
}
