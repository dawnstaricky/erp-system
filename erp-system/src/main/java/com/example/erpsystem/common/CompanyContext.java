package com.example.erpsystem.common;

import javax.servlet.http.HttpServletRequest;

/**
 * 多公司上下文工具：从请求头/Request 中获取当前选中公司
 * 前端在选择公司后，把 companyId 放进请求头 X-Company-Id
 */
public class CompanyContext {

    public static final String HEADER = "X-Company-Id";

    public static Long getCurrentCompanyId(HttpServletRequest request) {
        if (request == null) return null;
        String v = request.getHeader(HEADER);
        if (v == null) {
            Object obj = request.getAttribute(HEADER);
            v = obj == null ? null : obj.toString();
        }
        if (v == null || v.isEmpty()) return null;
        try { return Long.parseLong(v); } catch (NumberFormatException e) { return null; }
    }
}
