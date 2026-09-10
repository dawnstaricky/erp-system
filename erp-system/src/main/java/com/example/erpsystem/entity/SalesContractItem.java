package com.example.erpsystem.entity;

import lombok.Data;
import java.io.Serializable;
import java.math.BigDecimal;

@Data
public class SalesContractItem implements Serializable {
    private Long id;
    private Long contractId;
    private Long productId;
    private String productName;
    private String spec;
    private String material;
    private String hardness;   // 硬度
    private String tinLayer;   // 锡层
    private String steelMill;  // 厂家
    private Integer quantity;
    private String unit;
    private BigDecimal unitPrice;
    private BigDecimal amount;
    private String remark;
}
