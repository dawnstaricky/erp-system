package com.example.erpsystem.service;
import com.example.erpsystem.entity.Invoice;
import com.github.pagehelper.PageInfo;
public interface InvoiceService {
    PageInfo<Invoice> page(Invoice q, int pageNum, int pageSize);
    /** 分批开票：amount 必须 <= 订单未开票金额；开票即产生应收 */
    void create(Invoice inv);
    void voidInvoice(Long id);
    /** 订单已开票金额（用于回款/归档判定） */
    java.math.BigDecimal getInvoicedAmount(Long orderId);
}
