package com.example.erpsystem.entity;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class Customer {
    private Long id;
    @NotBlank(message = "客户名称不能为空")
    private String customerName;
    private String contactPerson;
    private String phone;
    private String email;
    private String address;
    private String level;
    private BigDecimal creditLimit;
    private BigDecimal initialReceivable;
    @NotNull(message = "状态不能为空")
    private Integer status;
    private String remark;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}