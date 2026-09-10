package com.example.erpsystem.dto;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Data
public class SalesOrderDTO {
    private Long id;
    private String orderNo;
    private Long customerId;
    private String customerName;
    private Long warehouseId;
    private BigDecimal totalAmount;
    private Integer status;
    private Long salesmanId;
    private LocalDate orderDate;
    private String remark;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    // ✅ 新增明细字段
    private List<SalesOrderItemDTO> items;
}
