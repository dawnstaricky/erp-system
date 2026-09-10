package com.example.erpsystem.entity;

import lombok.Data;
import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 商品表（钢材类通用字段）
 */
@Data
public class Product implements Serializable {
    private Long id;
    private String productName;
    private String spec;          // 规格（如 0.32*790）
    private String material;      // 材质
    private String origin;        // 产地/钢厂
    private String unit;
    private java.math.BigDecimal costPrice;   // 成本价
    private java.math.BigDecimal salePrice;   // 销售价
    private Integer stock;        // 当前库存
    private Long deptId;         // 所属部门（沿用原有）
    private String imageUrl;

    // ===== 新增钢材通用字段 =====
    private String hardness;     // 硬度
    private String tinLayer;     // 锡层
    private String coilNo;       // 钢卷号
    private String steelMill;    // 钢厂
    private String grade;        // 等级
    private LocalDateTime stockInDate; // 入库日期

    private Long companyId;      // 所属公司
    private Integer status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
