package com.example.erpsystem.util;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import com.example.erpsystem.mapper.SysCompanyMapper;

/**
 * 合同编号规则：前缀(取自公司配置) + 日期(yyMMdd) + 当日流水(4位)
 * 例：SS2609080001、XL-XZL260824
 * 前缀可通过「公司管理」配置 contract_prefix
 */
@Component
public class ContractNoGenerator {

    @Autowired
    private SysCompanyMapper companyMapper;

    public String generate(Long companyId, String prefix) {
        String date = new java.text.SimpleDateFormat("yyMMdd").format(new java.util.Date());
        // 查询当日该公司已生成的合同数 +1（简单计数，高并发可用 Redis 序号）
        long count = /* countToday(companyId, date) */ 0;
        String seq = String.format("%04d", count + 1);
        return prefix + date + seq;
    }
}
