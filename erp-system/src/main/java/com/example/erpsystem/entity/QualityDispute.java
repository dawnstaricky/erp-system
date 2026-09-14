package com.example.erpsystem.entity;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class QualityDispute {
    private Long id;
    private String disputeNo;
    private Long companyId;
    private Integer disputeType;
    private Long supplierId;
    private Long customerId;
    private Long orderId;
    private Long productId;
    private String contractNo;
    private Integer quantity;
    private BigDecimal claimAmount;
    private String description;
    private String evidenceUrls;
    private String handleMethod;
    private Integer financeAdjusted;
    private String adjustType;
    private BigDecimal adjustedAmount;
    private String adjustedBillNo;
    private String adjustRemark;
    private Integer status;
    private Long handlerId;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
