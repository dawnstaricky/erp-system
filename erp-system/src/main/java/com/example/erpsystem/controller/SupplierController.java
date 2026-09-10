package com.example.erpsystem.controller;

import com.example.erpsystem.common.Result;
import com.example.erpsystem.entity.Supplier;
import com.example.erpsystem.service.SupplierService;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/supplier")
public class SupplierController {
    @Autowired
    private SupplierService supplierService;

    @GetMapping("/list")
    public Result<PageInfo<Supplier>> list(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize,
            @RequestParam(required = false) String keyword) {
        return Result.success(supplierService.getList(pageNum, pageSize, keyword));
    }

    @PostMapping("/add")
    public Result<?> add(@RequestBody Supplier supplier) {
        return supplierService.add(supplier) > 0 ? Result.success() : Result.error(500, "新增失败");
    }

    @PutMapping("/update")
    public Result<?> update(@RequestBody Supplier supplier) {
        return supplierService.update(supplier) > 0 ? Result.success() : Result.error(500, "更新失败");
    }

    @GetMapping("/{id}")
    public Result<Supplier> detail(@PathVariable Long id) {
        return Result.success(supplierService.getById(id));
    }

    @DeleteMapping("/{id}")
    public Result<?> delete(@PathVariable Long id) {
        return supplierService.delete(id) > 0 ? Result.success() : Result.error(500, "删除失败");
    }
}