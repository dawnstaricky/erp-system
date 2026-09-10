package com.example.erpsystem.service;

import com.example.erpsystem.dto.SalesExportDTO;
import com.example.erpsystem.entity.*;
import com.example.erpsystem.mapper.InventoryMapper;
import com.example.erpsystem.mapper.InventoryFlowMapper;
import com.example.erpsystem.mapper.SalesOrderMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Service
public class SalesService {

    @Autowired
    private SalesOrderMapper salesOrderMapper;
    @Autowired
    private InventoryMapper inventoryMapper;
    @Autowired
    private InventoryFlowMapper inventoryFlowMapper;

    // ========== 创建销售单 ==========
    public Long createOrder(SalesOrder order, List<SalesOrderItem> items) {
        // 生成单号
        String orderNo = salesOrderMapper.generateOrderNo();
        order.setOrderNo(orderNo);
        order.setStatus(0);  // 草稿

        // 计算总金额
        BigDecimal total = BigDecimal.ZERO;
        for (SalesOrderItem item : items) {
            item.setAmount(item.getPrice().multiply(BigDecimal.valueOf(item.getQuantity())));
            total = total.add(item.getAmount());
        }
        order.setTotalAmount(total);

        // 插入订单头
        salesOrderMapper.insertOrder(order);

        // 插入明细
        for (SalesOrderItem item : items) {
            item.setOrderId(order.getId());
        }
        salesOrderMapper.insertItems(items);

        return order.getId();
    }

    // ========== 销售出库（防超卖核心） ==========
    @Transactional(rollbackFor = Exception.class)
    public void stockOut(Long orderId) {
        // 1. 查询销售单
        SalesOrder order = salesOrderMapper.selectOrderById(orderId);
        if (order == null) throw new RuntimeException("销售单不存在");
        if (order.getStatus() != 0) throw new RuntimeException("只有草稿状态的销售单才能出库");

        // 2. 查询明细
        List<SalesOrderItem> items = salesOrderMapper.selectItemsByOrderId(orderId);
        if (items.isEmpty()) throw new RuntimeException("销售单没有商品明细");

        // 3. 遍历明细，逐个扣减库存（防超卖）
        for (SalesOrderItem item : items) {
            // 先查当前库存
            Inventory inventory = inventoryMapper.selectByProductAndWarehouse(
                    item.getProductId(), order.getWarehouseId());
            if (inventory == null || inventory.getQuantity() < item.getQuantity()) {
                throw new RuntimeException("商品ID=" + item.getProductId() + " 库存不足");
            }

            int beforeQuantity = inventory.getQuantity();
            int afterQuantity = beforeQuantity - item.getQuantity();

            // ⭐ 核心：乐观锁扣减（UPDATE返回影响行数，0表示扣减失败）
            int affected = inventoryMapper.decreaseStock(
                    item.getProductId(),
                    order.getWarehouseId(),
                    item.getQuantity()
            );

            if (affected == 0) {
                // 扣减失败，说明库存被别人抢了（并发场景）
                throw new RuntimeException("商品ID=" + item.getProductId() + " 库存扣减失败，请重试");
            }

            // 4. 记录库存流水
            InventoryFlow flow = new InventoryFlow();
            flow.setProductId(item.getProductId());
            flow.setWarehouseId(order.getWarehouseId());
            flow.setFlowType("SALE_OUT");
            flow.setQuantityChange(-item.getQuantity());  // 负数表示出库
            flow.setQuantityAfter(afterQuantity);
            flow.setRelatedOrderNo(order.getOrderNo());
            flow.setOperatorId(order.getSalesmanId());
            flow.setRemark("销售出库");
            inventoryFlowMapper.insert(flow);
        }

        // 5. 更新销售单状态为"已出库"
        order.setStatus(1);
        salesOrderMapper.updateOrder(order);
    }


    public List<SalesExportDTO> getSalesForExport(LocalDate startDate, LocalDate endDate,
                                                  Long customerId, Long warehouseId) {
        return salesOrderMapper.getSalesForExport(startDate, endDate, customerId, warehouseId);
    }

    /**
     * 批量销售出库（导入后的草稿单一键出库）
     */
    @Transactional(rollbackFor = Exception.class)
    public void batchStockOut(List<Long> orderIds, Long operatorId) {
        for (Long orderId : orderIds) {
            stockOut(orderId);  // 复用已有的单笔出库逻辑（含防超卖）
        }
    }

    public List<SalesOrder> getList(String orderNo, int pageNum, int pageSize) {
        int offset = (pageNum - 1) * pageSize;
        return salesOrderMapper.selectList(orderNo, offset, pageSize);
    }

    public int getCount(String orderNo) {
        return salesOrderMapper.selectCount(orderNo);
    }
}