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
@RequestMapping("/sales/invoice")
public class InvoiceController {

    @Autowired private InvoiceService invoiceService;

    @GetMapping("/list") public Result<PageInfo<Invoice>> list(Invoice q, @RequestParam int pageNum, @RequestParam int pageSize){ return Result.success(invoiceService.page(q, pageNum, pageSize)); }
    @PostMapping("/create") public Result<Void> create(@RequestBody Invoice inv){ invoiceService.create(inv); return Result.success(); }
    @PostMapping("/void/{id}") public Result<Void> voidInvoice(@PathVariable Long id){ invoiceService.voidInvoice(id); return Result.success(); }

}
