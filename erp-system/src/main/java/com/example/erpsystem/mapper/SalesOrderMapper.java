package com.example.erpsystem.mapper;

import com.example.erpsystem.dto.*;
import com.example.erpsystem.entity.PurchaseOrder;
import com.example.erpsystem.entity.SalesOrder;
import com.example.erpsystem.entity.SalesOrderItem;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.time.LocalDate;
import java.util.List;

@Mapper
public interface SalesOrderMapper {
    // 订单头
    int insertOrder(SalesOrder order);
    int updateOrder(SalesOrder order);
    SalesOrder selectOrderById(Long id);
    String generateOrderNo();

    // 订单明细
    int insertItems(List<SalesOrderItem> items);
    List<SalesOrderItem> selectItemsByOrderId(Long orderId);

    List<SalesExportDTO> getSalesForExport(@Param("startDate") LocalDate startDate,
                                           @Param("endDate") LocalDate endDate,
                                           @Param("customerId") Long customerId,
                                           @Param("warehouseId") Long warehouseId);

    @Select("SELECT * FROM sales_order WHERE salesman_id = #{salesmanId} AND status = 0 ORDER BY created_at DESC")
    List<SalesOrder> selectDraftsBySalesman(Long salesmanId);

    public List<SalesOrder> selectList(@Param("orderNo") String orderNo,
                                       @Param("offset") int offset,
                                       @Param("pageSize") int pageSize) ;

    public int selectCount(String orderNo);

    SalesOrderDTO selectById(Long id);
    List<SalesOrderItemDTO> selectItemsDTOByOrderId(Long orderId);
}