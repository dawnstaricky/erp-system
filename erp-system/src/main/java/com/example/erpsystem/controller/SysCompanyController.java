package com.example.erpsystem.controller;

import com.example.erpsystem.common.Result;
import com.example.erpsystem.entity.SysCompany;
import com.example.erpsystem.service.SysCompanyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/admin/company")
public class SysCompanyController {

    @Autowired
    private SysCompanyService companyService;

    @GetMapping("/list")
    public Result<?> list(@RequestParam(required = false) String keyword,
                          @RequestParam(defaultValue = "1") int pageNum,
                          @RequestParam(defaultValue = "10") int pageSize) {
        return companyService.page(keyword, pageNum, pageSize);
    }

    @GetMapping("/all")
    public Result<?> all() {
        return companyService.listNormal();
    }

    @GetMapping("/{id}")
    public Result<?> get(@PathVariable Long id) {
        return companyService.getById(id);
    }

    @PostMapping("/add")
    public Result<?> add(@RequestBody SysCompany company) {
        return companyService.add(company);
    }

    @PutMapping("/update")
    public Result<?> update(@RequestBody SysCompany company) {
        return companyService.update(company);
    }

    @DeleteMapping("/{id}")
    public Result<?> delete(@PathVariable Long id) {
        return companyService.delete(id);
    }
}
