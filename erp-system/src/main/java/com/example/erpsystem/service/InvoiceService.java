package com.example.erpsystem.service;

import com.example.erpsystem.common.Result;
import com.example.erpsystem.entity.Invoice;
import java.util.Map;

public interface InvoiceService {
    Result<?> page(Map<String, Object> params);
    Result<?> create(Invoice invoice);
    Result<?> voidInvoice(Long id);
    Result<?> export(Map<String, Object> params);
}
