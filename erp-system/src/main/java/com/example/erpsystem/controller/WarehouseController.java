package com.example.erpsystem.controller;

import com.example.erpsystem.annotation.RequiresRoles;
import com.example.erpsystem.common.Result;
import com.example.erpsystem.entity.Warehouse;
import com.example.erpsystem.service.WarehouseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/warehouse")
public class WarehouseController {

    @Autowired
    private WarehouseService warehouseService;

    /**
     * 仓库列表查询（前端调用的就是这个接口！）
     */
    @GetMapping("/list")
    public Result<Map<String, Object>> getWarehouseList(
            @RequestParam(required = false) String keyword,
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize) {
        List<Warehouse> list = warehouseService.getList(keyword, pageNum, pageSize);
        int total = warehouseService.getCount(keyword);
        Map<String, Object> data = new HashMap<>();
        data.put("list", list);
        data.put("total", total);
        return Result.success(data);
    }

    /**
     * 新增仓库
     */
    @PostMapping("/add")
    public Result<?> addWarehouse(@RequestBody Warehouse warehouse) {
        try {
            warehouseService.addWarehouse(warehouse);
            return Result.success("新增仓库成功");
        } catch (Exception e) {
            return Result.error(500, e.getMessage());
        }
    }

    /**
     * 更新仓库
     */
    @PutMapping("/update")
    public Result<?> updateWarehouse(@RequestBody Warehouse warehouse) {
        try {
            warehouseService.updateWarehouse(warehouse);
            return Result.success("更新仓库成功");
        } catch (Exception e) {
            return Result.error(500, e.getMessage());
        }
    }

    /**
     * 停用仓库（软删除）
     */
    @DeleteMapping("/{id}")
    public Result<?> deleteWarehouse(@PathVariable Long id) {
        try {
            warehouseService.disableWarehouse(id);
            return Result.success("仓库已停用");
        } catch (Exception e) {
            return Result.error(500, e.getMessage());
        }
    }

    /** 停用（软删除） */

    @RequiresRoles("ADMIN")
    @PutMapping("/disable/{id}")
    public Result<?> disableWarehouse(@PathVariable Long id) {
        try {
            warehouseService.disableWarehouse(id);
            return Result.success("仓库已停用");
        } catch (Exception e) {
            return Result.error(500, e.getMessage());
        }
    }

    /** 启用（对应前端的“再启用”按钮） */
    @RequiresRoles("ADMIN")
    @PutMapping("/enable/{id}")
    public Result<?> enableWarehouse(@PathVariable Long id) {
        try {
            warehouseService.enableWarehouse(id);
            return Result.success("仓库已启用");
        } catch (Exception e) {
            return Result.error(500, e.getMessage());
        }
    }
}