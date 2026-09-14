package com.example.erpsystem.entity;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class Invoice {
    private Long id;
    private Long companyId;
    private String invoiceNo;
    private Long orderId;
    private String orderNo;
    private Long customerId;
    private String customerName;
    private String invoiceType;
    private LocalDate invoiceDate;
    private BigDecimal amount;
    private BigDecimal taxRate;
    private Integer status;
    private String fileUrl;
    private String remark;
    private Long creatorId;
    private LocalDateTime createdAt;
}
