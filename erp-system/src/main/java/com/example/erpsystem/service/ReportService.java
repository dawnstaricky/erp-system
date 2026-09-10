package com.example.erpsystem.service;

import com.example.erpsystem.dto.*;
import com.example.erpsystem.mapper.ReportMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.time.LocalDate;
import java.util.List;

@Service
public class ReportService {

    @Autowired
    private ReportMapper reportMapper;

    public List<SalesReportDTO> getSalesDaily(LocalDate startDate, LocalDate endDate, Long warehouseId) {
        return reportMapper.getSalesDaily(startDate, endDate, warehouseId);
    }

    public List<SalesReportDTO> getSalesMonthly(LocalDate startDate, LocalDate endDate, Long warehouseId) {
        return reportMapper.getSalesMonthly(startDate, endDate, warehouseId);
    }

    public List<ProductSalesRankDTO> getProductSalesRank(LocalDate startDate, LocalDate endDate,
                                                         Long warehouseId, int limit) {
        return reportMapper.getProductSalesRank(startDate, endDate, warehouseId, limit);
    }

    public List<CustomerSalesRankDTO> getCustomerSalesRank(LocalDate startDate, LocalDate endDate,
                                                           Long warehouseId, int limit) {
        return reportMapper.getCustomerSalesRank(startDate, endDate, warehouseId, limit);
    }

    public List<InventoryAnalysisDTO> getInventoryAnalysis(Long warehouseId) {
        return reportMapper.getInventoryAnalysis(warehouseId);
    }

    public DashboardDTO getDashboard() {
        return reportMapper.getDashboard();
    }
}