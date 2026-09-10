package com.example.erpsystem.dto;

import com.alibaba.excel.annotation.ExcelProperty;
import com.alibaba.excel.annotation.write.style.ColumnWidth;
import lombok.Data;
import java.math.BigDecimal;

@Data
public class CustomerSalesRankDTO {
    @ExcelProperty("排名")
    @ColumnWidth(8)
    private Integer custRank;

    @ExcelProperty("客户名称")
    @ColumnWidth(20)
    private String customerName;

    @ExcelProperty("订单数")
    @ColumnWidth(10)
    private Integer orderCount;

    @ExcelProperty("采购金额")
    @ColumnWidth(15)
    private BigDecimal totalAmount;
}