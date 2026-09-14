package com.example.erpsystem.mapper;

import com.example.erpsystem.entity.*;
import org.apache.ibatis.annotations.*;
import java.util.List;

@Mapper
public interface SalesContractMapper {

    List<SalesContract> selectList(SalesContract q);
    SalesContract selectById(@Param("id") Long id);
    SalesContract selectByOrderId(@Param("orderId") Long orderId);
    int insert(SalesContract c);
    int updateStatus(@Param("id") Long id, @Param("status") Integer status);

}
