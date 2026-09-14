package com.example.erpsystem.entity;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class BusinessArchive {
    private Long id;
    private Long companyId;
    private Long orderId;
    private String orderNo;
    private Long customerId;
    private Integer purchaseDone;
    private Integer saleDraftDone;
    private Integer outboundDone;
    private Integer invoiceDone;
    private Integer receiptDone;
    private Integer isArchived;
    private LocalDateTime archivedAt;
    private Integer autoUnarchived;
    private String unarchiveReason;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
