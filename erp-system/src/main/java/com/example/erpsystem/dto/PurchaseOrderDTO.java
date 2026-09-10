package com.example.erpsystem.dto;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Data
public class PurchaseOrderDTO {
    private Long id;
    private String orderNo;
    private Long supplierId;
    private String supplierName; // 联查供应商表获取
    private Long warehouseId;
    private BigDecimal totalAmount;
    private Integer status;
    private Long purchaserId;
    private LocalDate orderDate;
    private String remark;
    private LocalDateTime createdAt;
    // 新增明细字段
    private List<PurchaseOrderItemDTO> items;
}