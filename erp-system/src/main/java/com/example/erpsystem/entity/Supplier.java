package com.example.erpsystem.entity;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class Supplier {
    private Long id;
    @NotBlank(message = "供应商名称不能为空")
    private String supplierName;
    private String contactPerson;
    private String phone;
    private String email;
    private String address;
    private String level;
    @NotNull(message = "状态不能为空")
    private Integer status;
    private String remark;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // ✅ 补齐银行/税务/期初应付字段，与表结构严格对齐
    private String bankName;          // VARCHAR(100) 开户行
    private String bankAccount;       // VARCHAR(50) 银行账号
    private String taxNumber;         // VARCHAR(50) 税号
    private BigDecimal initialPayable; // DECIMAL(10,2) 期初应付款
}