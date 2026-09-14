package com.example.erpsystem.service;
import com.example.erpsystem.entity.QualityDispute;
import com.github.pagehelper.PageInfo;
public interface QualityDisputeService {
    PageInfo<QualityDispute> page(QualityDispute q, int pageNum, int pageSize);
    Long create(QualityDispute d);
    void handle(Long id, String handleMethod, String adjustType, java.math.BigDecimal adjustedAmount, String adjustedBillNo, String adjustRemark);
}
