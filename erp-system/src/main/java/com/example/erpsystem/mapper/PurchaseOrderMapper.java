package com.example.erpsystem.mapper;

import com.example.erpsystem.dto.PurchaseExportDTO;
import com.example.erpsystem.dto.PurchaseOrderDTO;
import com.example.erpsystem.dto.PurchaseOrderItemDTO;
import com.example.erpsystem.entity.PurchaseOrder;
import com.example.erpsystem.entity.PurchaseOrderItem;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.time.LocalDate;
import java.util.List;

@Mapper
public interface PurchaseOrderMapper {
    // 订单头
    int insertOrder(PurchaseOrder order);
    int updateOrder(PurchaseOrder order);
    PurchaseOrder selectOrderById(Long id);
    String generateOrderNo();

    // 订单明细
    int insertItems(List<PurchaseOrderItem> items);
    List<PurchaseOrderItem> selectItemsByOrderId(Long orderId);
    int deleteItemsByOrderId(Long orderId);

    List<PurchaseExportDTO> getPurchaseForExport(@Param("startDate") LocalDate startDate,
                                                 @Param("endDate") LocalDate endDate,
                                                 @Param("supplierId") Long supplierId,
                                                 @Param("warehouseId") Long warehouseId);

    @Select("SELECT * FROM purchase_order WHERE purchaser_id = #{purchaserId} AND status = 0 ORDER BY created_at DESC")
    List<PurchaseOrder> selectDraftsByPurchaser(Long purchaserId);

    public List<PurchaseOrder> selectList(@Param("orderNo") String orderNo,
                                          @Param("offset") int offset,
                                          @Param("pageSize") int pageSize) ;

    public int selectCount(String orderNo);

    PurchaseOrderDTO selectById(Long id);
    List<PurchaseOrderItemDTO> selectItemsDTOByOrderId(Long orderId);
}