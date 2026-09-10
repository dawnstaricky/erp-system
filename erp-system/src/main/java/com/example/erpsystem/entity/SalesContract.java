package com.example.erpsystem.entity;

import lombok.Data;
import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 销售合同（对应销售合同模板：品名/规格/材质/硬度/锡层/数量/厂家/单价/总价 + 含税）
 */
@Data
public class SalesContract implements Serializable {
    private Long id;
    private String contractNo;
    private Long companyId;     // 我方公司（卖方）
    private Long customerId;    // 客户（买方）
    private Long orderId;       // 关联销售订单
    private LocalDate signDate;
    private BigDecimal totalAmount;
    private BigDecimal taxRate;
    private BigDecimal taxAmount;
    private Integer isTaxIncluded;
    private String deliveryMethod;
    private String paymentTerms;
    private String deliveryPeriod;
    private Integer status;     // 0-草稿 1-已签章 2-已作废
    private String remark;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    private List<SalesContractItem> items;
    private String customerName;
    private String companyName;
}
