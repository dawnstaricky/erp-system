package com.example.erpsystem.service;
import com.example.erpsystem.common.Result;
import javax.servlet.http.HttpServletResponse;
public interface ContractService {
    Result<?> generatePurchase(Long orderId, HttpServletResponse response);
    Result<?> generateSales(Long orderId, HttpServletResponse response);
}
