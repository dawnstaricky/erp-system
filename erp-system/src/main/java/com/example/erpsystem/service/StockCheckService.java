package com.example.erpsystem.service;

import com.example.erpsystem.entity.Inventory;
import com.example.erpsystem.entity.StockCheck;
import com.example.erpsystem.mapper.InventoryMapper;
import com.example.erpsystem.mapper.StockCheckMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Service
public class StockCheckService {

    @Autowired
    private StockCheckMapper stockCheckMapper;
    @Autowired
    private InventoryMapper inventoryMapper;

    // 创建盘点单（自动填入账面数量）
    public Long createCheck(StockCheck check) {
        String checkNo = stockCheckMapper.generateCheckNo();
        check.setCheckNo(checkNo);
        // 查询当前账面库存
        Inventory inv = inventoryMapper.selectByProductAndWarehouse(
                check.getProductId(), check.getWarehouseId());

        if (inv != null) {
            check.setBookQuantity(inv.getQuantity());
        } else {
            check.setBookQuantity(0);
        }

        // 计算差异
        if (check.getActualQuantity() != null && check.getBookQuantity() != null) {
            check.setDifference(check.getActualQuantity() - check.getBookQuantity());
        }

        check.setStatus(0);  // 草稿
        stockCheckMapper.insert(check);
        return check.getId();
    }

    // 审核通过（调整库存）
    @Transactional(rollbackFor = Exception.class)
    public void approve(Long checkId) {
        StockCheck check = stockCheckMapper.selectById(checkId);
        if (check == null) throw new RuntimeException("盘点单不存在");
        if (check.getStatus() != 0) throw new RuntimeException("只有草稿状态的盘点单才能审核");

        if (check.getActualQuantity() != null && check.getBookQuantity() != null) {
            check.setDifference(check.getActualQuantity() - check.getBookQuantity());
        }

        // 调整库存数量
        stockCheckMapper.approve(check);

        // 更新盘点单状态
        check.setStatus(1);
        stockCheckMapper.update(check);
    }

    public List<StockCheck> getList(Long warehouseId, String keyword) {
        return stockCheckMapper.getList(warehouseId, keyword);
    }
}