package com.example.erpsystem.entity;

import lombok.Data;
import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 业务闭环归档表（严格五环节全满足才归档）
 * 1-采购入库 2-销售开单 3-商品出库 4-全额开票 5-全额回款
 * 任一环节撤销(发票作废/回款冲回) → 自动退出归档(autoUnarchived=1)
 */
@Data
public class BusinessArchive implements Serializable {
    private Long id;
    private Long companyId;
    private Long orderId;          // 销售订单（以销售单为闭环主体）
    private String orderNo;
    private Long customerId;
    private Integer purchaseDone;  // 采购入库完成
    private Integer saleDraftDone; // 销售开单完成
    private Integer outboundDone;  // 商品出库完成
    private Integer invoiceDone;   // 全额开票完成
    private Integer receiptDone;   // 全额回款完成
    private Integer isArchived;    // 1-已归档 0-未归档
    private LocalDateTime archivedAt;
    private Integer autoUnarchived;   // 是否因撤销/作废自动退出
    private String unarchiveReason;   // 退出原因（如"发票XXX作废"、"回款XXX冲回"）
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
