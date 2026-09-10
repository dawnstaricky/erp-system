package com.example.erpsystem.entity;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class SysDepartment {
    private Long id;
    private String deptName;
    private Long parentId;
    private Integer sort;
    private String leader; // 负责人姓名（冗余字段，方便展示，实际审批从用户表查）
    private String phone;
    private String email;
    private Integer status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}