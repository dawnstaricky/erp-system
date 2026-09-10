package com.example.erpsystem.dto;

import lombok.Data;
import java.math.BigDecimal;

@Data
public class DashboardDTO {
    private BigDecimal todaySales;          // 今日销售额
    private BigDecimal monthSales;          // 本月销售额
    private BigDecimal monthPurchase;        // 本月采购额
    private BigDecimal monthProfit;          // 本月毛利
    private Integer pendingApprovalCount;    // 待审批数
    private Integer lowStockCount;           // 库存预警数
    private Integer productCount;            // 商品总数
    private Integer customerCount;           // 客户总数
}