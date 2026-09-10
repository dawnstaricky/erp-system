package com.example.erpsystem.service;

import com.example.erpsystem.entity.SysDepartment;
import com.example.erpsystem.mapper.SysDepartmentMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class SysDepartmentService {
    @Autowired
    private SysDepartmentMapper departmentMapper;

    public List<SysDepartment> getAllNormal() {
        return departmentMapper.selectAllNormal();
    }

    public void add(SysDepartment dept) {
        departmentMapper.insert(dept);
    }

    public void update(SysDepartment dept) {
        departmentMapper.updateById(dept);
    }

    public void delete(Long id) {
        departmentMapper.deleteById(id);
    }

    public List<Map<String, Object>> getDeptUsers(Long deptId) {
        return departmentMapper.selectUsersByDeptId(deptId);
    }
}
