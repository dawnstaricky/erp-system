package com.example.erpsystem.mapper;

import com.example.erpsystem.entity.Receipt;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface ReceiptMapper {
    int insert(Receipt receipt);
    int updateById(Receipt receipt);
    Receipt selectById(@Param("id") Long id);
    List<Receipt> selectList(@Param("companyId") Long companyId,
                             @Param("customerId") Long customerId,
                             @Param("orderId") Long orderId,
                             @Param("offset") Integer offset,
                             @Param("limit") Integer limit);
    Long countList(@Param("companyId") Long companyId,
                   @Param("customerId") Long customerId,
                   @Param("orderId") Long orderId);

    /** 某订单已回款总额 */
    BigDecimal sumAmountByOrder(@Param("orderId") Long orderId);
}
