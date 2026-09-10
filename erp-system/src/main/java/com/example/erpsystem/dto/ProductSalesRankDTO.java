package com.example.erpsystem.dto;

import com.alibaba.excel.annotation.ExcelProperty;
import com.alibaba.excel.annotation.write.style.ColumnWidth;
import lombok.Data;
import java.math.BigDecimal;

@Data
public class ProductSalesRankDTO {
    @ExcelProperty("排名")
    @ColumnWidth(8)
    private Integer prodRank;

    @ExcelProperty("商品编码")
    @ColumnWidth(20)
    private String skuCode;

    @ExcelProperty("商品名称")
    @ColumnWidth(25)
    private String productName;

    @ExcelProperty("规格")
    @ColumnWidth(15)
    private String spec;

    @ExcelProperty("销售数量")
    @ColumnWidth(12)
    private Integer totalQuantity;

    @ExcelProperty("销售金额")
    @ColumnWidth(15)
    private BigDecimal totalAmount;
}