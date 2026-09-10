package com.example.erpsystem.controller;

import com.alibaba.excel.EasyExcel;
import com.example.erpsystem.annotation.RequiresRoles;
import com.example.erpsystem.common.Result;
import com.example.erpsystem.dto.*;
import com.example.erpsystem.entity.PurchaseOrder;
import com.example.erpsystem.entity.SalesOrder;
import com.example.erpsystem.entity.SalesOrderItem;
import com.example.erpsystem.listener.SalesImportListener;
import com.example.erpsystem.mapper.CustomerMapper;
import com.example.erpsystem.mapper.ProductMapper;
import com.example.erpsystem.mapper.SalesOrderMapper;
import com.example.erpsystem.mapper.WarehouseMapper;
import com.example.erpsystem.service.SalesService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.format.annotation.DateTimeFormat;

import jakarta.servlet.http.HttpServletResponse;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/sales")
public class SalesController {

    @Autowired
    private SalesService salesService;

    @PostMapping("/create")
    public Result<?> create(@RequestBody @Valid CreateSalesRequest req) {
        Long orderId = salesService.createOrder(req.getOrder(), req.getItems());
        return Result.success(orderId);
    }

    @PostMapping("/stock-out/{orderId}")
    public Result<?> stockOut(@PathVariable Long orderId) {
        try {
            salesService.stockOut(orderId);
            return Result.success();
        } catch (Exception e) {
            return Result.error(500, e.getMessage());
        }
    }

    public static class CreateSalesRequest {
        @Valid
        private SalesOrder order;
        @Valid
        private List<SalesOrderItem> items;
        public SalesOrder getOrder() { return order; }
        public void setOrder(SalesOrder order) { this.order = order; }
        public List<SalesOrderItem> getItems() { return items; }
        public void setItems(List<SalesOrderItem> items) { this.items = items; }
    }

    @Autowired
    private CustomerMapper customerMapper;
    @Autowired
    private WarehouseMapper warehouseMapper;
    @Autowired
    private ProductMapper productMapper;
    @Autowired
    private SalesOrderMapper salesOrderMapper;

    @PostMapping("/import")
    public Result<?> importSales(
            @RequestParam("file") MultipartFile file,
            @RequestParam Long salesmanId) {
        try {
            SalesImportListener listener = new SalesImportListener(
                    salesOrderMapper,
                    customerMapper,
                    warehouseMapper,
                    productMapper,
                    salesmanId
            );

            EasyExcel.read(file.getInputStream(), SalesImportDTO.class, listener)
                    .sheet()
                    .doRead();

            if (!listener.getErrors().isEmpty()) {
                return Result.error(400, "导入完成，但有错误：" + String.join("；", listener.getErrors()));
            }

            return Result.success("导入成功，共" + listener.getSuccessCount() + "条记录");
        } catch (Exception e) {
            return Result.error(500, "导入失败：" + e.getMessage());
        }
    }

    @GetMapping("/import-template")
    public void downloadSalesTemplate(HttpServletResponse response) throws IOException {
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setCharacterEncoding("UTF-8");
        String fileName = URLEncoder.encode("销售单导入模板", StandardCharsets.UTF_8).replaceAll("\\+", "%20");
        response.setHeader("Content-disposition", "attachment;filename*=utf-8''" + fileName + ".xlsx");

        List<SalesImportDTO> demoData = new ArrayList<>();
        SalesImportDTO demo = new SalesImportDTO();
        demo.setCustomerCode("CUS001");
        demo.setWarehouseCode("WH001");
        demo.setSkuCode("SKU1785248948521");
        demo.setQuantity(2);
        demo.setPrice(new BigDecimal("5499.00"));
        demo.setRemark("示例数据，请删除后导入");
        demoData.add(demo);

        EasyExcel.write(response.getOutputStream(), SalesImportDTO.class)
                .sheet("销售导入模板")
                .doWrite(demoData);
    }

    @GetMapping("/export")
    public void exportSales(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate,
            @RequestParam(required = false) Long customerId,
            @RequestParam(required = false) Long warehouseId,
            HttpServletResponse response) throws IOException {
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setCharacterEncoding("UTF-8");
        String fileName = URLEncoder.encode("销售明细_" + LocalDate.now(), StandardCharsets.UTF_8).replaceAll("\\+", "%20");
        response.setHeader("Content-disposition", "attachment;filename*=utf-8''" + fileName + ".xlsx");

        List<SalesExportDTO> data = salesService.getSalesForExport(startDate, endDate, customerId, warehouseId);

        EasyExcel.write(response.getOutputStream(), SalesExportDTO.class)
                .sheet("销售明细")
                .doWrite(data);
    }


    /**
     * 批量销售出库
     * POST /sales/batch-stock-out?operatorId=1
     * Body: [1, 2, 3]
     */
    @PostMapping("/batch-stock-out")
    public Result<?> batchStockOut(@RequestParam Long operatorId,
                                   @RequestBody List<Long> orderIds) {
        try {
            salesService.batchStockOut(orderIds, operatorId);
            return Result.success("批量出库成功，共" + orderIds.size() + "笔");
        } catch (Exception e) {
            return Result.error(500, e.getMessage());
        }
    }

    /**
     * 查询我的草稿销售单
     */
    @GetMapping("/draft-list")
    public Result<List<SalesOrder>> draftList(@RequestParam Long salesmanId) {
        return Result.success(salesOrderMapper.selectDraftsBySalesman(salesmanId));
    }

    @GetMapping("/order/list")
    public Result<Map<String, Object>> getSalesOrderList(
            @RequestParam(required = false) String orderNo,
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize) {
        List<SalesOrder> list = salesService.getList(orderNo, pageNum, pageSize);
        int total = salesService.getCount(orderNo);
        Map<String, Object> data = new HashMap<>();
        data.put("list", list);
        data.put("total", total);
        return Result.success(data);
    }

    @RequiresRoles({"ADMIN", "SALSE"})
    @GetMapping("/detail/{id}")
    public Result<SalesOrderDTO> detail(@PathVariable Long id) {
        SalesOrderDTO dto = salesOrderMapper.selectById(id);
        // 查明细，塞进DTO
        List<SalesOrderItemDTO> items = salesOrderMapper.selectItemsDTOByOrderId(id);
        dto.setItems(items);
        return Result.success(dto);
    }
}