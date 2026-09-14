package com.example.erpsystem.entity;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class Product {
    private Long id;
    private String skuCode;           // 商品编码
    private String productName;       // 商品名称
    private String mnemonicCode;      // 助记码
    private Long categoryId;          // 商品分类ID
    private String spec;              // 规格
    private String model;             // 型号
    private String unit;              // 计量单位
    private String barcode;           // 条形码
    private BigDecimal costPrice;     // 成本价
    private BigDecimal salePrice;     // 销售价
    private Integer minStock;         // 最低库存预警
    private Integer maxStock;         // 最高库存预警
    private Long supplierId;          // 默认供应商ID
    private Integer shelfLife;        // 保质期天数
    private String storageLocation;   // 存放位置
    private Integer status;           // 状态：1-启用 0-停用
    private String remark;            // 备注
    private LocalDateTime createdAt;  // 创建时间
    private LocalDateTime updatedAt;  // 更新时间

    // === 钢材商品扩展字段 ===
    private String hardness;     // 硬度
    private String tinLayer;     // 锡层
    private String coilNo;       // 钢卷号
    private String steelMill;    // 钢厂
    private String grade;        // 等级
    private java.time.LocalDate entryDate; // 入库日期
}