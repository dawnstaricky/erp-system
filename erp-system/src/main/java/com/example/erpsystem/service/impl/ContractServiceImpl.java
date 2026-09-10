package com.example.erpsystem.service.impl;

import com.alibaba.excel.EasyExcel;
import com.alibaba.excel.write.style.column.SimpleColumnWidthStyleStrategy;
import com.example.erpsystem.common.Result;
import com.example.erpsystem.entity.*;
import com.example.erpsystem.mapper.*;
import com.example.erpsystem.util.ContractNoGenerator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayOutputStream;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.time.LocalDate;
import java.util.List;

/**
 * 合同自动化：
 * - 采购按采购合同模板生成、销售按销售合同模板生成
 * - 人工点"生成合同" → 套模板填充 → 导出 .xlsx 下载
 */
@Service
public class ContractServiceImpl implements ContractService {

    @Autowired private ContractNoGenerator noGenerator;
    @Autowired private SysCompanyMapper companyMapper;
    @Autowired private PurchaseOrderMapper purchaseOrderMapper;
    @Autowired private SalesOrderMapper salesOrderMapper;
    @Autowired private SupplierMapper supplierMapper;
    @Autowired private CustomerMapper customerMapper;
    @Autowired private PurchaseContractMapper purchaseContractMapper;
    @Autowired private SalesContractMapper salesContractMapper;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result<?> generatePurchase(Long orderId, HttpServletResponse response) {
        PurchaseOrder order = purchaseOrderMapper.selectById(orderId);
        if (order == null) return Result.error(404, "采购订单不存在");

        SysCompany company = companyMapper.selectById(order.getCompanyId());
        String prefix = (company != null && company.getContractPrefix() != null)
                ? company.getContractPrefix() : "XL-XZL";

        PurchaseContract contract = new PurchaseContract();
        contract.setContractNo(noGenerator.generate(order.getCompanyId(), prefix));
        contract.setCompanyId(order.getCompanyId());
        contract.setSupplierId(order.getSupplierId());
        contract.setOrderId(orderId);
        contract.setSignDate(LocalDate.now());
        contract.setTotalAmount(order.getTotalAmount());
        contract.setTaxRate(order.getTaxRate());
        contract.setTaxAmount(order.getTotalAmount().multiply(order.getTaxRate()).divide(new BigDecimal(100)));
        contract.setIsTaxIncluded(order.getIsTaxIncluded());
        contract.setDeliveryMethod(order.getDeliveryMethod());
        contract.setStatus(0); // 草稿

        // 明细：从采购订单明细转换
        List<PurchaseContractItem> items = convertPurchaseItems(orderId);
        contract.setItems(items);
        purchaseContractMapper.insert(contract);
        items.forEach(it -> { it.setContractId(contract.getId()); purchaseContractMapper.insertItem(it); });

        return exportPurchaseXlsx(contract, response);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result<?> generateSales(Long orderId, HttpServletResponse response) {
        SalesOrder order = salesOrderMapper.selectById(orderId);
        if (order == null) return Result.error(404, "销售订单不存在");

        SysCompany company = companyMapper.selectById(order.getCompanyId());
        String prefix = (company != null && company.getContractPrefix() != null)
                ? company.getContractPrefix() : "SS";

        SalesContract contract = new SalesContract();
        contract.setContractNo(noGenerator.generate(order.getCompanyId(), prefix));
        contract.setCompanyId(order.getCompanyId());
        contract.setCustomerId(order.getCustomerId());
        contract.setOrderId(orderId);
        contract.setSignDate(LocalDate.now());
        contract.setTotalAmount(order.getTotalAmount());
        contract.setTaxRate(order.getTaxRate());
        contract.setTaxAmount(order.getTotalAmount().multiply(order.getTaxRate()).divide(new BigDecimal(100)));
        contract.setIsTaxIncluded(order.getIsTaxIncluded());
        contract.setDeliveryMethod(order.getDeliveryMethod());
        contract.setStatus(0);

        List<SalesContractItem> items = convertSalesItems(orderId);
        contract.setItems(items);
        salesContractMapper.insert(contract);
        items.forEach(it -> { it.setContractId(contract.getId()); salesContractMapper.insertItem(it); });

        return exportSalesXlsx(contract, response);
    }

    /** 导出采购合同 .xlsx（套采购模板结构） */
    private Result<?> exportPurchaseXlsx(PurchaseContract contract, HttpServletResponse response) {
        try {
            ByteArrayOutputStream bos = new ByteArrayOutputStream();
            // 使用 EasyExcel 写模板（模板字段见 PurchaseContractTemplateVO）
            EasyExcel.write(bos, PurchaseContractTemplateVO.class)
                    .registerWriteHandler(new SimpleColumnWidthStyleStrategy())
                    .sheet("采购合同")
                    .doWrite(buildPurchaseRows(contract));
            writeResponse(response, bos, contract.getContractNo() + ".xlsx");
            return Result.success("生成成功");
        } catch (Exception e) {
            return Result.error(500, "导出失败：" + e.getMessage());
        }
    }

    /** 导出销售合同 .xlsx（套销售模板结构） */
    private Result<?> exportSalesXlsx(SalesContract contract, HttpServletResponse response) {
        try {
            ByteArrayOutputStream bos = new ByteArrayOutputStream();
            EasyExcel.write(bos, SalesContractTemplateVO.class)
                    .sheet("销售合同")
                    .doWrite(buildSalesRows(contract));
            writeResponse(response, bos, contract.getContractNo() + ".xlsx");
            return Result.success("生成成功");
        } catch (Exception e) {
            return Result.error(500, "导出失败：" + e.getMessage());
        }
    }

    private void writeResponse(HttpServletResponse response, ByteArrayOutputStream bos, String fileName) throws Exception {
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setCharacterEncoding("utf-8");
        response.setHeader("Content-Disposition",
                "attachment;filename=" + URLEncoder.encode(fileName, "UTF-8"));
        response.getOutputStream().write(bos.toByteArray());
        response.getOutputStream().flush();
    }

    // ===== 以下 convert/build 方法由具体模板字段实现（此处为骨架，按两份合同模板补齐） =====
    private List<PurchaseContractItem> convertPurchaseItems(Long orderId) { return null; }
    private List<SalesContractItem> convertSalesItems(Long orderId) { return null; }
    private List<?> buildPurchaseRows(PurchaseContract c) { return null; }
    private List<?> buildSalesRows(SalesContract c) { return null; }
}
