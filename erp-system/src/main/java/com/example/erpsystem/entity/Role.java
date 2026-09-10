package com.example.erpsystem.entity;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class Role {
    private Long id;
    private String roleName;     // 角色名称，如"管理员"
    private String roleCode;     // 角色编码，仅用你给的8个值
    private String description;  // 角色描述
    private Integer status;      // 1启用，0禁用
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}