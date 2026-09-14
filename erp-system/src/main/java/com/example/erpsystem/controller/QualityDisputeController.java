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
@RequestMapping("/dispute")
public class QualityDisputeController {

    @Autowired private QualityDisputeService disputeService;

    @GetMapping("/list") public Result<PageInfo<QualityDispute>> list(QualityDispute q, @RequestParam int pageNum, @RequestParam int pageSize){ return Result.success(disputeService.page(q, pageNum, pageSize)); }
    @PostMapping("/create") public Result<Long> create(@RequestBody QualityDispute d){ return Result.success(disputeService.create(d)); }
    /** 处理并自动联动财务：扣减应付(采购侧) / 减免应收(销售侧)，带扣款明细 */
    @PostMapping("/handle/{id}") public Result<Void> handle(@PathVariable Long id, @RequestParam String handleMethod, @RequestParam(required=false) String adjustType, @RequestParam(required=false) java.math.BigDecimal adjustedAmount, @RequestParam(required=false) String adjustedBillNo, @RequestParam(required=false) String adjustRemark){ disputeService.handle(id, handleMethod, adjustType, adjustedAmount, adjustedBillNo, adjustRemark); return Result.success(); }

}
