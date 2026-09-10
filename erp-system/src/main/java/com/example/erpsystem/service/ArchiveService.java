package com.example.erpsystem.service;

/**
 * 归档服务（供 Invoice/Receipt/出库等事件调用）
 */
public interface ArchiveService {
    void checkAndArchive(Long salesOrderId);
}
