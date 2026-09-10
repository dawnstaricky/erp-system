package com.example.erpsystem.controller;

import com.example.erpsystem.common.Result;
import com.example.erpsystem.entity.Invoice;
import com.example.erpsystem.service.InvoiceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import javax.servlet.http.HttpServletRequest;
import java.util.Map;

@RestController
@RequestMapping("/api/sales/invoice")
public class InvoiceController {

    @Autowired private InvoiceService invoiceService;

    @GetMapping("/list")
    public Result<?> list(@RequestParam Map<String, Object> params, HttpServletRequest request) {
        params.put("companyId", com.example.erpsystem.common.CompanyContext.getCurrentCompanyId(request));
        return invoiceService.page(params);
    }

    @PostMapping("/create")
    public Result<?> create(@RequestBody Invoice invoice, HttpServletRequest request) {
        invoice.setCompanyId(com.example.erpsystem.common.CompanyContext.getCurrentCompanyId(request));
        return invoiceService.create(invoice);
    }

    @PutMapping("/void/{id}")
    public Result<?> voidInvoice(@PathVariable Long id) {
        return invoiceService.voidInvoice(id);
    }
}
