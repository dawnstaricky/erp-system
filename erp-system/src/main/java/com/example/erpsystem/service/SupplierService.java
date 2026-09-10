package com.example.erpsystem.service;
import java.math.BigDecimal;
public interface SupplierService {
    void deductPayable(Long supplierId, BigDecimal amount, String disputeNo);
}
