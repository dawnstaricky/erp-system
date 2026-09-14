package com.example.erpsystem.entity;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Data
public class PurchaseContract {
    private Long id;
    private String contractNo;
    private Long companyId;
    private Long supplierId;
    private String supplierName;
    private Long orderId;
    private LocalDate signDate;
    private BigDecimal totalAmount;
    private BigDecimal taxRate;
    private BigDecimal taxAmount;
    private Integer isTaxIncluded;
    private String deliveryMethod;
    private String paymentTerms;
    private String deliveryPeriod;
    private Integer status;
    private String remark;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private List<PurchaseContractItem> items;
}
