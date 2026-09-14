package com.example.erpsystem.service;
import com.example.erpsystem.entity.PurchaseContract;
import com.example.erpsystem.dto.ContractGenDTO;
import com.github.pagehelper.PageInfo;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.web.servlet.view.document.AbstractXlsxView;

import java.io.IOException;

public interface PurchaseContractService {
    PageInfo<PurchaseContract> page(PurchaseContract q, int pageNum, int pageSize);
    PurchaseContract getById(Long id);
    /** 基于采购订单人工生成合同，套采购模板 -> 返回可下载的 Excel */
    Long generate(ContractGenDTO dto);
    void voidContract(Long id);
    void download(Long id, HttpServletResponse response) throws Exception;
}
