package com.example.erpsystem.entity;

import lombok.Data;
import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 公司/抬头管理表
 */
@Data
public class SysCompany implements Serializable {
    private Long id;
    private String companyCode;   // 公司编码（如 SS/LY/YZ）
    private String companyName;   // 公司名称（抬头）
    private String legalPerson;   // 法定代表人
    private String taxNumber;     // 统一社会信用代码/税号
    private String address;       // 地址
    private String phone;         // 电话
    private String bankName;      // 开户行
    private String bankAccount;   // 银行账号
    private String contractPrefix; // 合同编号前缀（可配置）
    private Integer status;       // 1-正常 0-停用
    private String remark;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
