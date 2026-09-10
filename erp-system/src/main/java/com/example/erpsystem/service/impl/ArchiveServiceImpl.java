package com.example.erpsystem.service.impl;

import com.example.erpsystem.common.Result;
import com.example.erpsystem.entity.BusinessArchive;
import com.example.erpsystem.entity.Invoice;
import com.example.erpsystem.entity.Receipt;
import com.example.erpsystem.entity.SalesOrder;
import com.example.erpsystem.mapper.BusinessArchiveMapper;
import com.example.erpsystem.mapper.InvoiceMapper;
import com.example.erpsystem.mapper.ReceiptMapper;
import com.example.erpsystem.mapper.SalesOrderMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;

/**
 * 业务闭环归档引擎：
 * - 五环节全部满足 → 归档（isArchived=1）
 * - 发票作废 / 回款冲回 → 自动退出归档（autoUnarchived=1 + 原因）
 * 触发点：开票/作废/回款/出库 等事件后调用 checkAndArchive(orderId)
 */
@Service
public class ArchiveServiceImpl implements ArchiveService {

    @Autowired private BusinessArchiveMapper archiveMapper;
    @Autowired private SalesOrderMapper salesOrderMapper;
    @Autowired private InvoiceMapper invoiceMapper;
    @Autowired private ReceiptMapper receiptMapper;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void checkAndArchive(Long salesOrderId) {
        SalesOrder order = salesOrderMapper.selectById(salesOrderId);
        if (order == null) return;

        BusinessArchive archive = archiveMapper.selectByOrder(salesOrderId);
        if (archive == null) {
            archive = new BusinessArchive();
            archive.setCompanyId(order.getCompanyId());
            archive.setOrderId(order.getId());
            archive.setOrderNo(order.getOrderNo());
            archive.setCustomerId(order.getCustomerId());
            archiveMapper.insert(archive);
        }

        // 1. 采购入库完成：该销售单关联的采购单已入库
        archive.setPurchaseDone(hasRelatedPurchaseStockIn(order.getId()) ? 1 : 0);
        // 2. 销售开单完成：订单本身存在即完成
        archive.setSaleDraftDone(1);
        // 3. 商品出库完成：销售单状态为已出库
        archive.setOutboundDone("2".equals(order.getStatus()) ? 1 : 0); // 沿用销售单状态字段
        // 4. 全额开票完成：已开票总额 >= 订单总额
        BigDecimal invoiced = invoiceMapper.sumAmountByOrder(order.getId());
        archive.setInvoiceDone(invoiced.compareTo(order.getTotalAmount()) >= 0 ? 1 : 0);
        // 5. 全额回款完成：已回款总额 >= 订单总额
        BigDecimal received = receiptMapper.sumAmountByOrder(order.getId());
        archive.setReceiptDone(received.compareTo(order.getTotalAmount()) >= 0 ? 1 : 0);

        // 严格五环节全满足才归档
        boolean allDone = archive.getPurchaseDone() == 1
                && archive.getSaleDraftDone() == 1
                && archive.getOutboundDone() == 1
                && archive.getInvoiceDone() == 1
                && archive.getReceiptDone() == 1;

        if (allDone && archive.getIsArchived() == 0) {
            archive.setIsArchived(1);
            archive.setArchivedAt(java.time.LocalDateTime.now());
            archive.setAutoUnarchived(0);
            archive.setUnarchiveReason(null);
        } else if (!allDone && archive.getIsArchived() == 1) {
            // 已归档但环节被撤销 → 自动退出
            archive.setIsArchived(0);
            archive.setAutoUnarchived(1);
            archive.setUnarchiveReason(buildUnarchiveReason(archive, invoiced, received, order.getTotalAmount()));
        }

        archiveMapper.updateById(archive);
    }

    /** 构建退出归档原因（哪个环节不满足） */
    private String buildUnarchiveReason(BusinessArchive a, BigDecimal invoiced, BigDecimal received, BigDecimal total) {
        StringBuilder sb = new StringBuilder();
        if (a.getInvoiceDone() == 1 && invoiced.compareTo(total) < 0) sb.append("发票作废;");
        if (a.getReceiptDone() == 1 && received.compareTo(total) < 0) sb.append("回款冲回;");
        if (a.getOutboundDone() == 1 && a.getOutboundDone() == 0) sb.append("出库撤销;");
        return sb.length() > 0 ? sb.toString() : "环节状态变化";
    }

    private boolean hasRelatedPurchaseStockIn(Long salesOrderId) {
        // 关联逻辑：销售单通过商品/采购单关联，此处按实际业务补充
        // 简化：存在对应采购单且已入库即返回 true
        return archiveMapper.existsPurchaseStockIn(salesOrderId);
    }
}
