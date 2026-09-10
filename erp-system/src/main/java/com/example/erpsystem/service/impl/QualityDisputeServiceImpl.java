package com.example.erpsystem.service.impl;

import com.example.erpsystem.common.Result;
import com.example.erpsystem.entity.QualityDispute;
import com.example.erpsystem.mapper.QualityDisputeMapper;
import com.example.erpsystem.mapper.SalesOrderMapper;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.servlet.http.HttpServletRequest;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class QualityDisputeServiceImpl implements QualityDisputeService {

    @Autowired private QualityDisputeMapper disputeMapper;
    @Autowired private SalesOrderMapper salesOrderMapper; // 用于减免应收
    @Autowired private SupplierService supplierService;   // 用于扣减应付（按你实际 Mapper 注入）

    @Override
    public Result<?> page(Map<String, Object> params) {
        Long companyId = (Long) params.get("companyId");
        int pageNum = (Integer) params.getOrDefault("pageNum", 1);
        int pageSize = (Integer) params.getOrDefault("pageSize", 10);
        PageHelper.startPage(pageNum, pageSize);
        List<QualityDispute> list = disputeMapper.selectList(
                companyId, (Integer) params.get("disputeType"), (Integer) params.get("status"), null, null);
        return Result.success(new PageInfo<>(list));
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result<?> create(QualityDispute dispute, HttpServletRequest request) {
        Long companyId = (Long) request.getAttribute("companyId");
        dispute.setCompanyId(companyId);
        dispute.setStatus(0); // 待处理
        disputeMapper.insert(dispute);
        return Result.success("异议登记成功");
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result<?> handle(Long id, QualityDispute form) {
        QualityDispute dispute = disputeMapper.selectById(id);
        if (dispute == null) return Result.error(404, "异议单不存在");
        dispute.setHandleMethod(form.getHandleMethod());
        dispute.setStatus(1); // 已处理
        dispute.setHandlerId(form.getHandlerId());

        // ===== 自动联动财务（带明细说明）=====
        if (dispute.getDisputeType() == 1) {
            // 采购侧：扣减应付
            dispute.setAdjustType("扣减应付");
            dispute.setAdjustedAmount(form.getClaimAmount());
            dispute.setAdjustedBillNo("AP-" + dispute.getSupplierId()); // 关联应付账单
            dispute.setAdjustRemark("来料质量异议，扣减供应商[" + dispute.getSupplierId() + "]应付："
                    + form.getClaimAmount() + "，原因：" + form.getHandleMethod());
            // 实际扣减应付（示例：更新供应商对账余额，按你实际账务表调整）
            supplierService.deductPayable(dispute.getSupplierId(), form.getClaimAmount(), dispute.getDisputeNo());
        } else {
            // 销售侧：减免应收
            dispute.setAdjustType("减免应收");
            dispute.setAdjustedAmount(form.getClaimAmount());
            dispute.setAdjustedBillNo("AR-" + dispute.getOrderId()); // 关联应收账单(销售单)
            dispute.setAdjustRemark("客户质量投诉，减免客户[" + dispute.getCustomerId() + "]应收："
                    + form.getClaimAmount() + "，原因：" + form.getHandleMethod());
            // 实际减免应收：在销售订单/应收台账上冲减
            salesOrderMapper.adjustReceivable(dispute.getOrderId(), form.getClaimAmount().negate());
        }
        dispute.setFinanceAdjusted(1);
        disputeMapper.updateById(dispute);
        return Result.success("处理完成并已联动财务");
    }
}
