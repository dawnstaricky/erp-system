package com.example.erpsystem.controller;

import com.alibaba.excel.EasyExcel;
import com.example.erpsystem.annotation.RequiresRoles;
import com.example.erpsystem.common.Result;
import com.example.erpsystem.dto.InventoryExportDTO;
import com.example.erpsystem.dto.InventoryFlowExportDTO;
import com.example.erpsystem.entity.Inventory;
import com.example.erpsystem.entity.InventoryVO;
import com.example.erpsystem.service.InventoryService;
import com.example.erpsystem.entity.InventoryFlow;
import com.example.erpsystem.mapper.InventoryFlowMapper;
import com.github.pagehelper.PageInfo;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.*;

import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/inventory")
public class InventoryController {

    @Autowired
    private InventoryService inventoryService;

    // 库存列表
    @GetMapping("/list")
    public Result<PageInfo<InventoryVO>> list(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize,
            @RequestParam(required = false) Long warehouseId,
            @RequestParam(required = false) String keyword) {
        return Result.success(inventoryService.getList(pageNum, pageSize, warehouseId, keyword));
    }

    // 单个商品库存
    @GetMapping("/{productId}/{warehouseId}")
    public Result<Inventory> detail(@PathVariable Long productId, @PathVariable Long warehouseId) {
        return Result.success(inventoryService.getByProductAndWarehouse(productId, warehouseId));
    }

    // 库存预警
    @GetMapping("/low-stock")
    public Result<List<InventoryVO>> lowStock(@RequestParam Long warehouseId) {
        return Result.success(inventoryService.getLowStockList(warehouseId));
    }

    @Autowired
    private InventoryFlowMapper inventoryFlowMapper;  // 临时用，后面移到Service

    // 库存流水查询
    @GetMapping("/flow")
    public Result<List<InventoryFlow>> flow(
            @RequestParam Long productId,
            @RequestParam Long warehouseId) {
        return Result.success(inventoryFlowMapper.getFlowList(productId, warehouseId));
    }

    @GetMapping("/export-for-check")
    public void exportForCheck(
            @RequestParam Long warehouseId,
            HttpServletResponse response) throws IOException {
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setCharacterEncoding("UTF-8");
        String fileName = URLEncoder.encode("库存盘点表_" + warehouseId, StandardCharsets.UTF_8).replaceAll("\\+", "%20");
        response.setHeader("Content-disposition", "attachment;filename*=utf-8''" + fileName + ".xlsx");

        List<InventoryExportDTO> data = inventoryService.getInventoryForExport(warehouseId);

        EasyExcel.write(response.getOutputStream(), InventoryExportDTO.class)
                .sheet("库存盘点表")
                .doWrite(data);
    }

    @GetMapping("/flow-export")
    public void exportFlow(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime startTime,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime endTime,
            @RequestParam(required = false) Long productId,
            @RequestParam(required = false) Long warehouseId,
            HttpServletResponse response) throws IOException {
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setCharacterEncoding("UTF-8");
        String fileName = URLEncoder.encode("库存流水_" + LocalDate.now(), StandardCharsets.UTF_8).replaceAll("\\+", "%20");
        response.setHeader("Content-disposition", "attachment;filename*=utf-8''" + fileName + ".xlsx");

        List<InventoryFlowExportDTO> data = inventoryService.getFlowForExport(startTime, endTime, productId, warehouseId);

        EasyExcel.write(response.getOutputStream(), InventoryFlowExportDTO.class)
                .sheet("库存流水")
                .doWrite(data);
    }
}