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
@RequestMapping("/sales/receipt")
public class ReceiptController {

    @Autowired private ReceiptService receiptService;

    @GetMapping("/list") public Result<PageInfo<Receipt>> list(Receipt q, @RequestParam int pageNum, @RequestParam int pageSize){ return Result.success(receiptService.page(q, pageNum, pageSize)); }
    @PostMapping("/create") public Result<Void> create(@RequestBody Receipt r){ receiptService.create(r); return Result.success(); }

}
