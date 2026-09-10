package com.example.erpsystem.controller;

import com.alibaba.excel.EasyExcel;
import com.example.erpsystem.annotation.RequiresRoles;
import com.example.erpsystem.common.Result;
import com.example.erpsystem.dto.PurchaseExportDTO;
import com.example.erpsystem.dto.PurchaseImportDTO;
import com.example.erpsystem.dto.PurchaseOrderDTO;
import com.example.erpsystem.dto.PurchaseOrderItemDTO;
import com.example.erpsystem.entity.PurchaseOrder;
import com.example.erpsystem.entity.PurchaseOrderItem;
import com.example.erpsystem.listener.PurchaseImportListener;
import com.example.erpsystem.mapper.ProductMapper;
import com.example.erpsystem.mapper.PurchaseOrderMapper;
import com.example.erpsystem.mapper.SupplierMapper;
import com.example.erpsystem.mapper.WarehouseMapper;
import com.example.erpsystem.service.PurchaseService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.*;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/purchase")
public class PurchaseController {

    @Autowired
    private PurchaseService purchaseService;
    @Autowired
    private SupplierMapper supplierMapper;
    @Autowired
    private WarehouseMapper warehouseMapper;
    @Autowired
    private ProductMapper productMapper;
    @Autowired
    private PurchaseOrderMapper purchaseOrderMapper;

    @PostMapping("/create")
    public Result<?> create(@RequestBody @Valid CreatePurchaseRequest req) {
        Long orderId = purchaseService.createOrder(req.getOrder(), req.getItems());
        return Result.success(orderId);
    }

    @PostMapping("/stock-in/{orderId}")
    public Result<?> stockIn(@PathVariable Long orderId) {
        try {
            purchaseService.stockIn(orderId);
            return Result.success();
        } catch (Exception e) {
            return Result.error(500, e.getMessage());
        }
    }

    public static class CreatePurchaseRequest {
        @Valid
        private PurchaseOrder order;
        @Valid
        private List<PurchaseOrderItem> items;
        public PurchaseOrder getOrder() { return order; }
        public void setOrder(PurchaseOrder order) { this.order = order; }
        public List<PurchaseOrderItem> getItems() { return items; }
        public void setItems(List<PurchaseOrderItem> items) { this.items = items; }
    }

    @PostMapping("/import")
    public Result<?> importPurchase(
            @RequestParam("file") MultipartFile file,
            @RequestParam Long purchaserId) {
        try {
            PurchaseImportListener listener = new PurchaseImportListener(
                    purchaseOrderMapper,
                    supplierMapper,
                    warehouseMapper,
                    productMapper,
                    purchaserId
            );

            EasyExcel.read(file.getInputStream(), PurchaseImportDTO.class, listener)
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
    public void downloadTemplate(HttpServletResponse response) throws IOException {
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setCharacterEncoding("UTF-8");
        String fileName = URLEncoder.encode("采购单导入模板", StandardCharsets.UTF_8).replaceAll("\\+", "%20");
        response.setHeader("Content-disposition", "attachment;filename*=utf-8''" + fileName + ".xlsx");

        List<PurchaseImportDTO> demoData = new ArrayList<>();
        PurchaseImportDTO demo = new PurchaseImportDTO();
        demo.setSupplierCode("SUP001");
        demo.setWarehouseCode("WH001");
        demo.setSkuCode("SKU1785248948521");
        demo.setProductName("华为Mate60 Pro");
        demo.setSpec("12GB+256GB");
        demo.setQuantity(10);
        demo.setPrice(new BigDecimal("4500.00"));
        demo.setRemark("示例数据，请删除后导入");
        demoData.add(demo);

        EasyExcel.write(response.getOutputStream(), PurchaseImportDTO.class)
                .sheet("采购导入模板")
                .doWrite(demoData);
    }

    @GetMapping("/export")
    public void exportPurchase(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate,
            @RequestParam(required = false) Long supplierId,
            @RequestParam(required = false) Long warehouseId,
            HttpServletResponse response) throws IOException {
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setCharacterEncoding("UTF-8");
        String fileName = URLEncoder.encode("采购明细_" + LocalDate.now(), StandardCharsets.UTF_8).replaceAll("\\+", "%20");
        response.setHeader("Content-disposition", "attachment;filename*=utf-8''" + fileName + ".xlsx");

        List<PurchaseExportDTO> data = purchaseService.getPurchaseForExport(startDate, endDate, supplierId, warehouseId);

        EasyExcel.write(response.getOutputStream(), PurchaseExportDTO.class)
                .sheet("采购明细")
                .doWrite(data);
    }

    /**
     * 批量采购入库
     * POST /purchase/batch-stock-in?operatorId=1
     * Body: [1, 2, 3]  （订单ID数组）
     */
    @PostMapping("/batch-stock-in")
    public Result<?> batchStockIn(@RequestParam Long operatorId,
                                  @RequestBody List<Long> orderIds) {
        try {
            purchaseService.batchStockIn(orderIds, operatorId);
            return Result.success("批量入库成功，共" + orderIds.size() + "笔");
        } catch (Exception e) {
            return Result.error(500, e.getMessage());
        }
    }

    /**
     * 查询我的草稿采购单（导入后待审核）
     */
    @GetMapping("/draft-list")
    public Result<List<PurchaseOrder>> draftList(@RequestParam Long purchaserId) {
        return Result.success(purchaseOrderMapper.selectDraftsByPurchaser(purchaserId));
    }

    @GetMapping("/order/list")
    public Result<Map<String, Object>> getPurchaseOrderList(
            @RequestParam(required = false) String orderNo,
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize) {
        List<PurchaseOrder> list = purchaseService.getList(orderNo, pageNum, pageSize);
        int total = purchaseService.getCount(orderNo);
        Map<String, Object> data = new HashMap<>();
        data.put("list", list);
        data.put("total", total);
        return Result.success(data);
    }

    @RequiresRoles({"ADMIN", "PURCHASER"})
    @GetMapping("/detail/{id}")
    public Result<PurchaseOrderDTO> detail(@PathVariable Long id) {
        PurchaseOrderDTO dto = purchaseOrderMapper.selectById(id);
        // 查明细，塞进DTO
        List<PurchaseOrderItemDTO> items = purchaseOrderMapper.selectItemsDTOByOrderId(id);
        dto.setItems(items);
        return Result.success(dto);
    }
}