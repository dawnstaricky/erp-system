package com.example.erpsystem.mapper;

import com.example.erpsystem.entity.BusinessArchive;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface BusinessArchiveMapper {
    int insert(BusinessArchive archive);
    int updateById(BusinessArchive archive);
    BusinessArchive selectByOrder(@Param("orderId") Long orderId);
    int existsPurchaseStockIn(@Param("orderId") Long salesOrderId);
}
