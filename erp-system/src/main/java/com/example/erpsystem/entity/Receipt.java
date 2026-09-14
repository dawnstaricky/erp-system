package com.example.erpsystem.entity;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class Receipt {
    private Long id;
    private Long companyId;
    private String receiptNo;
    private Long orderId;
    private String orderNo;
    private Long customerId;
    private String customerName;
    private LocalDate receiptDate;
    private BigDecimal amount;
    private BigDecimal unallocatedAmount;
    private String paymentMethod;
    private String bankAccount;
    private String remark;
    private Long creatorId;
    private LocalDateTime createdAt;
}
