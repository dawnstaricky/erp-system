package com.example.erpsystem.mapper;

import com.example.erpsystem.entity.StockCheck;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;

@Mapper
public interface StockCheckMapper {
    int insert(StockCheck check);
    int update(StockCheck check);
    StockCheck selectById(Long id);
    List<StockCheck> getList(Long warehouseId, String keyword);
    int approve(StockCheck check);  // 审核通过，调整库存
    String generateCheckNo();
}