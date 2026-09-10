package com.example.erpsystem.entity;

import lombok.Data;
import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 采购合同（对应采购合同模板：品名/材质/规格/产地/数量/单价/金额/卷号 + 税额）
 */
@Data
public class PurchaseContract implements Serializable {
    private Long id;
    private String contractNo;      // 合同编号（前缀+日期+流水）
    private Long companyId;         // 我方公司
    private Long supplierId;        // 供应商
    private Long orderId;           // 关联采购订单（人工生成后绑定）
    private LocalDate signDate;     // 签订日期
    private BigDecimal totalAmount; // 合同总额
    private BigDecimal taxRate;     // 税率
    private BigDecimal taxAmount;   // 税额
    private Integer isTaxIncluded;  // 1-含税 0-不含税
    private String deliveryMethod;  // 交货方式：自提/送货
    private String paymentTerms;    // 付款方式
    private String deliveryPeriod;  // 交货期限
    private Integer status;         // 0-草稿 1-已签章 2-已作废
    private String remark;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    private List<PurchaseContractItem> items;
    private String supplierName;
    private String companyName;
}
