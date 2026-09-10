package com.example.erpsystem.mapper;

import com.example.erpsystem.entity.QualityDispute;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface QualityDisputeMapper {
    int insert(QualityDispute dispute);
    int updateById(QualityDispute dispute);
    QualityDispute selectById(@Param("id") Long id);
    List<QualityDispute> selectList(@Param("companyId") Long companyId,
                                    @Param("disputeType") Integer disputeType,
                                    @Param("status") Integer status,
                                    @Param("offset") Integer offset,
                                    @Param("limit") Integer limit);
    Long countList(@Param("companyId") Long companyId,
                   @Param("disputeType") Integer disputeType,
                   @Param("status") Integer status);
}
