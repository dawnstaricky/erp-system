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
@RequestMapping("/contract/sales")
public class SalesContractController {

    @Autowired private SalesContractService contractService;

    @GetMapping("/list") public Result<PageInfo<SalesContract>> list(SalesContract q, @RequestParam int pageNum, @RequestParam int pageSize){ return Result.success(contractService.page(q, pageNum, pageSize)); }
    @GetMapping("/{id}") public Result<SalesContract> get(@PathVariable Long id){ return Result.success(contractService.getById(id)); }
    /** 人工点"生成合同"：基于销售订单套销售模板生成（含硬度/锡层/含税） */
    @PostMapping("/generate") public Result<Long> generate(@RequestBody ContractGenDTO dto){ return Result.success(contractService.generate(dto)); }
    @PostMapping("/void/{id}") public Result<Void> voidContract(@PathVariable Long id){ contractService.voidContract(id); return Result.success(); }
    @GetMapping("/download/{id}") public void download(@PathVariable Long id, HttpServletResponse response) throws Exception {
        contractService.download(id, response);
//        try {
//            contractService.download(id, response);
//        } catch (IOException e) {
//            throw new RuntimeException("文件下载失败", e);
//        }
    }

}
