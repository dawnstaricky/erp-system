package com.example.erpsystem.service.impl;

import com.alibaba.excel.EasyExcel;
import com.example.erpsystem.common.Result;
import com.example.erpsystem.mapper.ReportMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayOutputStream;
import java.net.URLEncoder;
import java.util.List;
import java.util.Map;

@Service
public class ReportServiceImpl implements ReportService {

    @Autowired private ReportMapper reportMapper;

    @Override
    public Result<?> grossProfit(Map<String, Object> params) {
        // 按销售单：毛利 = 销售价合计 - 成本价合计 - 物流费 - 税额
        List<Map<String, Object>> list = reportMapper.grossProfit(params);
        return Result.success(list);
    }

    @Override
    public Result<?> invoiceReceiptLedger(Map<String, Object> params) {
        // 订单维度：总额/已开票/未开票/已回款/未回款
        List<Map<String, Object>> list = reportMapper.invoiceReceiptLedger(params);
        return Result.success(list);
    }

    @Override
    public Result<?> monthlyExport(Map<String, Object> params, HttpServletResponse response) {
        List<Map<String, Object>> list = reportMapper.monthlyReconciliation(params);
        try {
            ByteArrayOutputStream bos = new ByteArrayOutputStream();
            EasyExcel.write(bos).sheet("月底对账").doWrite(list);
            String fileName = "monthly_" + params.getOrDefault("month", "") + ".xlsx";
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader("Content-Disposition",
                    "attachment;filename=" + URLEncoder.encode(fileName, "UTF-8"));
            response.getOutputStream().write(bos.toByteArray());
            response.getOutputStream().flush();
            return Result.success("导出成功");
        } catch (Exception e) {
            return Result.error(500, "导出失败：" + e.getMessage());
        }
    }
}
