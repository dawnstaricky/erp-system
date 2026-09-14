package com.example.erpsystem.service.impl;
import com.example.erpsystem.entity.SysCompany;
import com.example.erpsystem.mapper.SysCompanyMapper;
import com.example.erpsystem.service.SysCompanyService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
@Service
public class SysCompanyServiceImpl implements SysCompanyService {
    @Autowired private SysCompanyMapper mapper;
    public PageInfo<SysCompany> page(String name, String status, int pageNum, int pageSize){
        PageHelper.startPage(pageNum, pageSize);
        return new PageInfo<>(mapper.selectList(name, status));
    }
    public SysCompany getById(Long id){ return mapper.selectById(id); }
    public List<SysCompany> listAll(){ return mapper.selectAll(); }
    @Transactional public void add(SysCompany c){ if(c.getStatus()==null) c.setStatus("1"); mapper.insert(c); }
    @Transactional public void update(SysCompany c){ mapper.updateById(c); }
    @Transactional public void delete(Long id){ mapper.deleteById(id); }
}
