package com.example.erpsystem.entity;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class PurchaseOrder {
    private Long id;
    private String orderNo;
    @NotNull(message = "供应商不能为空")
    private Long supplierId;
    @NotNull(message = "仓库不能为空")
    private Long warehouseId;
    private BigDecimal totalAmount;
    private Integer status;
    private Long purchaserId;
    @NotNull(message = "订单日期不能为空")
    private LocalDate orderDate;
    private String remark;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // ===== 多公司隔离 & 单据扩展字段（功能说明） =====
    /** 所属公司ID */
    private Long companyId;
    /** 交货方式：自提 / 送货 */
    private String deliveryMethod;
    /** 是否含税 */
    private Boolean isTaxIncluded;
    /** 税率（如 13.00） */
    private BigDecimal taxRate;
    /** 税额 */
    private BigDecimal taxAmount;
    /** 无税金额 */
    private BigDecimal untaxedAmount;
    /** 是否已全额开票：0-否 1-是 */
    private Integer invoiceDone;
}