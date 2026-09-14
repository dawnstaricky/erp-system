package com.example.erpsystem.entity;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class PurchaseOrder {
    private Long id;
    private String orderNo;
    @NotNull(message = "供应商不能为空")
    private Long supplierId;
    @NotNull(message = "仓库不能为空")
    private Long warehouseId;
    private BigDecimal totalAmount;
    private Integer status;
    private Long purchaserId;
    @NotNull(message = "订单日期不能为空")
    private LocalDate orderDate;
    private String remark;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // === 多公司 + 业财扩展字段 ===
    private Long companyId;
    private String deliveryMethod;
    private Integer isTaxIncluded;
    private java.math.BigDecimal taxRate;
    private java.math.BigDecimal taxAmount;
    private java.math.BigDecimal untaxedAmount;
    private Integer invoiceDone;
}