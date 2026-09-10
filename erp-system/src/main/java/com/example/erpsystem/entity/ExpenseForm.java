package com.example.erpsystem.entity;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Data
public class ExpenseForm {
    private Long id;
    private String formNo;
    private Long applicantId;
    private Long deptId;
    @NotNull(message = "申请日期不能为空")
    private LocalDate applyDate;
    @NotNull(message = "总金额不能为空")
    @Min(value = 0, message = "总金额不能小于0")
    private BigDecimal totalAmount;
    private String reason;
    private Long currentApproverId;
    private Integer status;
    private LocalDate paymentDate;
    private String remark;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    // ✅ 新增附件字段（多张发票用逗号分隔）
    private String attachmentUrls;
    private List<String> attachmentUrlsList; // 前端用，不用存库
}