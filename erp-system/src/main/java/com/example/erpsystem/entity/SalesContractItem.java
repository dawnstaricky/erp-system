package com.example.erpsystem.entity;

import lombok.Data;
import java.math.BigDecimal;

@Data
public class SalesContractItem {
    private Long id;
    private Long contractId;
    private Long productId;
    private String productName;
    private String material;
    private String spec;
    private String hardness;
    private String tinLayer;
    private String steelMill;
    private String origin;
    private Integer quantity;
    private String unit;
    private BigDecimal unitPrice;
    private BigDecimal amount;
    private String remark;
}
