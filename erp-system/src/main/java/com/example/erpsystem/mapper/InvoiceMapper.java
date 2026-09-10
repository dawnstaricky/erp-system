package com.example.erpsystem.mapper;

import com.example.erpsystem.entity.Invoice;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface InvoiceMapper {
    int insert(Invoice invoice);
    int updateById(Invoice invoice);
    Invoice selectById(@Param("id") Long id);
    List<Invoice> selectList(@Param("companyId") Long companyId,
                             @Param("customerId") Long customerId,
                             @Param("orderId") Long orderId,
                             @Param("status") Integer status,
                             @Param("offset") Integer offset,
                             @Param("limit") Integer limit);
    Long countList(@Param("companyId") Long companyId,
                   @Param("customerId") Long customerId,
                   @Param("orderId") Long orderId,
                   @Param("status") Integer status);

    /** 某订单已开票总额（用于超额校验，仅统计正常发票） */
    BigDecimal sumAmountByOrder(@Param("orderId") Long orderId);

    /** 某客户未开票金额汇总（台账） */
    BigDecimal sumUninvoicedByCustomer(@Param("companyId") Long companyId, @Param("customerId") Long customerId);
}
