package com.example.erpsystem.controller;

import com.example.erpsystem.annotation.RequiresRoles;
import com.example.erpsystem.common.Result;
import com.example.erpsystem.entity.*;
import com.example.erpsystem.dto.ContractGenDTO;
import com.example.erpsystem.service.*;
import com.github.pagehelper.PageInfo;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/sys/company")
public class SysCompanyController {

    @Autowired private SysCompanyService companyService;

    @RequiresRoles("ADMIN")
    @GetMapping("/page") public Result<PageInfo<SysCompany>> page(@RequestParam(defaultValue="") String companyName, @RequestParam(defaultValue="") String status, @RequestParam int pageNum, @RequestParam int pageSize){
        return Result.success(companyService.page(companyName, status, pageNum, pageSize));
    }
    @RequiresRoles("ADMIN")
    @GetMapping("/all") public Result<List<SysCompany>> all(){ return Result.success(companyService.listAll()); }
    @RequiresRoles("ADMIN")
    @GetMapping("/{id}") public Result<SysCompany> get(@PathVariable Long id){ return Result.success(companyService.getById(id)); }
    @RequiresRoles("ADMIN")
    @PostMapping public Result<Void> add(@RequestBody SysCompany c){ companyService.add(c); return Result.success(); }
    @RequiresRoles("ADMIN")
    @PutMapping public Result<Void> update(@RequestBody SysCompany c){ companyService.update(c); return Result.success(); }
    @RequiresRoles("ADMIN")
    @DeleteMapping("/{id}") public Result<Void> delete(@PathVariable Long id){ companyService.delete(id); return Result.success(); }

}
