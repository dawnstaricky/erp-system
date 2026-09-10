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
}