package com.example.erpsystem.controller;

import com.example.erpsystem.common.Result;
import com.example.erpsystem.entity.Product;
import com.example.erpsystem.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/product")
public class ProductController {

    @Autowired
    private ProductService productService;

    // 商品列表（分页）
    @GetMapping("/list")
    public Result<?> list(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize,
            @RequestParam(required = false) String keyword) {
        return Result.success(productService.getList(pageNum, pageSize, keyword));
    }

    // 新增商品
    @PostMapping("/add")
    public Result<?> add(@RequestBody Product product) {
        int result = productService.add(product);
        return result > 0 ? Result.success() : Result.error(500, "新增失败");
    }

    // 编辑商品
    @PutMapping("/update")
    public Result<?> update(@RequestBody Product product) {
        int result = productService.update(product);
        return result > 0 ? Result.success() : Result.error(500, "更新失败");
    }

    // 商品详情
    @GetMapping("/{id}")
    public Result<Product> detail(@PathVariable Long id) {
        return Result.success(productService.getById(id));
    }

    // 停用商品
    @DeleteMapping("/{id}")
    public Result<?> delete(@PathVariable Long id) {
        int result = productService.delete(id);
        return result > 0 ? Result.success() : Result.error(500, "删除失败");
    }
}