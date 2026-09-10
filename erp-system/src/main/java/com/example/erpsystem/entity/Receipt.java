package com.example.erpsystem.entity;

import lombok.Data;
import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * 销售回款登记表（回款冲抵应收）
 * - 绑定订单(orderId)：直接冲抵该单 unpaid_amount
 * - 杜绝无单回款：orderId 必填
 */
@Data
public class Receipt implements Serializable {
    private Long id;
    private String receiptNo;       // 回款单号
    private Long companyId;         // 公司
    private Long customerId;        // 客户
    private Long orderId;           // 核销的销售订单（必填，杜绝无单回款）
    private String orderNo;         // 订单号（冗余）
    private LocalDate receiptDate;  // 回款日期
    private BigDecimal amount;      // 回款金额
    private String paymentMethod;   // 收款方式：银行转账/承兑/现金
    private String bankAccount;     // 收款账户
    private BigDecimal allocatedAmount; // 已核销金额
    private BigDecimal unallocatedAmount; // 未核销余额
    private String remark;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    private String customerName;
}
