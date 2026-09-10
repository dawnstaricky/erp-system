package com.example.erpsystem.listener;

import com.alibaba.excel.context.AnalysisContext;
import com.alibaba.excel.read.listener.ReadListener;
import com.alibaba.excel.util.ListUtils;
import com.example.erpsystem.dto.SalesImportDTO;
import com.example.erpsystem.entity.Customer;
import com.example.erpsystem.entity.Product;
import com.example.erpsystem.entity.SalesOrder;
import com.example.erpsystem.entity.SalesOrderItem;
import com.example.erpsystem.entity.Warehouse;
import com.example.erpsystem.mapper.CustomerMapper;
import com.example.erpsystem.mapper.ProductMapper;
import com.example.erpsystem.mapper.SalesOrderMapper;
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
public class SalesImportListener implements ReadListener<SalesImportDTO> {

    private static final int BATCH_COUNT = 100;
    private List<SalesImportDTO> cachedDataList = ListUtils.newArrayListWithExpectedSize(BATCH_COUNT);

    private final SalesOrderMapper salesOrderMapper;
    private final CustomerMapper customerMapper;
    private final WarehouseMapper warehouseMapper;
    private final ProductMapper productMapper;
    private final Long salesmanId;
    private final List<String> errors = new ArrayList<>();
    private int rowNum = 1;

    private final Map<String, Customer> customerCache = new HashMap<>();
    private final Map<String, Warehouse> warehouseCache = new HashMap<>();
    private final Map<String, Product> productCache = new HashMap<>();

    public SalesImportListener(
            SalesOrderMapper salesOrderMapper,
            CustomerMapper customerMapper,
            WarehouseMapper warehouseMapper,
            ProductMapper productMapper,
            Long salesmanId) {
        this.salesOrderMapper = salesOrderMapper;
        this.customerMapper = customerMapper;
        this.warehouseMapper = warehouseMapper;
        this.productMapper = productMapper;
        this.salesmanId = salesmanId;
    }

    @Override
    public void invoke(SalesImportDTO data, AnalysisContext context) {
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

    @Transactional(rollbackFor = Exception.class)
    protected void saveBatch() {
        // 按客户+仓库分组
        Map<String, List<SalesImportDTO>> groupMap = new HashMap<>();
        for (SalesImportDTO dto : cachedDataList) {
            String key = dto.getCustomerCode() + "_" + dto.getWarehouseCode();
            groupMap.computeIfAbsent(key, k -> new ArrayList<>()).add(dto);
        }

        for (Map.Entry<String, List<SalesImportDTO>> entry : groupMap.entrySet()) {
            List<SalesImportDTO> items = entry.getValue();
            SalesImportDTO first = items.get(0);

            Customer customer = customerCache.get(first.getCustomerCode());
            Warehouse warehouse = warehouseCache.get(first.getWarehouseCode());

            String orderNo = salesOrderMapper.generateOrderNo();

            SalesOrder order = new SalesOrder();
            order.setOrderNo(orderNo);
            order.setCustomerId(customer.getId());
            order.setWarehouseId(warehouse.getId());
            order.setStatus(0); // 草稿
            order.setSalesmanId(salesmanId);
            order.setOrderDate(LocalDate.now());
            order.setRemark("批量导入");

            BigDecimal totalAmount = BigDecimal.ZERO;
            List<SalesOrderItem> orderItems = new ArrayList<>();
            for (SalesImportDTO dto : items) {
                Product product = productCache.get(dto.getSkuCode());
                BigDecimal amount = dto.getPrice().multiply(BigDecimal.valueOf(dto.getQuantity()));
                totalAmount = totalAmount.add(amount);

                SalesOrderItem item = new SalesOrderItem();
                item.setProductId(product.getId());
                item.setQuantity(dto.getQuantity());
                item.setPrice(dto.getPrice());
                item.setAmount(amount);
                item.setRemark(dto.getRemark());
                orderItems.add(item);
            }
            order.setTotalAmount(totalAmount);

            salesOrderMapper.insertOrder(order);
            for (SalesOrderItem item : orderItems) {
                item.setOrderId(order.getId());
            }
            salesOrderMapper.insertItems(orderItems);
        }
    }

    private void validateAndCache(SalesImportDTO dto) {
        Customer customer = customerCache.get(dto.getCustomerCode());
        if (customer == null) {
            customer = customerMapper.selectByCode(dto.getCustomerCode());
            if (customer == null) {
                throw new RuntimeException("客户编码不存在：" + dto.getCustomerCode());
            }
            customerCache.put(dto.getCustomerCode(), customer);
        }

        Warehouse warehouse = warehouseCache.get(dto.getWarehouseCode());
        if (warehouse == null) {
            warehouse = warehouseMapper.selectByCode(dto.getWarehouseCode());
            if (warehouse == null) {
                throw new RuntimeException("仓库编码不存在：" + dto.getWarehouseCode());
            }
            warehouseCache.put(dto.getWarehouseCode(), warehouse);
        }

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