package com.example.erpsystem.entity;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class InventoryFlow {
    private Long id;
    private Long productId;
    private Long warehouseId;
    private String flowType;          // PURCHASE_IN/SALE_OUT/STOCK_CHECK
    private Integer quantityChange;   // 正入负出
    private Integer quantityAfter;    // 变动后库存
    private String relatedOrderNo;    // 关联单号
    private Long operatorId;          // 操作人
    private LocalDateTime flowTime;   // 发生时间
    private String remark;
}