package com.example.erpsystem.dto;
import lombok.Data;
import java.util.List;
@Data
public class ContractGenDTO {
    private Long companyId;
    private Long orderId;       // 采购/销售订单ID
    private String prefix;      // 编号前缀，如 XL-XZL / SS，可配置
    private String deliveryMethod; // 交货方式：自提/送货
    private String paymentTerms;
    private String deliveryPeriod;
}
