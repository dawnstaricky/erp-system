package com.example.erpsystem.mapper;

import com.example.erpsystem.entity.*;
import org.apache.ibatis.annotations.*;
import java.util.List;

@Mapper
public interface PurchaseContractItemMapper {

    int insertBatch(@Param("list") List<PurchaseContractItem> list);
    List<PurchaseContractItem> selectByContractId(@Param("contractId") Long contractId);

}
