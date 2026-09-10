package com.example.erpsystem.dto;

import com.alibaba.excel.annotation.ExcelProperty;
import com.alibaba.excel.annotation.write.style.ColumnWidth;
import lombok.Data;
import java.math.BigDecimal;

@Data
public class InventoryAnalysisDTO {
    @ExcelProperty("商品编码")
    @ColumnWidth(20)
    private String skuCode;

    @ExcelProperty("商品名称")
    @ColumnWidth(25)
    private String productName;

    @ExcelProperty("规格")
    @ColumnWidth(15)
    private String spec;

    @ExcelProperty("当前库存")
    @ColumnWidth(12)
    private Integer quantity;

    @ExcelProperty("成本价")
    @ColumnWidth(12)
    private BigDecimal costPrice;

    @ExcelProperty("库存金额")
    @ColumnWidth(15)
    private BigDecimal stockAmount;

    @ExcelProperty("近30天销量")
    @ColumnWidth(12)
    private Integer sales30d;

    @ExcelProperty("库存周转天数")
    @ColumnWidth(15)
    private BigDecimal turnoverDays;

    @ExcelProperty("健康度")
    @ColumnWidth(10)
    private String healthStatus;
}