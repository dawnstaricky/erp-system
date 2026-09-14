package com.example.erpsystem.entity;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class SysCompany {
    private Long id;
    private String companyCode;
    private String companyName;
    private String legalPerson;
    private String taxNumber;
    private String address;
    private String phone;
    private String bankName;
    private String bankAccount;
    private String status;
    private String remark;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
