package com.example.erpsystem.entity;

import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
public class InventoryVO extends Inventory {
    private String productName;   // 商品名称
    private String skuCode;       // 商品编码
    private String spec;          // 规格
    private String unit;          // 单位
    private Integer minStock;     // 最低库存（预警用）
}