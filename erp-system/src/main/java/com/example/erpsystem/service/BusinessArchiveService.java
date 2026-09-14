package com.example.erpsystem.service;
import com.example.erpsystem.entity.BusinessArchive;
import com.github.pagehelper.PageInfo;
public interface BusinessArchiveService {
    PageInfo<BusinessArchive> page(BusinessArchive q, int pageNum, int pageSize);
    /** 刷新指定订单的归档状态（五环节判定），返回是否归档 */
    BusinessArchive refresh(Long companyId, Long orderId);
    /** 发票作废/回款撤销时调用：自动退出归档并记录原因 */
    void unarchive(Long companyId, Long orderId, String reason);
}
