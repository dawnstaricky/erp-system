package com.example.erpsystem.service.impl;
import com.example.erpsystem.entity.SysUserCompanyRole;
import com.example.erpsystem.mapper.SysUserCompanyRoleMapper;
import com.example.erpsystem.service.SysUserCompanyRoleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
@Service
public class SysUserCompanyRoleServiceImpl implements SysUserCompanyRoleService {
    @Autowired private SysUserCompanyRoleMapper mapper;
    public List<SysUserCompanyRole> getCompaniesByUserId(Long userId){ return mapper.selectCompaniesByUserId(userId); }
    @Transactional public void assignCompanies(Long userId, List<SysUserCompanyRole> list){
        mapper.deleteByUserId(userId);
        if(list!=null && !list.isEmpty()) mapper.insertBatch(list);
    }
}
