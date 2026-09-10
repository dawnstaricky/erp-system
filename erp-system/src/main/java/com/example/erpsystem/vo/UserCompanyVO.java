package com.example.erpsystem.vo;

import lombok.Data;
import java.util.List;

/**
 * 用户可进入的公司 + 在该公司的角色
 */
@Data
public class UserCompanyVO {
    private Long companyId;
    private String companyName;
    private Integer isMain;
    private List<String> roleCodes; // 该公司下的角色 code
}
