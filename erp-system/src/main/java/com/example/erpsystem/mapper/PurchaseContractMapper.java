package com.example.erpsystem.mapper;

import com.example.erpsystem.entity.PurchaseContract;
import com.example.erpsystem.entity.PurchaseContractItem;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface PurchaseContractMapper {

    int insert(PurchaseContract contract);

    int updateById(PurchaseContract contract);

    PurchaseContract selectById(@Param("id") Long id);

    List<PurchaseContract> selectList(@Param("companyId") Long companyId,
                                      @Param("orderId") Long orderId,
                                      @Param("contractNo") String contractNo,
                                      @Param("status") Integer status,
                                      @Param("offset") int offset,
                                      @Param("limit") int limit);

    Long countList(@Param("companyId") Long companyId,
                   @Param("supplierId") Long supplierId,
                   @Param("orderId") Long orderId,
                   @Param("status") Integer status);

    int insertItem(PurchaseContractItem item);

    List<PurchaseContractItem> selectItemsByContractId(@Param("contractId") Long contractId);

    /** 按订单ID查合同（生成即下载场景） */
    //@Select("SELECT * FROM purchase_contract WHERE order_id = #{orderId} ORDER BY id DESC LIMIT 1")
    PurchaseContract selectByOrderId(@Param("orderId") Long orderId);
    int updateStatus(@Param("id") Long id, @Param("status") Integer status);
}
