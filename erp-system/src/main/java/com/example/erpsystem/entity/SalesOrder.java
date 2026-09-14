package com.example.erpsystem.entity;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class SalesOrder {
    private Long id;
    private String orderNo;
    @NotNull(message = "客户不能为空")
    private Long customerId;
    @NotNull(message = "仓库不能为空")
    private Long warehouseId;
    private BigDecimal totalAmount;
    private Integer status;
    private Long salesmanId;
    @NotNull(message = "订单日期不能为空")
    private LocalDate orderDate;
    private String remark;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // === 多公司 + 业财扩展字段 ===
    private Long companyId;
    private String deliveryMethod;   // 交货方式：自提/送货
    private Integer isTaxIncluded;   // 是否含税 0否 1是
    private java.math.BigDecimal taxRate;
    private java.math.BigDecimal taxAmount;
    private java.math.BigDecimal untaxedAmount;
    private java.math.BigDecimal paidAmount;
    private java.math.BigDecimal unpaidAmount;
    private Integer invoiceDone;     // 开票状态 0未 1部分 2全
    private Integer receiptDone;     // 回款状态 0未 1部分 2全
}