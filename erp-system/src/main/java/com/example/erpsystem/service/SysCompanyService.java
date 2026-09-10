package com.example.erpsystem.service;

import com.example.erpsystem.common.Result;
import com.example.erpsystem.entity.SysCompany;

public interface SysCompanyService {
    Result<?> page(String keyword, int pageNum, int pageSize);
    Result<?> listNormal();
    Result<?> getById(Long id);
    Result<?> add(SysCompany company);
    Result<?> update(SysCompany company);
    Result<?> delete(Long id);
}
