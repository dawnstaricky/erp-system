package com.example.erpsystem.mapper;

import com.example.erpsystem.dto.SalesReportDTO;
import com.example.erpsystem.dto.ProductSalesRankDTO;
import com.example.erpsystem.dto.CustomerSalesRankDTO;
import com.example.erpsystem.dto.InventoryAnalysisDTO;
import com.example.erpsystem.dto.DashboardDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.time.LocalDate;
import java.util.List;

@Mapper
public interface ReportMapper {

    // 销售日报（按天汇总）
    List<SalesReportDTO> getSalesDaily(@Param("startDate") LocalDate startDate,
                                       @Param("endDate") LocalDate endDate,
                                       @Param("warehouseId") Long warehouseId);

    // 销售月报（按月汇总）
    List<SalesReportDTO> getSalesMonthly(@Param("startDate") LocalDate startDate,
                                         @Param("endDate") LocalDate endDate,
                                         @Param("warehouseId") Long warehouseId);

    // 商品销售排行
    List<ProductSalesRankDTO> getProductSalesRank(@Param("startDate") LocalDate startDate,
                                                  @Param("endDate") LocalDate endDate,
                                                  @Param("warehouseId") Long warehouseId,
                                                  @Param("limit") int limit);

    // 客户销售排行
    List<CustomerSalesRankDTO> getCustomerSalesRank(@Param("startDate") LocalDate startDate,
                                                    @Param("endDate") LocalDate endDate,
                                                    @Param("warehouseId") Long warehouseId,
                                                    @Param("limit") int limit);

    // 库存分析（含周转天数）
    List<InventoryAnalysisDTO> getInventoryAnalysis(@Param("warehouseId") Long warehouseId);

    // 仪表盘汇总
    DashboardDTO getDashboard();
}