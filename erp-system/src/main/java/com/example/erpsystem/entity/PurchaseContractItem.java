package com.example.erpsystem.entity;

import lombok.Data;
import java.io.Serializable;
import java.math.BigDecimal;

@Data
public class PurchaseContractItem implements Serializable {
    private Long id;
    private Long contractId;
    private Long productId;
    private String productName;
    private String material;   // 材质
    private String spec;       // 规格
    private String origin;     // 产地/钢厂
    private String hardness;   // 硬度
    private String tinLayer;   // 锡层
    private String coilNo;     // 卷号
    private Integer quantity;
    private String unit;
    private BigDecimal unitPrice;
    private BigDecimal amount;
    private String remark;
}
