package com.example.erpsystem.entity;

import lombok.Data;
import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * 销售开票登记表（开票即产生应收）
 */
@Data
public class Invoice implements Serializable {
    private Long id;
    private String invoiceNo;       // 发票号码（唯一）
    private Long companyId;        // 开票方公司
    private Long customerId;       // 购方（客户）
    private Long orderId;          // 关联销售订单
    private String orderNo;        // 订单号（冗余，便于查询）
    private String invoiceType;    // 发票类型：增值税专用发票/普通发票
    private LocalDate invoiceDate; // 开票日期
    private BigDecimal totalAmount;// 开票金额（必须 <= 订单未开票金额）
    private BigDecimal taxRate;    // 税率
    private String fileUrl;        // 发票附件 URL
    private Integer status;        // 1-正常 2-作废(红冲)
    private String remark;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // 非表字段
    private String customerName;
}
