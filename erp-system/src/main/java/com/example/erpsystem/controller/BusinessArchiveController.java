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
@RequestMapping("/archive")
public class BusinessArchiveController {

    @Autowired private BusinessArchiveService archiveService;

    @GetMapping("/list") public Result<PageInfo<BusinessArchive>> list(BusinessArchive q, @RequestParam int pageNum, @RequestParam int pageSize){ return Result.success(archiveService.page(q, pageNum, pageSize)); }
    @PostMapping("/refresh/{orderId}") public Result<BusinessArchive> refresh(@RequestParam Long companyId, @PathVariable Long orderId){ return Result.success(archiveService.refresh(companyId, orderId)); }

}
