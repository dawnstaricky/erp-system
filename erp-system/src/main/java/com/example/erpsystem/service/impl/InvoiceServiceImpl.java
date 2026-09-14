package com.example.erpsystem.service.impl;
import com.example.erpsystem.entity.Invoice;
import com.example.erpsystem.mapper.InvoiceMapper;
import com.example.erpsystem.mapper.SalesOrderMapper;
import com.example.erpsystem.service.BusinessArchiveService;
import com.example.erpsystem.service.InvoiceService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.math.BigDecimal;
import java.time.LocalDate;
@Service
public class InvoiceServiceImpl implements InvoiceService {
    @Autowired private InvoiceMapper invoiceMapper;
    @Autowired private SalesOrderMapper orderMapper;
    @Autowired private BusinessArchiveService archiveService;
    public PageInfo<Invoice> page(Invoice q, int pageNum, int pageSize){
        PageHelper.startPage(pageNum, pageSize);
        return new PageInfo<>(invoiceMapper.selectList(q));
    }
    @Transactional public void create(Invoice inv){
        // 杜绝无单开票：必须绑定订单
        if(inv.getOrderId()==null) throw new RuntimeException("开票必须关联销售订单");
        var order = orderMapper.selectById(inv.getOrderId());
        if(order==null) throw new RuntimeException("销售订单不存在");
        BigDecimal invoiced = invoiceMapper.selectInvoicedAmountByOrderId(inv.getOrderId());
        BigDecimal unpaid = order.getTotalAmount().subtract(invoiced);
        if(inv.getAmount()==null || inv.getAmount().compareTo(BigDecimal.ZERO)<=0)
            throw new RuntimeException("开票金额必须大于0");
        if(inv.getAmount().compareTo(unpaid)>0)
            throw new RuntimeException("开票金额不能超过未开票金额："+unpaid);
        if(inv.getStatus()==null) inv.setStatus(1);
        if(inv.getInvoiceDate()==null) inv.setInvoiceDate(LocalDate.now());
        inv.setOrderNo(order.getOrderNo());
        inv.setCustomerId(order.getCustomerId());
        // 开票即产生应收：invoice 记录本身就是应收凭证
        invoiceMapper.insert(inv);
        // 触发归档判定
        archiveService.refresh(inv.getCompanyId(), inv.getOrderId());
    }
    @Transactional public void voidInvoice(Long id){
        Invoice inv = invoiceMapper.selectById(id);
        if(inv==null) throw new RuntimeException("发票不存在");
        invoiceMapper.voidInvoice(id);
        // 作废 -> 自动退出归档
        archiveService.unarchive(inv.getCompanyId(), inv.getOrderId(), "发票作废："+inv.getInvoiceNo());
    }
    public BigDecimal getInvoicedAmount(Long orderId){ return invoiceMapper.selectInvoicedAmountByOrderId(orderId); }
}
