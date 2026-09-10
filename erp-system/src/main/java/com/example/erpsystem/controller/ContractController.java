package com.example.erpsystem.controller;

import com.example.erpsystem.common.Result;
import com.example.erpsystem.service.ContractService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import javax.servlet.http.HttpServletResponse;

@RestController
@RequestMapping("/api/contract")
public class ContractController {

    @Autowired private ContractService contractService;

    /** 采购订单 → 生成采购合同并下载 .xlsx */
    @PostMapping("/purchase/generate/{orderId}")
    public Result<?> generatePurchase(@PathVariable Long orderId, HttpServletResponse response) {
        return contractService.generatePurchase(orderId, response);
    }

    /** 销售订单 → 生成销售合同并下载 .xlsx */
    @PostMapping("/sales/generate/{orderId}")
    public Result<?> generateSales(@PathVariable Long orderId, HttpServletResponse response) {
        return contractService.generateSales(orderId, response);
    }
}
