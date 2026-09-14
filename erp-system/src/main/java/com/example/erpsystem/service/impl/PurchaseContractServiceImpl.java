package com.example.erpsystem.service.impl;
import com.alibaba.excel.EasyExcel;
import com.example.erpsystem.dto.ContractGenDTO;
import com.example.erpsystem.entity.PurchaseContract;
import com.example.erpsystem.entity.PurchaseContractItem;
import com.example.erpsystem.entity.PurchaseOrder;
import com.example.erpsystem.entity.PurchaseOrderItem;
import com.example.erpsystem.entity.Product;
import com.example.erpsystem.mapper.ProductMapper;
import com.example.erpsystem.mapper.PurchaseContractMapper;
import com.example.erpsystem.mapper.PurchaseContractItemMapper;
import com.example.erpsystem.mapper.PurchaseOrderMapper;
import com.example.erpsystem.service.PurchaseContractService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

@Service
public class PurchaseContractServiceImpl implements PurchaseContractService {
    @Autowired private PurchaseContractMapper contractMapper;
    @Autowired private PurchaseContractItemMapper itemMapper;
    @Autowired private PurchaseOrderMapper orderMapper;
    @Autowired private ProductMapper productMapper;

    public PageInfo<PurchaseContract> page(PurchaseContract q, int pn, int ps){
        PageHelper.startPage(pn,ps); //return new PageInfo<>(contractMapper.selectList(q));
        List<PurchaseContract> list = contractMapper.selectList(
                q.getCompanyId(),
                q.getOrderId(),
                q.getContractNo(),
                q.getStatus(),
                pn,
                ps
        );
        return new PageInfo<>(list);
    }
    public PurchaseContract getById(Long id){
        PurchaseContract c = contractMapper.selectById(id);
        if(c!=null) c.setItems(itemMapper.selectByContractId(id));
        return c;
    }

    @Transactional public Long generate(ContractGenDTO dto){
        if(dto.getOrderId()==null) throw new RuntimeException("生成合同必须关联采购订单");
        PurchaseOrder order = orderMapper.selectOrderById(dto.getOrderId());
        if(order==null) throw new RuntimeException("采购订单不存在");
        PurchaseContract c = new PurchaseContract();
        c.setContractNo(buildNo(dto.getPrefix()));
        c.setCompanyId(dto.getCompanyId());
        c.setSupplierId(order.getSupplierId());
        c.setOrderId(order.getId());
        c.setSignDate(LocalDate.now());
        c.setTotalAmount(order.getTotalAmount() != null ? order.getTotalAmount() : BigDecimal.ZERO);
        c.setTaxRate(new BigDecimal("13"));
        c.setTaxAmount(c.getTotalAmount().multiply(new BigDecimal("0.13")));
        c.setIsTaxIncluded(0); // 采购合同默认不含税（按采购合同模板）
        c.setDeliveryMethod(dto.getDeliveryMethod());
        c.setPaymentTerms(dto.getPaymentTerms());
        c.setDeliveryPeriod(dto.getDeliveryPeriod());
        c.setStatus(0); // 草稿
        contractMapper.insert(c);

        // 从采购订单明细回填合同明细（品名/材质/规格/产地/卷号/硬度/锡层）
        List<PurchaseOrderItem> src = orderMapper.selectItemsByOrderId(order.getId());
        if(src != null && !src.isEmpty()){
            itemMapper.insertBatch(convert(src, c.getId()));
        }
        return c.getId();
    }

    @Transactional public void voidContract(Long id){ contractMapper.updateStatus(id, 2); }

    /** 采购明细 -> 合同明细：通过商品档案补全品名/材质/规格/产地/硬度/锡层/卷号等钢材字段 */
    private List<PurchaseContractItem> convert(List<PurchaseOrderItem> src, Long contractId){
        List<PurchaseContractItem> out = new ArrayList<>(src.size());
        for(PurchaseOrderItem it : src){
            PurchaseContractItem e = new PurchaseContractItem();
            e.setContractId(contractId);
            e.setProductId(it.getProductId());
            e.setQuantity(it.getQuantity());
            e.setUnitPrice(it.getPrice());
            e.setAmount(it.getAmount());
            // 从商品档案取钢材贸易字段（明细表只存 productId）
            if(it.getProductId() != null){
                Product p = productMapper.selectById(it.getProductId());
                if(p != null){
                    e.setProductName(p.getProductName());
                    e.setMaterial(p.getSpec());        // 材质取自商品规格
                    e.setSpec(p.getSpec());
                    e.setOrigin(p.getStorageLocation()); // 产地暂用存放地占位，可按实际字段调整
                    e.setHardness(p.getHardness());
                    e.setTinLayer(p.getTinLayer());
                    e.setCoilNo(p.getCoilNo());
                }
            }
            out.add(e);
        }
        return out;
    }

    private String buildNo(String prefix){
        String p = (prefix == null || prefix.isEmpty()) ? "XL-XZL" : prefix;
        return p + "-" + LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"))
                + "-" + System.currentTimeMillis() % 10000;
    }


    @Override
    public void download(Long id, HttpServletResponse response) throws Exception {
        PurchaseContract contract = contractMapper.selectById(id);
        if (contract == null) {
            throw new RuntimeException("采购合同不存在");
        }

        List<PurchaseContractItem> items = itemMapper.selectByContractId(id);

        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setCharacterEncoding("UTF-8");
        String fileName = URLEncoder.encode(contract.getContractNo() + "-采购合同.xlsx", StandardCharsets.UTF_8.name());
        response.setHeader("Content-Disposition", "attachment;filename=" + fileName);

        // 写入单个Sheet（明细）
        EasyExcel.write(response.getOutputStream(), PurchaseContractItem.class)
                .sheet("采购合同明细")
                .doWrite(items);
    }

}
