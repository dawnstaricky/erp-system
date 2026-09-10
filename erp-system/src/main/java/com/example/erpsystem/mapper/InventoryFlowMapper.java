package com.example.erpsystem.mapper;

import com.example.erpsystem.dto.InventoryFlowExportDTO;
import com.example.erpsystem.entity.InventoryFlow;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDateTime;
import java.util.List;

@Mapper
public interface InventoryFlowMapper {
    int insert(InventoryFlow flow);
    List<InventoryFlow> getFlowList(Long productId, Long warehouseId);

    List<InventoryFlowExportDTO> getFlowForExport(@Param("startTime") LocalDateTime startTime,
                                                  @Param("endTime") LocalDateTime endTime,
                                                  @Param("productId") Long productId,
                                                  @Param("warehouseId") Long warehouseId);
}