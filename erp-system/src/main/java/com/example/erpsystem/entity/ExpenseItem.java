package com.example.erpsystem.entity;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;

@Data
public class ExpenseItem {
    private Long id;
    private Long formId;
    @NotNull(message = "费用类型不能为空")
    private Long expenseTypeId;
    @NotNull(message = "费用日期不能为空")
    private LocalDate expenseDate;
    @NotNull(message = "金额不能为空")
    @Min(value = 0, message = "金额不能小于0")
    private BigDecimal amount;
    private Integer invoiceCount;
    private String invoiceImage;
    private String remark;
}