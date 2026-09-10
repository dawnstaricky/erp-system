package com.example.erpsystem.controller;

import com.example.erpsystem.common.Result;
import com.example.erpsystem.entity.Receipt;
import com.example.erpsystem.service.ReceiptService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import javax.servlet.http.HttpServletRequest;
import java.util.Map;

@RestController
@RequestMapping("/api/sales/receipt")
public class ReceiptController {

    @Autowired private ReceiptService receiptService;

    @GetMapping("/list")
    public Result<?> list(@RequestParam Map<String, Object> params, HttpServletRequest request) {
        params.put("companyId", com.example.erpsystem.common.CompanyContext.getCurrentCompanyId(request));
        return receiptService.page(params);
    }

    @PostMapping("/create")
    public Result<?> create(@RequestBody Receipt receipt, HttpServletRequest request) {
        receipt.setCompanyId(com.example.erpsystem.common.CompanyContext.getCurrentCompanyId(request));
        return receiptService.create(receipt);
    }
}
