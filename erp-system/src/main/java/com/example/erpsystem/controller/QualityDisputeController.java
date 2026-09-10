package com.example.erpsystem.controller;

import com.example.erpsystem.common.Result;
import com.example.erpsystem.entity.QualityDispute;
import com.example.erpsystem.service.QualityDisputeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import javax.servlet.http.HttpServletRequest;
import java.util.Map;

@RestController
@RequestMapping("/api/dispute")
public class QualityDisputeController {

    @Autowired private QualityDisputeService disputeService;

    @GetMapping("/list")
    public Result<?> list(@RequestParam Map<String, Object> params, HttpServletRequest request) {
        params.put("companyId", com.example.erpsystem.common.CompanyContext.getCurrentCompanyId(request));
        return disputeService.page(params);
    }

    @PostMapping("/create")
    public Result<?> create(@RequestBody QualityDispute dispute, HttpServletRequest request) {
        return disputeService.create(dispute, request);
    }

    @PutMapping("/handle/{id}")
    public Result<?> handle(@PathVariable Long id, @RequestBody QualityDispute form) {
        return disputeService.handle(id, form);
    }
}
