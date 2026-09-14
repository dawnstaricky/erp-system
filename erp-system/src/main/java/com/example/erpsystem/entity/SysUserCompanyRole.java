package com.example.erpsystem.entity;

import lombok.Data;

@Data
public class SysUserCompanyRole {
    private Long id;
    private Long userId;
    private Long companyId;
    private Long roleId;
    private String roleCode;
    private String companyName;
}
