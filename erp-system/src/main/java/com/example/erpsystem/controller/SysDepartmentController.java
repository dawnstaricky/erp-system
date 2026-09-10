package com.example.erpsystem.controller;

import com.example.erpsystem.annotation.RequiresRoles;
import com.example.erpsystem.common.Result;
import com.example.erpsystem.entity.SysDepartment;
import com.example.erpsystem.service.SysDepartmentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/dept")
@RequiresRoles({"ADMIN"})
public class SysDepartmentController {
    @Autowired
    private SysDepartmentService departmentService;

    // 部门列表
    @GetMapping("/list")
    public Result<List<SysDepartment>> list() {
        return Result.success(departmentService.getAllNormal());
    }

    // 新增部门
    @PostMapping("/add")
    public Result<?> add(@RequestBody SysDepartment dept) {
        departmentService.add(dept);
        return Result.success("新增成功");
    }

    // 更新部门
    @PostMapping("/update")
    public Result<?> update(@RequestBody SysDepartment dept) {
        departmentService.update(dept);
        return Result.success("更新成功");
    }

    // 删除部门
    @PostMapping("/delete/{id}")
    public Result<?> delete(@PathVariable Long id) {
        departmentService.delete(id);
        return Result.success("删除成功");
    }

    // 部门下用户列表
    @GetMapping("/users/{deptId}")
    public Result<List<Map<String, Object>>> getDeptUsers(@PathVariable Long deptId) {
        return Result.success(departmentService.getDeptUsers(deptId));
    }
}
