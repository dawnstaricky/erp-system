package com.example.erpsystem.mapper;

import com.example.erpsystem.entity.OperationLog;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface OperationLogMapper {
    int insert(OperationLog log);
    List<OperationLog> selectList(@Param("keyword") String keyword,
                                  @Param("module") String module,
                                  @Param("startDate") String startDate,
                                  @Param("endDate") String endDate,
                                  @Param("offset") int offset,
                                  @Param("pageSize") int pageSize);

    int count(@Param("keyword") String keyword,
              @Param("module") String module,
              @Param("startDate") String startDate,
              @Param("endDate") String endDate);
}