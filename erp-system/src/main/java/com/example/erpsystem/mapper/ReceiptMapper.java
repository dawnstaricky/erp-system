package com.example.erpsystem.mapper;

import com.example.erpsystem.entity.*;
import org.apache.ibatis.annotations.*;

import java.math.BigDecimal;
import java.util.List;

@Mapper
public interface ReceiptMapper {

    List<Receipt> selectList(Receipt q);
    BigDecimal selectReceivedAmountByOrderId(@Param("orderId") Long orderId);
    int insert(Receipt r);

}
