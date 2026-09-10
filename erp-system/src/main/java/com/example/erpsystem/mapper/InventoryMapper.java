package com.example.erpsystem.mapper;

import com.example.erpsystem.entity.Inventory;
import com.example.erpsystem.entity.InventoryVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Update;
import java.math.BigDecimal;
import java.util.List;

@Mapper
public interface InventoryMapper {
    Inventory selectByProductAndWarehouse(Long productId, Long warehouseId);
    int insert(Inventory inventory);

    // 乐观锁：扣减库存时校验版本
    @Update("""
        UPDATE inventory 
        SET quantity = quantity - #{count}, updated_at = CURRENT_TIMESTAMP
        WHERE product_id = #{productId} AND warehouse_id = #{warehouseId} AND quantity >= #{count}
    """)
    int decreaseStock(Long productId, Long warehouseId, Integer count);

    // 增加库存
    @Update("""
        UPDATE inventory 
        SET quantity = quantity + #{count}, cost_price = #{costPrice}, updated_at = CURRENT_TIMESTAMP
        WHERE product_id = #{productId} AND warehouse_id = #{warehouseId}
    """)
    int increaseStock(Long productId, Long warehouseId, Integer count, BigDecimal costPrice);

    //List<Inventory> getList(Long warehouseId, String keyword);
    //List<Inventory> getLowStockList(Long warehouseId);
    List<InventoryVO> getList(Long warehouseId, String keyword);
    List<InventoryVO> getLowStockList(Long warehouseId);
}