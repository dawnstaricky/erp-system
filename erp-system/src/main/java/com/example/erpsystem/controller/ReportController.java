package com.example.erpsystem.controller;

import com.example.erpsystem.common.Result;
import com.example.erpsystem.service.ReportService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import javax.servlet.http.HttpServletRequest;
import java.util.Map;

@RestController
@RequestMapping("/api/report")
public class ReportController {

    @Autowired private ReportService reportService;

    /** 毛利报表：按商品/客户/时间段汇总（成本/售价/税额/物流费） */
    @GetMapping("/gross-profit")
    public Result<?> grossProfit(@RequestParam Map<String, Object> params, HttpServletRequest request) {
        params.put("companyId", com.example.erpsystem.common.CompanyContext.getCurrentCompanyId(request));
        return reportService.grossProfit(params);
    }

    /** 开票回款台账：订单维度，开票额/回款额/未开票/未回款 */
    @GetMapping("/invoice-receipt")
    public Result<?> invoiceReceiptLedger(@RequestParam Map<String, Object> params, HttpServletRequest request) {
        params.put("companyId", com.example.erpsystem.common.CompanyContext.getCurrentCompanyId(request));
        return reportService.invoiceReceiptLedger(params);
    }

    /** 月底对账导出（开票/回款/应收应付汇总，导出 Excel） */
    @GetMapping("/monthly-reconciliation/export")
    public Result<?> monthlyExport(@RequestParam Map<String, Object> params, HttpServletRequest request) {
        params.put("companyId", com.example.erpsystem.common.CompanyContext.getCurrentCompanyId(request));
        return reportService.monthlyExport(params, request);
    }
}
