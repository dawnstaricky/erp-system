package com.example.erpsystem.dto;
import lombok.Data;
import java.math.BigDecimal;

@Data
public class PurchaseOrderItemDTO {
    private Long id;
    private Long orderId;
    private Long productId;
    private String productName; // 关联商品表查
    private String spec; // 关联商品表查
    private Integer quantity;
    private BigDecimal price;
    private BigDecimal amount;
}