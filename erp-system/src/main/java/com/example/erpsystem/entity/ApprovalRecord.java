package com.example.erpsystem.entity;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class ApprovalRecord {
    private Long id;
    private Long formId;
    private String formType;      // expense
    private Long approverId;
    private Integer approveResult; // 1-同意 0-驳回
    private String approveComment;
    private LocalDateTime approveTime;
    private Integer level;         // 审批层级
}