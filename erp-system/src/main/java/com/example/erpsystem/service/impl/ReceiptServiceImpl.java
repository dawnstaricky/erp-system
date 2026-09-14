package com.example.erpsystem.service.impl;
import com.example.erpsystem.entity.Receipt;
import com.example.erpsystem.entity.SalesOrder;
import com.example.erpsystem.mapper.ReceiptMapper;
import com.example.erpsystem.mapper.SalesOrderMapper;
import com.example.erpsystem.service.BusinessArchiveService;
import com.example.erpsystem.service.ReceiptService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.math.BigDecimal;
import java.time.LocalDate;
@Service
public class ReceiptServiceImpl implements ReceiptService {
    @Autowired private ReceiptMapper receiptMapper;
    @Autowired private SalesOrderMapper orderMapper;
    @Autowired private BusinessArchiveService archiveService;
    public PageInfo<Receipt> page(Receipt q, int pageNum, int pageSize){
        PageHelper.startPage(pageNum, pageSize);
        return new PageInfo<>(receiptMapper.selectList(q));
    }
    @Transactional public void create(Receipt r){
        // 杜绝无单回款：必须绑定订单
        if(r.getOrderId()==null) throw new RuntimeException("回款必须关联销售订单（杜绝无单回款）");
        SalesOrder order = orderMapper.selectEntityById(r.getOrderId());
        if(order==null) throw new RuntimeException("销售订单不存在");
        BigDecimal received = receiptMapper.selectReceivedAmountByOrderId(r.getOrderId());
        BigDecimal receivable = order.getTotalAmount().subtract(received);
        if(r.getAmount()==null || r.getAmount().compareTo(BigDecimal.ZERO)<=0)
            throw new RuntimeException("回款金额必须大于0");
        if(r.getAmount().compareTo(receivable)>0)
            throw new RuntimeException("回款金额不能超过未收金额："+receivable);
        if(r.getReceiptDate()==null) r.setReceiptDate(LocalDate.now());
        r.setOrderNo(order.getOrderNo());
        r.setCustomerId(order.getCustomerId());
        r.setUnallocatedAmount(BigDecimal.ZERO); // 无预收款，全部即时冲抵
        receiptMapper.insert(r);
        // 回款冲抵应收：更新订单已收金额（驱动归档）
        archiveService.refresh(r.getCompanyId(), r.getOrderId());
    }
    public BigDecimal getReceivedAmount(Long orderId){ return receiptMapper.selectReceivedAmountByOrderId(orderId); }
}
