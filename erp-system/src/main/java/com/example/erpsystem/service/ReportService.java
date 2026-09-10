package com.example.erpsystem.service;
import com.example.erpsystem.common.Result;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;
public interface ReportService {
    Result<?> grossProfit(Map<String, Object> params);
    Result<?> invoiceReceiptLedger(Map<String, Object> params);
    Result<?> monthlyExport(Map<String, Object> params, HttpServletResponse response);
}
