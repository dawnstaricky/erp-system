package com.example.erpsystem.service;
import com.example.erpsystem.common.Result;
import com.example.erpsystem.entity.QualityDispute;
import java.util.Map;
public interface QualityDisputeService {
    Result<?> page(Map<String, Object> params);
    Result<?> create(QualityDispute dispute, HttpServletRequest request);
    Result<?> handle(Long id, QualityDispute form);
}
