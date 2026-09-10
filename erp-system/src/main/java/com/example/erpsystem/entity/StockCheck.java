package com.example.erpsystem.entity;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class StockCheck {
    private Long id;
    private String checkNo;
    @NotNull(message = "仓库不能为空")
    private Long warehouseId;
    @NotNull(message = "商品不能为空")
    private Long productId;
    @NotNull(message = "账面数量不能为空")
    @Min(value = 0, message = "账面数量不能小于0")
    private Integer bookQuantity;
    @NotNull(message = "实际数量不能为空")
    @Min(value = 0, message = "实际数量不能小于0")
    private Integer actualQuantity;
    private Integer difference;
    private String reason;
    @NotNull(message = "状态不能为空")
    private Integer status;
    @NotNull(message = "盘点人不能为空")
    private Long checkerId;
    @NotNull(message = "盘点日期不能为空")
    private LocalDate checkDate;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}