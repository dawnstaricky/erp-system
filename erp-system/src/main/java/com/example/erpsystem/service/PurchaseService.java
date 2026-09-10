package com.example.erpsystem.service;

import com.example.erpsystem.dto.PurchaseExportDTO;
import com.example.erpsystem.entity.Inventory;
import com.example.erpsystem.entity.PurchaseOrder;
import com.example.erpsystem.entity.PurchaseOrderItem;
import com.example.erpsystem.mapper.InventoryMapper;
import com.example.erpsystem.entity.InventoryFlow;
import com.example.erpsystem.mapper.InventoryFlowMapper;
import com.example.erpsystem.mapper.PurchaseOrderMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Service
public class PurchaseService {

    @Autowired
    private PurchaseOrderMapper purchaseOrderMapper;
    @Autowired
    private InventoryMapper inventoryMapper;
    @Autowired
    private InventoryFlowMapper inventoryFlowMapper;

    // ========== 事务核心：采购入库 ==========
    @Transactional(rollbackFor = Exception.class)  // 任何异常都回滚
    public void stockIn(Long orderId) {
        // 1. 查询采购单
        PurchaseOrder order = purchaseOrderMapper.selectOrderById(orderId);
        if (order == null) throw new RuntimeException("采购单不存在");
        if (order.getStatus() != 0) throw new RuntimeException("只有草稿状态的采购单才能入库");

        // 2. 查询明细
        List<PurchaseOrderItem> items = purchaseOrderMapper.selectItemsByOrderId(orderId);
        if (items.isEmpty()) throw new RuntimeException("采购单没有商品明细");

        // 3. 遍历明细，逐个增加库存
        for (PurchaseOrderItem item : items) {
            // 查询当前库存
            Inventory inventory = inventoryMapper.selectByProductAndWarehouse(
                    item.getProductId(), order.getWarehouseId());

            int beforeQuantity = (inventory != null) ? inventory.getQuantity() : 0;
            int afterQuantity = beforeQuantity + item.getQuantity();

            if (inventory == null) {
                // 首次入库，新增库存记录
                inventory = new Inventory();
                inventory.setProductId(item.getProductId());
                inventory.setWarehouseId(order.getWarehouseId());
                inventory.setQuantity(item.getQuantity());
                inventory.setCostPrice(item.getPrice());
                inventoryMapper.insert(inventory);
            } else {
                // 已有库存，增加数量
                inventoryMapper.increaseStock(
                        item.getProductId(),
                        order.getWarehouseId(),
                        item.getQuantity(),
                        item.getPrice()  // 更新成本价（移动加权平均你以后可以优化）
                );
            }

            // 写入库存流水
            InventoryFlow flow = new InventoryFlow();
            flow.setProductId(item.getProductId());
            flow.setWarehouseId(order.getWarehouseId());
            flow.setFlowType("PURCHASE_IN");
            flow.setQuantityChange(item.getQuantity());
            flow.setQuantityAfter(afterQuantity);
            flow.setRelatedOrderNo(order.getOrderNo());
            flow.setOperatorId(order.getPurchaserId());
            flow.setRemark("采购入库");
            inventoryFlowMapper.insert(flow);
        }

        // 4. 更新采购单状态为"已入库"
        order.setStatus(1);
        purchaseOrderMapper.updateOrder(order);
    }

    // ========== 创建采购单 ==========
    public Long createOrder(PurchaseOrder order, List<PurchaseOrderItem> items) {
        // 生成单号
        String orderNo = purchaseOrderMapper.generateOrderNo();
        order.setOrderNo(orderNo);
        order.setStatus(0);  // 草稿

        // 计算总金额
        BigDecimal total = BigDecimal.ZERO;
        for (PurchaseOrderItem item : items) {
            item.setAmount(item.getPrice().multiply(BigDecimal.valueOf(item.getQuantity())));
            total = total.add(item.getAmount());
        }
        order.setTotalAmount(total);

        // 插入订单头
        purchaseOrderMapper.insertOrder(order);

        // 插入明细
        for (PurchaseOrderItem item : items) {
            item.setOrderId(order.getId());
        }
        purchaseOrderMapper.insertItems(items);

        return order.getId();
    }


    public List<PurchaseExportDTO> getPurchaseForExport(LocalDate startDate, LocalDate endDate,
                                                        Long supplierId, Long warehouseId) {
        return purchaseOrderMapper.getPurchaseForExport(startDate, endDate, supplierId, warehouseId);
    }

    /**
     * 批量采购入库（导入后的草稿单一键入库）
     */
    @Transactional(rollbackFor = Exception.class)
    public void batchStockIn(List<Long> orderIds, Long operatorId) {
        for (Long orderId : orderIds) {
            stockIn(orderId);  // 复用已有的单笔入库逻辑
        }
    }

    public List<PurchaseOrder> getList(String orderNo, int pageNum, int pageSize) {
        int offset = (pageNum - 1) * pageSize;
        return purchaseOrderMapper.selectList(orderNo, offset, pageSize);
    }

    public int getCount(String orderNo) {
        return purchaseOrderMapper.selectCount(orderNo);
    }
}