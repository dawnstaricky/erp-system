package com.example.erpsystem.controller;

import com.example.erpsystem.common.Result;
import com.example.erpsystem.entity.Customer;
import com.example.erpsystem.service.CustomerService;
import com.github.pagehelper.PageInfo;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/customer")
public class CustomerController {

    @Autowired
    private CustomerService customerService;

    @GetMapping("/list")
    public Result<PageInfo<Customer>> list(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize,
            @RequestParam(required = false) String keyword) {
        return Result.success(customerService.getList(pageNum, pageSize, keyword));
    }

    @PostMapping("/add")
    public Result<?> add(@RequestBody @Valid Customer customer) {
        return customerService.add(customer) > 0 ? Result.success() : Result.error(500, "新增失败");
    }

    @PutMapping("/update")
    public Result<?> update(@RequestBody @Valid Customer customer) {
        return customerService.update(customer) > 0 ? Result.success() : Result.error(500, "更新失败");
    }

    @GetMapping("/{id}")
    public Result<Customer> detail(@PathVariable Long id) {
        return Result.success(customerService.getById(id));
    }

    @DeleteMapping("/{id}")
    public Result<?> delete(@PathVariable Long id) {
        return customerService.delete(id) > 0 ? Result.success() : Result.error(500, "删除失败");
    }
}