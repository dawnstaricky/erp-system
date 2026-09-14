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
@RequestMapping("/sys/user-company")
public class SysUserCompanyRoleController {

    @Autowired private SysUserCompanyRoleService ucService;

    @RequiresRoles("ADMIN")
    @GetMapping("/{userId}") public Result<List<SysUserCompanyRole>> get(@PathVariable Long userId){ return Result.success(ucService.getCompaniesByUserId(userId)); }
    @RequiresRoles("ADMIN")
    @PostMapping("/assign") public Result<Void> assign(@RequestParam Long userId, @RequestBody List<SysUserCompanyRole> list){ ucService.assignCompanies(userId, list); return Result.success(); }

}
