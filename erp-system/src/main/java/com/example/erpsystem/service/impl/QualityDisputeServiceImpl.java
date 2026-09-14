package com.example.erpsystem.service.impl;
import com.example.erpsystem.entity.QualityDispute;
import com.example.erpsystem.mapper.QualityDisputeMapper;
import com.example.erpsystem.service.QualityDisputeService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
@Service
public class QualityDisputeServiceImpl implements QualityDisputeService {
    @Autowired private QualityDisputeMapper mapper;
    public PageInfo<QualityDispute> page(QualityDispute q, int pn, int ps){
        PageHelper.startPage(pn,ps); return new PageInfo<>(mapper.selectList(q));
    }
    @Transactional public Long create(QualityDispute d){
        if(d.getDisputeNo()==null){
            d.setDisputeNo("Q-" + LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd")) + "-" + System.currentTimeMillis()%10000);
        }
        if(d.getStatus()==null) d.setStatus(0);
        mapper.insert(d);
        return d.getId();
    }
    /**
     * 处理异议并自动联动财务：
     * disputeType=1(来料/采购侧) -> 扣减应付(adjustType=扣减应付)，明细写入 adjustType/adjustedAmount/adjustedBillNo/adjustRemark
     * disputeType=2(销售/客户投诉) -> 减免应收(adjustType=减免应收)
     * 自动改账单：此处记录调整明细，供应付/应收台账核销（与开票回款台账联动）
     */
    @Transactional public void handle(Long id, String handleMethod, String adjustType, java.math.BigDecimal adjustedAmount, String adjustedBillNo, String adjustRemark){
        QualityDispute d = mapper.selectById(id);
        if(d==null) throw new RuntimeException("异议单不存在");
        d.setHandleMethod(handleMethod);
        d.setAdjustType(adjustType);
        d.setAdjustedAmount(adjustedAmount);
        d.setAdjustedBillNo(adjustedBillNo);
        d.setAdjustRemark(adjustRemark);
        d.setFinanceAdjusted(1);
        d.setStatus(1);
        mapper.updateById(d);
        // TODO: 在此调用应付/应收账单调整接口，实现"自动改账单"（需结合既有账单表，明细见 adjustRemark）
    }
}
