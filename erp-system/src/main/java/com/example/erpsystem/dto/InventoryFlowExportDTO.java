package com.example.erpsystem.dto;

import com.alibaba.excel.annotation.ExcelProperty;
import com.alibaba.excel.annotation.write.style.ColumnWidth;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class InventoryFlowExportDTO {
    @ExcelProperty("流水时间")
    @ColumnWidth(20)
    private LocalDateTime flowTime;

    @ExcelProperty("商品编码")
    @ColumnWidth(20)
    private String skuCode;

    @ExcelProperty("商品名称")
    @ColumnWidth(25)
    private String productName;

    @ExcelProperty("仓库")
    @ColumnWidth(15)
    private String warehouseName;

    @ExcelProperty("业务类型")
    @ColumnWidth(12)
    private String flowType;

    @ExcelProperty("变动数量")
    @ColumnWidth(12)
    private Integer quantityChange;

    @ExcelProperty("变动后库存")
    @ColumnWidth(12)
    private Integer quantityAfter;

    @ExcelProperty("关联单号")
    @ColumnWidth(20)
    private String relatedOrderNo;

    @ExcelProperty("操作人")
    @ColumnWidth(12)
    private String operatorName;

    @ExcelProperty("备注")
    @ColumnWidth(20)
    private String remark;
}