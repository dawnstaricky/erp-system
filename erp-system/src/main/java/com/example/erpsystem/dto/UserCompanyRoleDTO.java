package com.example.erpsystem.dto;

import lombok.Data;


@Data
public class UserCompanyRoleDTO {
    private Long companyId;
    private String companyName;
    private Long roleId;
    private String roleCode;
}

