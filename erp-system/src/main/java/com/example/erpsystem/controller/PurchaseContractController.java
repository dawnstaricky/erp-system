package com.example.erpsystem.controller;

import com.example.erpsystem.annotation.RequiresRoles;
import com.example.erpsystem.common.Result;
import com.example.erpsystem.entity.*;
import com.example.erpsystem.dto.ContractGenDTO;
import com.example.erpsystem.service.*;
import com.github.pagehelper.PageInfo;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.List;

@RestController
@RequestMapping("/contract/purchase")
public class PurchaseContractController {

    @Autowired private PurchaseContractService contractService;

    @GetMapping("/list") public Result<PageInfo<PurchaseContract>> list(PurchaseContract q, @RequestParam int pageNum, @RequestParam int pageSize){ return Result.success(contractService.page(q, pageNum, pageSize)); }
    @GetMapping("/{id}") public Result<PurchaseContract> get(@PathVariable Long id){ return Result.success(contractService.getById(id)); }
    /** 人工点"生成合同"：基于采购订单套采购模板生成，返回合同ID（前端再调下载） */
    @PostMapping("/generate") public Result<Long> generate(@RequestBody ContractGenDTO dto){ return Result.success(contractService.generate(dto)); }
    @PostMapping("/void/{id}") public Result<Void> voidContract(@PathVariable Long id){ contractService.voidContract(id); return Result.success(); }
    /** 下载合同 Excel（采购模板：品名/材质/规格/产地/数量/单价/金额/卷号 + 税额） */
    @GetMapping("/download/{id}") public void download(@PathVariable Long id, HttpServletResponse response) throws Exception {
        contractService.download(id, response);
    }

}
