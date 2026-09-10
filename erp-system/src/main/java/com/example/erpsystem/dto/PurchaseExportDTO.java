package com.example.erpsystem.dto;

import com.alibaba.excel.annotation.ExcelProperty;
import com.alibaba.excel.annotation.write.style.ColumnWidth;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;

@Data
public class PurchaseExportDTO {
    @ExcelProperty("采购单号")
    @ColumnWidth(20)
    private String orderNo;

    @ExcelProperty("供应商名称")
    @ColumnWidth(20)
    private String supplierName;

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

    @ExcelProperty("入库日期")
    @ColumnWidth(12)
    private LocalDate orderDate;

    @ExcelProperty("采购员")
    @ColumnWidth(12)
    private String purchaserName;

    @ExcelProperty("状态")
    @ColumnWidth(10)
    private String statusDesc;
}