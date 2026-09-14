package com.example.erpsystem.service;
import com.example.erpsystem.entity.SalesContract;
import com.example.erpsystem.dto.ContractGenDTO;
import com.github.pagehelper.PageInfo;
import jakarta.servlet.http.HttpServletResponse;

public interface SalesContractService {
    PageInfo<SalesContract> page(SalesContract q, int pageNum, int pageSize);
    SalesContract getById(Long id);
    /** 基于销售订单人工生成合同，套销售模板 -> 返回可下载的 Excel */
    Long generate(ContractGenDTO dto);
    void voidContract(Long id);
    void download(Long id, HttpServletResponse response) throws Exception;
}
