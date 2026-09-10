package com.example.erpsystem.controller;

import com.example.erpsystem.common.Result;
import com.example.erpsystem.dto.*;
import com.example.erpsystem.service.ReportService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.*;
import java.time.LocalDate;
import java.util.List;

import com.alibaba.excel.EasyExcel;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@RestController
@RequestMapping("/report")
public class ReportController {

    @Autowired
    private ReportService reportService;

    // 仪表盘汇总
    @GetMapping("/dashboard")
    public Result<DashboardDTO> dashboard() {
        return Result.success(reportService.getDashboard());
    }

    // 销售日报
    @GetMapping("/sales-daily")
    public Result<List<SalesReportDTO>> salesDaily(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate,
            @RequestParam(required = false) Long warehouseId) {
        return Result.success(reportService.getSalesDaily(startDate, endDate, warehouseId));
    }

    // 销售月报
    @GetMapping("/sales-monthly")
    public Result<List<SalesReportDTO>> salesMonthly(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate,
            @RequestParam(required = false) Long warehouseId) {
        return Result.success(reportService.getSalesMonthly(startDate, endDate, warehouseId));
    }

    // 商品销售排行 Top N
    @GetMapping("/product-rank")
    public Result<List<ProductSalesRankDTO>> productRank(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate,
            @RequestParam(required = false) Long warehouseId,
            @RequestParam(defaultValue = "10") int limit) {
        return Result.success(reportService.getProductSalesRank(startDate, endDate, warehouseId, limit));
    }

    // 客户销售排行 Top N
    @GetMapping("/customer-rank")
    public Result<List<CustomerSalesRankDTO>> customerRank(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate,
            @RequestParam(required = false) Long warehouseId,
            @RequestParam(defaultValue = "10") int limit) {
        return Result.success(reportService.getCustomerSalesRank(startDate, endDate, warehouseId, limit));
    }

    // 库存分析
    @GetMapping("/inventory-analysis")
    public Result<List<InventoryAnalysisDTO>> inventoryAnalysis(
            @RequestParam(required = false) Long warehouseId) {
        return Result.success(reportService.getInventoryAnalysis(warehouseId));
    }


    // 导出销售日报
    @GetMapping("/export/sales-daily")
    public void exportSalesDaily(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate,
            @RequestParam(required = false) Long warehouseId,
            HttpServletResponse response) throws IOException {
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setCharacterEncoding("UTF-8");
        String fileName = URLEncoder.encode("销售日报", StandardCharsets.UTF_8).replaceAll("\\+", "%20");
        response.setHeader("Content-disposition", "attachment;filename*=utf-8''" + fileName + ".xlsx");

        List<SalesReportDTO> data = reportService.getSalesDaily(startDate, endDate, warehouseId);
        EasyExcel.write(response.getOutputStream(), SalesReportDTO.class)
                .sheet("销售日报")
                .doWrite(data);
    }

    // 导出商品销售排行
    @GetMapping("/export/product-rank")
    public void exportProductRank(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate,
            @RequestParam(required = false) Long warehouseId,
            @RequestParam(defaultValue = "20") int limit,
            HttpServletResponse response) throws IOException {
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setCharacterEncoding("UTF-8");
        String fileName = URLEncoder.encode("商品销售排行", StandardCharsets.UTF_8).replaceAll("\\+", "%20");
        response.setHeader("Content-disposition", "attachment;filename*=utf-8''" + fileName + ".xlsx");

        List<ProductSalesRankDTO> data = reportService.getProductSalesRank(startDate, endDate, warehouseId, limit);
        EasyExcel.write(response.getOutputStream(), ProductSalesRankDTO.class)
                .sheet("商品销售排行")
                .doWrite(data);
    }

    // 导出库存分析
    @GetMapping("/export/inventory-analysis")
    public void exportInventoryAnalysis(
            @RequestParam(required = false) Long warehouseId,
            HttpServletResponse response) throws IOException {
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setCharacterEncoding("UTF-8");
        String fileName = URLEncoder.encode("库存分析", StandardCharsets.UTF_8).replaceAll("\\+", "%20");
        response.setHeader("Content-disposition", "attachment;filename*=utf-8''" + fileName + ".xlsx");

        List<InventoryAnalysisDTO> data = reportService.getInventoryAnalysis(warehouseId);
        EasyExcel.write(response.getOutputStream(), InventoryAnalysisDTO.class)
                .sheet("库存分析")
                .doWrite(data);
    }
}