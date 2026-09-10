package com.example.erpsystem.service;

import com.example.erpsystem.dto.InventoryExportDTO;
import com.example.erpsystem.dto.InventoryFlowExportDTO;
import com.example.erpsystem.entity.Inventory;
import com.example.erpsystem.entity.InventoryVO;
import com.example.erpsystem.entity.InventoryFlow;
import com.example.erpsystem.mapper.InventoryMapper;
import com.example.erpsystem.mapper.InventoryFlowMapper;
import com.example.erpsystem.mapper.WarehouseMapper;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Service
public class InventoryService {

    @Autowired
    private InventoryMapper inventoryMapper;

    // 分页查询库存
    public PageInfo<InventoryVO> getList(int pageNum, int pageSize, Long warehouseId, String keyword) {
        PageHelper.startPage(pageNum, pageSize);
        List<InventoryVO> list = inventoryMapper.getList(warehouseId, keyword);
        return new PageInfo<>(list);
    }

    // 查询单个商品库存
    public Inventory getByProductAndWarehouse(Long productId, Long warehouseId) {
        return inventoryMapper.selectByProductAndWarehouse(productId, warehouseId);
    }

    // 库存预警（低于最低库存的商品）
    public List<InventoryVO> getLowStockList(Long warehouseId) {
        return inventoryMapper.getLowStockList(warehouseId);
    }

    @Autowired
    private InventoryFlowMapper inventoryFlowMapper;

    // 查询某个商品的库存流水
    public List<InventoryFlow> getFlowList(Long productId, Long warehouseId) {
        return inventoryFlowMapper.getFlowList(productId, warehouseId);
    }

    @Autowired
    private WarehouseMapper warehouseMapper;

    public List<InventoryExportDTO> getInventoryForExport(Long warehouseId) {
        List<InventoryVO> inventoryList = inventoryMapper.getList(warehouseId, null);
        List<InventoryExportDTO> exportList = new ArrayList<>();

        for (InventoryVO inv : inventoryList) {
            InventoryExportDTO dto = new InventoryExportDTO();
            dto.setWarehouseName(inv.getWarehouseId() != null ? "主仓库" : "");
            dto.setSkuCode(inv.getSkuCode());
            dto.setProductName(inv.getProductName());
            dto.setSpec(inv.getSpec());
            dto.setUnit(inv.getUnit());
            dto.setBookQuantity(inv.getQuantity());
            dto.setActualQuantity(inv.getQuantity());  //预填账面数量
            dto.setDifference(0);  // 默认无差异
            dto.setCostPrice(inv.getCostPrice());
            if (inv.getCostPrice() != null && inv.getQuantity() != null) {
                dto.setTotalAmount(inv.getCostPrice().multiply(BigDecimal.valueOf(inv.getQuantity())));
            }
            exportList.add(dto);
        }
        return exportList;
    }


    public List<InventoryFlowExportDTO> getFlowForExport(LocalDateTime startTime, LocalDateTime endTime,
                                                         Long productId, Long warehouseId) {
        return inventoryFlowMapper.getFlowForExport(startTime, endTime, productId, warehouseId);
    }
}