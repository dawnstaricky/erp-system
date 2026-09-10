package com.example.erpsystem.listener;

import com.alibaba.excel.context.AnalysisContext;
import com.alibaba.excel.exception.ExcelDataConvertException;
import com.alibaba.excel.read.listener.ReadListener;
import com.alibaba.excel.util.ListUtils;
import com.example.erpsystem.dto.PurchaseImportDTO;
import com.example.erpsystem.entity.Product;
import com.example.erpsystem.entity.PurchaseOrder;
import com.example.erpsystem.entity.PurchaseOrderItem;
import com.example.erpsystem.entity.Supplier;
import com.example.erpsystem.entity.Warehouse;
import com.example.erpsystem.mapper.ProductMapper;
import com.example.erpsystem.mapper.PurchaseOrderMapper;
import com.example.erpsystem.mapper.SupplierMapper;
import com.example.erpsystem.mapper.WarehouseMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
public class PurchaseImportListener implements ReadListener<PurchaseImportDTO> {

    private static final int BATCH_COUNT = 100;
    private List<PurchaseImportDTO> cachedDataList = ListUtils.newArrayListWithExpectedSize(BATCH_COUNT);

    private final PurchaseOrderMapper purchaseOrderMapper;
    private final SupplierMapper supplierMapper;
    private final WarehouseMapper warehouseMapper;
    private final ProductMapper productMapper;
    private final Long purchaserId;
    private final List<String> errors = new ArrayList<>();
    private int rowNum = 1; // 从第2行开始（第1行是表头）

    // 缓存，避免重复查DB
    private final Map<String, Supplier> supplierCache = new HashMap<>();
    private final Map<String, Warehouse> warehouseCache = new HashMap<>();
    private final Map<String, Product> productCache = new HashMap<>();

    public PurchaseImportListener(
            PurchaseOrderMapper purchaseOrderMapper,
            SupplierMapper supplierMapper,
            WarehouseMapper warehouseMapper,
            ProductMapper productMapper,
            Long purchaserId) {
        this.purchaseOrderMapper = purchaseOrderMapper;
        this.supplierMapper = supplierMapper;
        this.warehouseMapper = warehouseMapper;
        this.productMapper = productMapper;
        this.purchaserId = purchaserId;
    }

    @Override
    public void invoke(PurchaseImportDTO data, AnalysisContext context) {
        rowNum++;
        try {
            validateAndCache(data);
            cachedDataList.add(data);
            if (cachedDataList.size() >= BATCH_COUNT) {
                saveBatch();
                cachedDataList.clear();
            }
        } catch (Exception e) {
            errors.add("第" + rowNum + "行：" + e.getMessage());
        }
    }

    @Override
    public void doAfterAllAnalysed(AnalysisContext context) {
        if (!cachedDataList.isEmpty()) {
            saveBatch();
        }
    }

    @Override
    public void onException(Exception exception, AnalysisContext context) {
        rowNum = context.readRowHolder().getRowIndex();
        if (exception instanceof ExcelDataConvertException) {
            errors.add("第" + rowNum + "行：数据类型转换错误，请检查数量/单价格式");
        } else {
            errors.add("第" + rowNum + "行：" + exception.getMessage());
        }
    }

    @Transactional(rollbackFor = Exception.class)
    protected void saveBatch() {
        // 按供应商+仓库分组，每个组合生成一个采购单
        Map<String, List<PurchaseImportDTO>> groupMap = new HashMap<>();
        for (PurchaseImportDTO dto : cachedDataList) {
            String key = dto.getSupplierCode() + "_" + dto.getWarehouseCode();
            groupMap.computeIfAbsent(key, k -> new ArrayList<>()).add(dto);
        }

        for (Map.Entry<String, List<PurchaseImportDTO>> entry : groupMap.entrySet()) {
            List<PurchaseImportDTO> items = entry.getValue();
            PurchaseImportDTO first = items.get(0);

            Supplier supplier = supplierCache.get(first.getSupplierCode());
            Warehouse warehouse = warehouseCache.get(first.getWarehouseCode());

            // 生成采购单号
            String orderNo = purchaseOrderMapper.generateOrderNo();

            // 创建采购单头
            PurchaseOrder order = new PurchaseOrder();
            order.setOrderNo(orderNo);
            order.setSupplierId(supplier.getId());
            order.setWarehouseId(warehouse.getId());
            order.setStatus(0); // 草稿
            order.setPurchaserId(purchaserId);
            order.setOrderDate(LocalDate.now());
            order.setRemark("批量导入");

            // 计算总金额
            BigDecimal totalAmount = BigDecimal.ZERO;
            List<PurchaseOrderItem> orderItems = new ArrayList<>();
            for (PurchaseImportDTO dto : items) {
                Product product = productCache.get(dto.getSkuCode());
                BigDecimal amount = dto.getPrice().multiply(BigDecimal.valueOf(dto.getQuantity()));
                totalAmount = totalAmount.add(amount);

                PurchaseOrderItem item = new PurchaseOrderItem();
                item.setProductId(product.getId());
                item.setQuantity(dto.getQuantity());
                item.setPrice(dto.getPrice());
                item.setAmount(amount);
                item.setRemark(dto.getRemark());
                orderItems.add(item);
            }
            order.setTotalAmount(totalAmount);

            // 插入数据库
            purchaseOrderMapper.insertOrder(order);
            for (PurchaseOrderItem item : orderItems) {
                item.setOrderId(order.getId());
            }
            purchaseOrderMapper.insertItems(orderItems);
        }
    }

    private void validateAndCache(PurchaseImportDTO dto) {
        // 校验供应商
        Supplier supplier = supplierCache.get(dto.getSupplierCode());
        if (supplier == null) {
            supplier = supplierMapper.selectByCode(dto.getSupplierCode());
            if (supplier == null) {
                throw new RuntimeException("供应商编码不存在：" + dto.getSupplierCode());
            }
            supplierCache.put(dto.getSupplierCode(), supplier);
        }

        // 校验仓库
        Warehouse warehouse = warehouseCache.get(dto.getWarehouseCode());
        if (warehouse == null) {
            warehouse = warehouseMapper.selectByCode(dto.getWarehouseCode());
            if (warehouse == null) {
                throw new RuntimeException("仓库编码不存在：" + dto.getWarehouseCode());
            }
            warehouseCache.put(dto.getWarehouseCode(), warehouse);
        }

        // 校验商品
        Product product = productCache.get(dto.getSkuCode());
        if (product == null) {
            product = productMapper.selectBySkuCode(dto.getSkuCode());
            if (product == null) {
                throw new RuntimeException("商品编码不存在：" + dto.getSkuCode());
            }
            productCache.put(dto.getSkuCode(), product);
        }
    }

    public List<String> getErrors() {
        return errors;
    }

    public int getSuccessCount() {
        return cachedDataList.size();
    }
}