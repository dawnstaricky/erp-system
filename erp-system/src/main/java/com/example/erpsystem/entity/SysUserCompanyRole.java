package com.example.erpsystem.entity;

import lombok.Data;
import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 用户-公司-角色关联表（三元关系）
 * 一个用户在同一公司可拥有多个角色；登录后选定公司，按 (user, company) 取角色
 */
@Data
public class SysUserCompanyRole implements Serializable {
    private Long id;
    private Long userId;
    private Long companyId;
    private Long roleId;
    private Integer isMain;      // 是否主公司：1-是 0-否
    private LocalDateTime createdAt;

    // 非表字段：方便前端展示
    private String companyName;
    private String roleCode;
    private String roleName;
}
