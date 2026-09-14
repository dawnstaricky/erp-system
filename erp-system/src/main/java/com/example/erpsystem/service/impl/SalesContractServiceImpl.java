package com.example.erpsystem.service.impl;
import com.alibaba.excel.EasyExcel;
import com.example.erpsystem.dto.ContractGenDTO;
import com.example.erpsystem.entity.Product;
import com.example.erpsystem.entity.SalesContract;
import com.example.erpsystem.entity.SalesContractItem;
import com.example.erpsystem.entity.SalesOrder;
import com.example.erpsystem.entity.SalesOrderItem;
import com.example.erpsystem.mapper.ProductMapper;
import com.example.erpsystem.mapper.SalesContractMapper;
import com.example.erpsystem.mapper.SalesContractItemMapper;
import com.example.erpsystem.mapper.SalesOrderMapper;
import com.example.erpsystem.service.SalesContractService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

@Service
public class SalesContractServiceImpl implements SalesContractService {
    @Autowired private SalesContractMapper contractMapper;
    @Autowired private SalesContractItemMapper itemMapper;
    @Autowired private SalesOrderMapper orderMapper;
    @Autowired private ProductMapper productMapper;

    public PageInfo<SalesContract> page(SalesContract q, int pn, int ps){
        PageHelper.startPage(pn,ps); return new PageInfo<>(contractMapper.selectList(q));
    }
    public SalesContract getById(Long id){
        SalesContract c = contractMapper.selectById(id);
        if(c!=null) c.setItems(itemMapper.selectByContractId(id));
        return c;
    }

    @Transactional public Long generate(ContractGenDTO dto){
        if(dto.getOrderId()==null) throw new RuntimeException("生成合同必须关联销售订单");
        SalesOrder order = orderMapper.selectEntityById(dto.getOrderId());
        if(order==null) throw new RuntimeException("销售订单不存在");
        SalesContract c = new SalesContract();
        c.setContractNo((dto.getPrefix()==null?"SS":dto.getPrefix()) + "-" + LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"))
                + "-" + (System.currentTimeMillis() % 10000));
        c.setCompanyId(dto.getCompanyId());
        c.setCustomerId(order.getCustomerId());
        c.setOrderId(order.getId());
        c.setSignDate(LocalDate.now());
        c.setTotalAmount(order.getTotalAmount() != null ? order.getTotalAmount() : BigDecimal.ZERO);
        c.setTaxRate(new BigDecimal("13"));
        c.setTaxAmount(c.getTotalAmount().multiply(new BigDecimal("0.13")));
        c.setIsTaxIncluded(1); // 销售合同默认含税（按销售合同模板）
        c.setDeliveryMethod(dto.getDeliveryMethod());
        c.setPaymentTerms(dto.getPaymentTerms());
        c.setDeliveryPeriod(dto.getDeliveryPeriod());
        c.setStatus(0);
        contractMapper.insert(c);

        // 从销售订单明细回填合同明细（品名/规格/材质/硬度/锡层/厂家，查商品档案补全）
        List<SalesOrderItem> items = orderMapper.selectItemsByOrderId(order.getId());
        if(items != null && !items.isEmpty()){
            itemMapper.insertBatch(convert(items, c.getId()));
        }
        return c.getId();
    }

    @Transactional public void voidContract(Long id){ contractMapper.updateStatus(id, 2); }

    /** 销售明细 -> 销售合同明细：销售模板特有 硬度/锡层/厂家 字段，均取自商品档案 */
    private List<SalesContractItem> convert(List<SalesOrderItem> src, Long contractId){
        List<SalesContractItem> out = new ArrayList<>(src.size());
        for(SalesOrderItem it : src){
            SalesContractItem e = new SalesContractItem();
            e.setContractId(contractId);
            e.setProductId(it.getProductId());
            e.setQuantity(it.getQuantity());
            e.setUnitPrice(it.getPrice());
            e.setAmount(it.getAmount());
            if(it.getProductId() != null){
                Product p = productMapper.selectById(it.getProductId());
                if(p != null){
                    e.setProductName(p.getProductName());
                    e.setMaterial(p.getSpec());
                    e.setSpec(p.getSpec());
                    e.setHardness(p.getHardness());     // 硬度
                    e.setTinLayer(p.getTinLayer());     // 锡层
                    e.setSteelMill(p.getStorageLocation()); // 厂家（暂用存放地占位，可按实际字段调整）
                }
            }
            out.add(e);
        }
        return out;
    }


    @Override
    public void download(Long id, HttpServletResponse response) throws Exception {
        SalesContract contract = contractMapper.selectById(id);
        if (contract == null) {
            throw new RuntimeException("销售合同不存在");
        }

        List<SalesContractItem> items = itemMapper.selectByContractId(id);

        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setCharacterEncoding("UTF-8");
        String fileName = URLEncoder.encode(contract.getContractNo() + "-销售合同.xlsx", StandardCharsets.UTF_8.name());
        response.setHeader("Content-Disposition", "attachment;filename=" + fileName);

        // 写入单个Sheet（明细）
        EasyExcel.write(response.getOutputStream(), SalesContractItem.class)
                .sheet("销售合同明细")
                .doWrite(items);
    }
}
