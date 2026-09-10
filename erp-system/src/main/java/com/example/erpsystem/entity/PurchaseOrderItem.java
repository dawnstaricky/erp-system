package com.example.erpsystem.entity;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import java.math.BigDecimal;

@Data
public class PurchaseOrderItem {
    private Long id;
    private Long orderId;
    @NotNull(message = "商品不能为空")
    private Long productId;
    @NotNull(message = "数量不能为空")
    @Min(value = 1, message = "数量必须大于0")
    private Integer quantity;
    @NotNull(message = "单价不能为空")
    private BigDecimal price;
    private BigDecimal amount;
    private String remark;
}