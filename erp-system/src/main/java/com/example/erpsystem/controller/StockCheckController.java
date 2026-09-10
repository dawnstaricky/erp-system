package com.example.erpsystem.controller;

import com.example.erpsystem.annotation.RequiresRoles;
import com.example.erpsystem.common.Result;
import com.example.erpsystem.entity.StockCheck;
import com.example.erpsystem.service.StockCheckService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/stock-check")
public class StockCheckController {

    @Autowired
    private StockCheckService stockCheckService;

    @PostMapping("/create")
    public Result<?> create(@RequestBody @Valid StockCheck check) {
        Long id = stockCheckService.createCheck(check);
        return Result.success(id);
    }

    @RequiresRoles({"ADMIN", "INVENTORY"})
    @PostMapping("/approve/{checkId}")
    public Result<?> approve(@PathVariable Long checkId) {
        try {
            stockCheckService.approve(checkId);
            return Result.success();
        } catch (Exception e) {
            return Result.error(500, e.getMessage());
        }
    }

    @GetMapping("/list")
    public Result<List<StockCheck>> list(
            @RequestParam(required = false) Long warehouseId,
            @RequestParam(required = false) String keyword) {
        return Result.success(stockCheckService.getList(warehouseId, keyword));
    }
}