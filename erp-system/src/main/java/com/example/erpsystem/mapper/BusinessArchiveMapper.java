package com.example.erpsystem.mapper;

import com.example.erpsystem.entity.*;
import org.apache.ibatis.annotations.*;
import java.util.List;

@Mapper
public interface BusinessArchiveMapper {

    BusinessArchive selectByOrderId(@Param("companyId") Long companyId, @Param("orderId") Long orderId);
    List<BusinessArchive> selectList(BusinessArchive q);
    int insert(BusinessArchive a);
    int updateById(BusinessArchive a);
    int archive(@Param("id") Long id);
    int unarchive(@Param("id") Long id, @Param("reason") String reason);

}
