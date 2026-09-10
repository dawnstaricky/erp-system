package com.example.erpsystem.service.impl;

import com.example.erpsystem.common.Result;
import com.example.erpsystem.entity.Receipt;
import com.example.erpsystem.mapper.ReceiptMapper;
import com.example.erpsystem.mapper.SalesOrderMapper;
import com.example.erpsystem.service.ReceiptService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@Service
public class ReceiptServiceImpl implements ReceiptService {

    @Autowired private ReceiptMapper receiptMapper;
    @Autowired private SalesOrderMapper salesOrderMapper;

    @Override
    public Result<?> page(Map<String, Object> params) {
        Long companyId = (Long) params.get("companyId");
        int pageNum = (Integer) params.getOrDefault("pageNum", 1);
        int pageSize = (Integer) params.getOrDefault("pageSize", 10);
        PageHelper.startPage(pageNum, pageSize);
        List<Receipt> list = receiptMapper.selectList(
                companyId, (Long) params.get("customerId"), (Long) params.get("orderId"), null, null);
        return Result.success(new PageInfo<>(list));
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result<?> create(Receipt receipt) {
        // 杜绝无单回款：必须绑定订单
        if (receipt.getOrderId() == null) {
            return Result.error(400, "回款必须关联销售订单，不允许无单回款");
        }
        SalesOrder order = salesOrderMapper.selectById(receipt.getOrderId());
        if (order == null) return Result.error(400, "订单不存在");

        // 回款金额 <= 该订单未回款金额
        BigDecimal received = receiptMapper.sumAmountByOrder(receipt.getOrderId());
        BigDecimal unpaid = order.getTotalAmount().subtract(received);
        if (receipt.getAmount().compareTo(unpaid) > 0) {
            return Result.error(400, "回款金额超过订单未回款金额：" + unpaid);
        }

        receipt.setAllocatedAmount(receipt.getAmount());
        receipt.setUnallocatedAmount(BigDecimal.ZERO);
        receiptMapper.insert(receipt);

        // 同步更新销售订单的回款字段
        order.setPaidAmount(received.add(receipt.getAmount()));
        order.setUnpaidAmount(order.getTotalAmount().subtract(order.getPaidAmount()));
        salesOrderMapper.updateById(order);

        // 触发归档判定
        archiveService.checkAndArchive(order.getId());
        return Result.success("回款登记成功");
    }
}
