package com.example.erpsystem.service;
import com.example.erpsystem.common.Result;
import com.example.erpsystem.entity.Receipt;
import java.util.Map;
public interface ReceiptService {
    Result<?> page(Map<String, Object> params);
    Result<?> create(Receipt receipt);
}
