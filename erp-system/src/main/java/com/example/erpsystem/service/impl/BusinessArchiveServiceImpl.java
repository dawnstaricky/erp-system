package com.example.erpsystem.service.impl;
import com.example.erpsystem.entity.BusinessArchive;
import com.example.erpsystem.entity.Invoice;
import com.example.erpsystem.entity.Receipt;
import com.example.erpsystem.entity.SalesOrder;
import com.example.erpsystem.mapper.BusinessArchiveMapper;
import com.example.erpsystem.mapper.InvoiceMapper;
import com.example.erpsystem.mapper.ReceiptMapper;
import com.example.erpsystem.mapper.SalesOrderMapper;
import com.example.erpsystem.service.BusinessArchiveService;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.time.LocalDateTime;

@Service
public class BusinessArchiveServiceImpl implements BusinessArchiveService {
    @Autowired private BusinessArchiveMapper archiveMapper;
    @Autowired private SalesOrderMapper orderMapper;
    @Autowired private InvoiceMapper invoiceMapper;
    @Autowired private ReceiptMapper receiptMapper;

    @Transactional public BusinessArchive refresh(Long companyId, Long orderId){
        SalesOrder order = orderMapper.selectEntityById(orderId);
        if(order==null) throw new RuntimeException("订单不存在");
        BusinessArchive a = archiveMapper.selectByOrderId(companyId, orderId);
        if(a==null){ a=new BusinessArchive(); a.setCompanyId(companyId); a.setOrderId(orderId); a.setOrderNo(order.getOrderNo()); a.setCustomerId(order.getCustomerId()); }

        // 严格五环节：采购入库 / 销售开单 / 商品出库 / 全额开票 / 全额回款
        a.setSaleDraftDone(order.getStatus()!=null && order.getStatus()>=1 ? 1:0); // 销售开单
        a.setOutboundDone(order.getStatus()!=null && order.getStatus()>=2 ? 1:0);  // 商品出库

        BigDecimal invoiced = invoiceMapper.selectInvoicedAmountByOrderId(orderId);
        a.setInvoiceDone(order.getTotalAmount()!=null && order.getTotalAmount().compareTo(invoiced)==0 && invoiced.compareTo(BigDecimal.ZERO)>0 ? 1:0);

        BigDecimal received = receiptMapper.selectReceivedAmountByOrderId(orderId);
        a.setReceiptDone(order.getTotalAmount()!=null && order.getTotalAmount().compareTo(received)==0 && received.compareTo(BigDecimal.ZERO)>0 ? 1:0);

        // 采购入库：采购侧由采购订单完成状态驱动（简化：销售闭环以销售为主，采购入库环节暂按关联采购完成）
        a.setPurchaseDone(1); // 详见采购完成回调，此处默认满足

        boolean allDone = a.getSaleDraftDone()==1 && a.getOutboundDone()==1
                && a.getInvoiceDone()==1 && a.getReceiptDone()==1 && a.getPurchaseDone()==1;
        if(allDone){ a.setIsArchived(1); a.setArchivedAt(LocalDateTime.now()); a.setAutoUnarchived(0); a.setUnarchiveReason(null); }
        else { a.setIsArchived(0); }

        if(a.getId()==null) archiveMapper.insert(a); else archiveMapper.updateById(a);
        return a;
    }
    @Transactional public void unarchive(Long companyId, Long orderId, String reason){
        BusinessArchive a = archiveMapper.selectByOrderId(companyId, orderId);
        if(a!=null){ archiveMapper.unarchive(a.getId(), reason); }
    }
    public PageInfo<BusinessArchive> page(BusinessArchive q, int pn, int ps){
        com.github.pagehelper.PageHelper.startPage(pn,ps);
        return new PageInfo<>(archiveMapper.selectList(q));
    }
}
