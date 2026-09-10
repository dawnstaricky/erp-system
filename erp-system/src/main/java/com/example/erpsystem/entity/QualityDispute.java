package com.example.erpsystem.entity;

import lombok.Data;
import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 质量异议表
 * disputeType: 1-来料(采购侧，责任供应商)  2-销售(客户投诉)
 * 处理后自动联动财务：
 *   采购侧 → 扣减应付(adjustType=扣减应付)
 *   销售侧 → 减免应收(adjustType=减免应收)
 * 每次联动都记录明细(adjustType/adjustedAmount/adjustedBillNo/adjustRemark)
 */
@Data
public class QualityDispute implements Serializable {
    private Long id;
    private String disputeNo;       // 异议单号
    private Long companyId;
    private Integer disputeType;    // 1-来料 2-销售
    private Long supplierId;       // 采购侧：责任供应商
    private Long customerId;       // 销售侧：投诉客户
    private Long orderId;          // 关联订单
    private Long productId;
    private String contractNo;     // 关联合同号
    private Integer quantity;      // 异议数量
    private BigDecimal claimAmount;// 索赔金额
    private String description;    // 异议描述
    private String evidenceUrls;   // 附件URL，逗号分隔
    private String handleMethod;   // 处理方案
    private Integer financeAdjusted;   // 是否已联动财务扣款：1-是
    private String adjustType;     // 抵扣类型：扣减应付/减免应收/退款
    private BigDecimal adjustedAmount; // 扣/减金额
    private String adjustedBillNo; // 关联的应付/应收账单号
    private String adjustRemark;   // 扣款明细说明
    private Integer status;        // 0-待处理 1-已处理
    private Long handlerId;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    private String supplierName;
    private String customerName;
    private String handlerName;
}
