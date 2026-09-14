package com.example.erpsystem.mapper;

import com.example.erpsystem.entity.*;
import org.apache.ibatis.annotations.*;

import java.math.BigDecimal;
import java.util.List;

@Mapper
public interface InvoiceMapper {

    List<Invoice> selectList(Invoice q);
    BigDecimal selectInvoicedAmountByOrderId(@Param("orderId") Long orderId);
    Invoice selectById(@Param("id") Long id);
    int insert(Invoice inv);
    int voidInvoice(@Param("id") Long id);

}
