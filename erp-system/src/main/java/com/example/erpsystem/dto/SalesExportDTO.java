package com.example.erpsystem.dto;

import com.alibaba.excel.annotation.ExcelProperty;
import com.alibaba.excel.annotation.write.style.ColumnWidth;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;

@Data
public class SalesExportDTO {

    @ExcelProperty("订单编号")
    @ColumnWidth(20)
    private String orderNo;

    @ExcelProperty("客户名称")
    @ColumnWidth(20)
    private String customerName;

    @ExcelProperty("商品编码")
    @ColumnWidth(20)
    private String skuCode;

    @ExcelProperty("商品名称")
    @ColumnWidth(25)
    private String productName;

    @ExcelProperty("规格")
    @ColumnWidth(15)
    private String spec;

    @ExcelProperty("数量")
    @ColumnWidth(10)
    private Integer quantity;

    @ExcelProperty("单价")
    @ColumnWidth(12)
    private BigDecimal price;

    @ExcelProperty("金额")
    @ColumnWidth(12)
    private BigDecimal amount;

    @ExcelProperty("订单日期")
    @ColumnWidth(12)
    private LocalDate orderDate;

    @ExcelProperty("销售员")
    @ColumnWidth(12)
    private String salesmanName;

    @ExcelProperty("状态")
    @ColumnWidth(10)
    private String statusDesc;
}