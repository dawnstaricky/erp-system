package com.example.erpsystem.service;

import com.example.erpsystem.entity.Warehouse;
import com.example.erpsystem.mapper.WarehouseMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Service
public class WarehouseService {

    @Autowired
    private WarehouseMapper warehouseMapper;

    /**
     * 分页查询仓库列表
     */
    public List<Warehouse> getList(String keyword, int pageNum, int pageSize) {
        int offset = (pageNum - 1) * pageSize;
        return warehouseMapper.selectList(keyword, offset, pageSize);
    }

    /**
     * 查询仓库总数
     */
    public int getCount(String keyword) {
        return warehouseMapper.count(keyword);
    }

    /**
     * 根据ID查询仓库
     */
    public Warehouse getById(Long id) {
        return warehouseMapper.selectById(id);
    }

    private static final DateTimeFormatter DATE_FMT = DateTimeFormatter.ofPattern("yyyyMMdd");

    /**
     * 自动生成仓库编码：WH + 日期 + 4位流水
     * 例：WH20260803-0001
     */
    private String generateWarehouseCode() {
        String datePart = LocalDate.now().format(DATE_FMT); // 20260803
        String prefix = "WH" + datePart + "-";

        // 查当天最大的流水号
        String maxCode = warehouseMapper.selectMaxCodeByPrefix(prefix + "%");
        int nextSeq = 1;
        if (maxCode != null && maxCode.length() >= prefix.length() + 4) {
            String seqPart = maxCode.substring(prefix.length());
            try {
                nextSeq = Integer.parseInt(seqPart) + 1;
            } catch (NumberFormatException ignored) {}
        }
        return prefix + String.format("%04d", nextSeq);
    }

    @Transactional(isolation = Isolation.READ_COMMITTED)
    public synchronized void addWarehouse(Warehouse warehouse) {
        int retry = 3;
        while (retry > 0) {
            try {
                if (warehouse.getWarehouseCode() == null || warehouse.getWarehouseCode().trim().isEmpty()) {
                    warehouse.setWarehouseCode(generateWarehouseCode());
                }
                if (warehouse.getWarehouseName() == null || warehouse.getWarehouseName().trim().isEmpty()) {
                    throw new RuntimeException("仓库名称不能为空");
                }
                if (warehouse.getStatus() == null) {
                    warehouse.setStatus(1);
                }
                warehouseMapper.insert(warehouse);
                return;
            } catch (DuplicateKeyException e) {
                retry--;
                if (retry == 0) {
                    throw new RuntimeException("仓库编码生成失败，请重试");
                }
                // 重试时重新生成
                warehouse.setWarehouseCode(null);
            }
        }
    }

    @Transactional
    public void addWarehouse2(Warehouse warehouse) {
        // 自动生成编码
        if (warehouse.getWarehouseCode() == null || warehouse.getWarehouseCode().trim().isEmpty()) {
            warehouse.setWarehouseCode(generateWarehouseCode());
        }
        // 非空校验
        if (warehouse.getWarehouseName() == null || warehouse.getWarehouseName().trim().isEmpty()) {
            throw new RuntimeException("仓库名称不能为空");
        }
        if (warehouse.getStatus() == null) {
            warehouse.setStatus(1);
        }
        warehouseMapper.insert(warehouse);
    }


    /**
     * 新增仓库（默认启用）
     */
    @Transactional
    public void addWarehouse1(Warehouse warehouse) {
        // 新增非空校验
        if (warehouse.getWarehouseCode() == null || warehouse.getWarehouseCode().trim().isEmpty()) {
            throw new RuntimeException("仓库编码不能为空");
        }
        if (warehouse.getWarehouseName() == null || warehouse.getWarehouseName().trim().isEmpty()) {
            throw new RuntimeException("仓库名称不能为空");
        }
        if (warehouse.getStatus() == null) {
            warehouse.setStatus(1); // 默认启用
        }
        warehouseMapper.insert(warehouse);
    }

    /**
     * 更新仓库（含停用）
     */
    @Transactional
    public void updateWarehouse(Warehouse warehouse) {
        warehouseMapper.updateById(warehouse);
    }

    /**
     * 停用仓库（软删除，和之前用户管理逻辑一致）
     */
    @Transactional
    public void disableWarehouse(Long id) {
        Warehouse warehouse = new Warehouse();
        warehouse.setId(id);
        warehouse.setStatus(0); // 0=停用
        warehouseMapper.updateById(warehouse);
    }

    /** 启用仓库（给前端“再启用”按钮用） */
    @Transactional
    public void enableWarehouse(Long id) {
        Warehouse w = new Warehouse();
        w.setId(id);
        w.setStatus(1);
        warehouseMapper.updateById(w);
    }
}