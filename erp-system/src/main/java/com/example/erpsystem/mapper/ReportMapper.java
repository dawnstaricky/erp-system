package com.example.erpsystem.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Param;
import java.util.List;
import java.util.Map;

@Mapper
public interface ReportMapper {

    /** 毛利报表 */
    @Select("<script>" +
            "SELECT so.customer_id, c.customer_name, p.id AS product_id, p.product_name, " +
            "       SUM(soi.quantity) AS qty, " +
            "       SUM(soi.quantity * soi.unit_price) AS sale_total, " +
            "       SUM(soi.quantity * p.cost_price) AS cost_total, " +
            "       SUM(soi.quantity * (soi.unit_price - p.cost_price)) AS gross_profit " +
            "FROM sales_order so " +
            "INNER JOIN sales_order_item soi ON so.id = soi.order_id " +
            "INNER JOIN product p ON soi.product_id = p.id " +
            "LEFT JOIN customer c ON so.customer_id = c.id " +
            "<where> " +
            "   <if test='companyId != null'>AND so.company_id = #{companyId}</if> " +
            "   <if test='startDate != null'>AND so.created_at &gt;= #{startDate}</if> " +
            "   <if test='endDate != null'>AND so.created_at &lt;= #{endDate}</if> " +
            "</where> " +
            "GROUP BY so.customer_id, p.id " +
            "ORDER BY gross_profit DESC" +
            "</script>")
    List<Map<String, Object>> grossProfit(@Param("params") Map<String, Object> params);

    /** 开票回款台账（订单维度） */
    List<Map<String, Object>> invoiceReceiptLedger(@Param("params") Map<String, Object> params);

    /** 月底对账汇总 */
    List<Map<String, Object>> monthlyReconciliation(@Param("params") Map<String, Object> params);
}
