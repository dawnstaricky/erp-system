package com.example.erpsystem.mapper;

import com.example.erpsystem.entity.*;
import org.apache.ibatis.annotations.*;
import java.util.List;

@Mapper
public interface QualityDisputeMapper {

    List<QualityDispute> selectList(QualityDispute q);
    QualityDispute selectById(@Param("id") Long id);
    int insert(QualityDispute d);
    int updateById(QualityDispute d);

}
