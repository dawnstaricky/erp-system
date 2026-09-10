package com.example.erpsystem.service.impl;

import com.example.erpsystem.common.Result;
import com.example.erpsystem.entity.Invoice;
import com.example.erpsystem.mapper.InvoiceMapper;
import com.example.erpsystem.mapper.SalesOrderMapper;
import com.example.erpsystem.service.InvoiceService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.servlet.http.HttpServletRequest;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@Service
public class InvoiceServiceImpl implements InvoiceService {

    @Autowired private InvoiceMapper invoiceMapper;
    @Autowired private SalesOrderMapper salesOrderMapper;

    @Override
    public Result<?> page(Map<String, Object> params) {
        int pageNum = (Integer) params.getOrDefault("pageNum", 1);
        int pageSize = (Integer) params.getOrDefault("pageSize", 10);
        Long companyId = (Long) params.get("companyId");
        Long customerId = (Long) params.get("customerId");
        Long orderId = (Long) params.get("orderId");
        Integer status = (Integer) params.get("status");

        PageHelper.startPage(pageNum, pageSize);
        List<Invoice> list = invoiceMapper.selectList(companyId, customerId, orderId, status, null, null);
        return Result.success(new PageInfo<>(list));
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result<?> create(Invoice invoice) {
        // 校验：开票金额 <= 订单未开票金额（杜绝无单开票 / 超额开票）
        BigDecimal invoiced = invoiceMapper.sumAmountByOrder(invoice.getOrderId());
        SalesOrder order = salesOrderMapper.selectById(invoice.getOrderId());
        if (order == null) return Result.error(400, "订单不存在");
        if (invoice.getOrderId() == null) return Result.error(400, "不允许无单开票");
        BigDecimal uninvoiced = order.getTotalAmount().subtract(invoiced);
        if (invoice.getTotalAmount().compareTo(uninvoiced) > 0) {
            return Result.error(400, "开票金额超过订单未开票金额：" + uninvoiced);
        }
        invoice.setStatus(1);
        if (invoice.getInvoiceDate() == null) invoice.setInvoiceDate(LocalDate.now());
        invoiceMapper.insert(invoice);
        // 触发归档判定
        archiveService.checkAndArchive(order.getId());
        return Result.success("开票成功");
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result<?> voidInvoice(Long id) {
        Invoice invoice = invoiceMapper.selectById(id);
        if (invoice == null) return Result.error(404, "发票不存在");
        invoice.setStatus(2); // 作废/红冲
        invoiceMapper.updateById(invoice);
        // 作废后该订单可能退出"全额开票"，触发撤销归档
        archiveService.checkAndArchive(invoice.getOrderId());
        return Result.success("发票已作废");
    }

    @Override
    public Result<?> export(Map<String, Object> params) {
        // 复用 EasyExcel 导出（见 InvoiceExportController）
        return Result.success("导出任务已提交");
    }
}
