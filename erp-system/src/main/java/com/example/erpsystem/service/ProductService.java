package com.example.erpsystem.service;

import com.example.erpsystem.entity.Product;
import com.example.erpsystem.mapper.ProductMapper;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ProductService {

    @Autowired
    private ProductMapper productMapper;

    // 分页列表
    public PageInfo<Product> getList(int pageNum, int pageSize, String keyword) {
        PageHelper.startPage(pageNum, pageSize);
        List<Product> list = productMapper.getList(keyword);
        return new PageInfo<>(list);
    }

    // 新增
    public int add(Product product) {
        // 生成助记码（拼音首字母，这里先简单处理）
        if (product.getMnemonicCode() == null || product.getMnemonicCode().isEmpty()) {
            product.setMnemonicCode(generateMnemonic(product.getProductName()));
        }
        // 生成SKU编码
        if (product.getSkuCode() == null || product.getSkuCode().isEmpty()) {
            product.setSkuCode(generateSku());
        }
        return productMapper.insert(product);
    }

    // 更新
    public int update(Product product) {
        return productMapper.update(product);
    }

    // 根据ID查询
    public Product getById(Long id) {
        return productMapper.selectById(id);
    }

    // 停用（逻辑删除）
    public int delete(Long id) {
        return productMapper.deleteById(id);
    }

    // 简单助记码生成（取拼音首字母，这里偷懒用字符串截取模拟）
    private String generateMnemonic(String productName) {
        if (productName == null || productName.isEmpty()) return "";
        return productName.substring(0, Math.min(6, productName.length())).toUpperCase();
    }

    // 生成SKU编码
    private String generateSku() {
        return "SKU" + System.currentTimeMillis();
    }
}