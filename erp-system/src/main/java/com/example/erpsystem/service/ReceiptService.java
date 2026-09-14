package com.example.erpsystem.service;
import com.example.erpsystem.entity.Receipt;
import com.github.pagehelper.PageInfo;
public interface ReceiptService {
    PageInfo<Receipt> page(Receipt q, int pageNum, int pageSize);
    /** 杜绝无单回款：必须传 orderId，amount <= 未收金额，回款冲抵应收 */
    void create(Receipt r);
    java.math.BigDecimal getReceivedAmount(Long orderId);
}
