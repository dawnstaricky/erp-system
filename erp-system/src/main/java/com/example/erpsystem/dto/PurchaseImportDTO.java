package com.example.erpsystem.dto;

import com.alibaba.excel.annotation.ExcelProperty;
import com.alibaba.excel.annotation.write.style.ColumnWidth;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class PurchaseImportDTO {

    @ExcelProperty("供应商编码*")
    @NotBlank(message = "供应商编码不能为空")
    @ColumnWidth(15)
    private String supplierCode;

    @ExcelProperty("仓库编码*")
    @NotBlank(message = "仓库编码不能为空")
    @ColumnWidth(15)
    private String warehouseCode;

    @ExcelProperty("商品编码*")
    @NotBlank(message = "商品编码不能为空")
    @ColumnWidth(20)
    private String skuCode;

    @ExcelProperty("商品名称")
    @ColumnWidth(25)
    private String productName;

    @ExcelProperty("规格")
    @ColumnWidth(15)
    private String spec;

    @ExcelProperty("数量*")
    @NotNull(message = "数量不能为空")
    @Min(value = 1, message = "数量必须大于0")
    @ColumnWidth(10)
    private Integer quantity;

    @ExcelProperty("单价*")
    @NotNull(message = "单价不能为空")
    @Min(value = 0, message = "单价不能小于0")
    @ColumnWidth(12)
    private java.math.BigDecimal price;

    @ExcelProperty("备注")
    @ColumnWidth(20)
    private String remark;
}