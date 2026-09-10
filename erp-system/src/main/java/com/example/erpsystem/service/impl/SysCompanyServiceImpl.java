package com.example.erpsystem.service.impl;

import com.example.erpsystem.common.Result;
import com.example.erpsystem.entity.SysCompany;
import com.example.erpsystem.mapper.SysCompanyMapper;
import com.example.erpsystem.service.SysCompanyService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class SysCompanyServiceImpl implements SysCompanyService {

    @Autowired
    private SysCompanyMapper companyMapper;

    @Override
    public Result<?> page(String keyword, int pageNum, int pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        List<SysCompany> list = companyMapper.selectList(keyword, null, null);
        return Result.success(new PageInfo<>(list));
    }

    @Override
    public Result<?> listNormal() {
        return Result.success(companyMapper.selectAllNormal());
    }

    @Override
    public Result<?> getById(Long id) {
        return Result.success(companyMapper.selectById(id));
    }

    @Override
    public Result<?> add(SysCompany company) {
        company.setStatus(company.getStatus() == null ? 1 : company.getStatus());
        companyMapper.insert(company);
        return Result.success("新增成功");
    }

    @Override
    public Result<?> update(SysCompany company) {
        companyMapper.updateById(company);
        return Result.success("修改成功");
    }

    @Override
    public Result<?> delete(Long id) {
        // 校验该公司下是否还有用户绑定（sys_user_company_role）
        // 简化：直接删除；若需校验可在此扩展
        companyMapper.deleteById(id);
        return Result.success("删除成功");
    }
}
