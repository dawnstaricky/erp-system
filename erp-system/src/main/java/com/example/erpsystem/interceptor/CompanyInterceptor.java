package com.example.erpsystem.interceptor;

import com.example.erpsystem.context.CompanyContext;
import com.example.erpsystem.util.JwtUtil;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

/**
 * 多公司隔离拦截器：
 * 1) 从 JWT 解析当前用户角色，判断是否为管理员；
 * 2) 从请求头 X-Company-Id（前端 CompanySwitcher 切换后写入）读取当前公司；
 * 3) 写入 CompanyContext（ThreadLocal），供后续 Mapper/Service 使用；
 * 4) 业务接口要求非管理员必须已选公司，否则返回 400。
 */
@Component
public class CompanyInterceptor implements HandlerInterceptor {

    @Autowired
    private JwtUtil jwtUtil;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        String uri = request.getRequestURI();
        String companyHeader = request.getHeader("X-Company-Id");
        String authHeader = request.getHeader("Authorization");

        // ===== 关键日志：CompanyInterceptor 开始 =====
        System.out.println("\n===== CompanyInterceptor =====");
        System.out.println("Request URI: " + uri);
        System.out.println("X-Company-Id Header: " + companyHeader);
        System.out.println("Authorization Header: " + authHeader);
        // =========================================

        // 优先从请求头取公司ID（前端切换后透传）
        Long companyId = parseCompanyId(request.getHeader("X-Company-Id"));
        // 再从 JWT 解析角色，判断是否管理员
        String token = request.getHeader(jwtUtil.getHeader());
        if (token != null && token.startsWith("Bearer ")) token = token.substring(7);
        boolean isAdmin = false;
        if (token != null && !token.isEmpty() && jwtUtil.validateToken(token)) {
            try {
                Object roles = jwtUtil.getRolesFromToken(token);
                if (roles instanceof java.util.List) {
                    isAdmin = ((java.util.List<?>) roles).contains("ADMIN");
                }
            } catch (Exception ignored) {}
        }

        CompanyContext.setAdmin(isAdmin);
        CompanyContext.setCompanyId(companyId); // 管理员可为 null

        // 非管理员访问业务接口必须已选公司（登录/系统管理接口除外，由白名单放行）
        if (!isAdmin && companyId == null && !isExcluded(request.getRequestURI())) {
            System.out.println("CompanyInterceptor: Non-admin, no companyId, URI not excluded. Write 400.\n");
            writeNoCompany(response);
            return false;
        }
        System.out.println("CompanyInterceptor: Passed. isAdmin=" + isAdmin + ", companyId=" + companyId + "\n");
        return true;
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) {
        CompanyContext.clear();
    }

    private Long parseCompanyId(String v) {
        if (v == null || v.isEmpty()) return null;
        try { Long id = Long.parseLong(v); return id > 0 ? id : null; } catch (NumberFormatException e) { return null; }
    }

    /** 登录、系统管理类接口不强制公司，其余业务接口强制 */
    private boolean isExcluded(String uri) {
        return uri == null || uri.startsWith("/login") || uri.startsWith("/user/") || uri.startsWith("/sys/")
                || uri.startsWith("/permission") || uri.startsWith("/role") || uri.startsWith("/operation-log")
                || uri.startsWith("/dashboard")   // 新增：仪表盘
                || uri.startsWith("/report")
                || uri.equals("/") || uri.startsWith("/error");
    }

    private void writeNoCompany(HttpServletResponse response) throws java.io.IOException {
        response.setStatus(400);
        response.setContentType(MediaType.APPLICATION_JSON_VALUE);
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("{\"code\":400,\"msg\":\"请先在左上角选择公司\",\"data\":null}");
    }
}
