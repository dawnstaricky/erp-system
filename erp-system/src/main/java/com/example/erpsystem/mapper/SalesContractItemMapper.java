package com.example.erpsystem.mapper;

import com.example.erpsystem.entity.*;
import org.apache.ibatis.annotations.*;
import java.util.List;

@Mapper
public interface SalesContractItemMapper {

    int insertBatch(@Param("list") List<SalesContractItem> list);
    List<SalesContractItem> selectByContractId(@Param("contractId") Long contractId);

}
