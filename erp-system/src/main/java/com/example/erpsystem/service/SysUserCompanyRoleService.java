package com.example.erpsystem.service;
import com.example.erpsystem.entity.SysUserCompanyRole;
import java.util.List;
public interface SysUserCompanyRoleService {
    List<SysUserCompanyRole> getCompaniesByUserId(Long userId);
    void assignCompanies(Long userId, List<SysUserCompanyRole> list);
}
