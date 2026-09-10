package com.example.erpsystem.entity;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class Inventory {
    private Long id;
    private Long productId;
    private Long warehouseId;
    private Integer quantity;
    private Integer lockQuantity;
    private BigDecimal costPrice;
    private LocalDateTime updatedAt;
}