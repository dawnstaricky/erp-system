package com.example.erpsystem.dto;

import com.alibaba.excel.annotation.ExcelProperty;
import com.alibaba.excel.annotation.write.style.ColumnWidth;
import lombok.Data;
import java.math.BigDecimal;

@Data
public class SalesReportDTO {
    @ExcelProperty("日期")
    @ColumnWidth(15)
    private String reportDate;

    @ExcelProperty("订单数")
    @ColumnWidth(10)
    private Integer orderCount;

    @ExcelProperty("销售数量")
    @ColumnWidth(12)
    private Integer totalQuantity;

    @ExcelProperty("销售金额")
    @ColumnWidth(15)
    private BigDecimal totalAmount;

    @ExcelProperty("成本金额")
    @ColumnWidth(15)
    private BigDecimal totalCost;

    @ExcelProperty("毛利")
    @ColumnWidth(15)
    private BigDecimal grossProfit;

    @ExcelProperty("毛利率(%)")
    @ColumnWidth(12)
    private BigDecimal profitRate;
}