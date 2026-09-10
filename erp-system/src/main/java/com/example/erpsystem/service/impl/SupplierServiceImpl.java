package com.example.erpsystem.service.impl;

import org.springframework.stereotype.Service;
import java.math.BigDecimal;

/**
 * 供应商账务（质量异议扣减应付时使用）
 * 实际账务字段以你现有表结构为准，此处为骨架
 */
@Service
public class SupplierServiceImpl implements SupplierService {

    /** 扣减应付（带异议单号作为明细来源） */
    @Override
    public void deductPayable(Long supplierId, BigDecimal amount, String disputeNo) {
        // TODO: 按你实际应付/对账表实现，例：
        // supplierAccountMapper.increaseDeduction(supplierId, amount, disputeNo);
    }
}
