package com.example.erpsystem.dto;

import com.alibaba.excel.annotation.ExcelProperty;
import com.alibaba.excel.annotation.write.style.ColumnWidth;
import lombok.Data;

@Data
public class InventoryExportDTO {

    @ExcelProperty("仓库名称")
    @ColumnWidth(15)
    private String warehouseName;

    @ExcelProperty("商品编码")
    @ColumnWidth(20)
    private String skuCode;

    @ExcelProperty("商品名称")
    @ColumnWidth(25)
    private String productName;

    @ExcelProperty("规格")
    @ColumnWidth(15)
    private String spec;

    @ExcelProperty("单位")
    @ColumnWidth(10)
    private String unit;

    @ExcelProperty("账面数量")
    @ColumnWidth(12)
    private Integer bookQuantity;

    @ExcelProperty("实际数量（如有差异请修改）")
    @ColumnWidth(18)
    private Integer actualQuantity;

    @ExcelProperty("差异数量（自动计算，无需填写）")
    @ColumnWidth(18)
    private Integer difference;

    @ExcelProperty("成本价")
    @ColumnWidth(12)
    private java.math.BigDecimal costPrice;

    @ExcelProperty("库存金额")
    @ColumnWidth(12)
    private java.math.BigDecimal totalAmount;
}