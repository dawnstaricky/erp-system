package com.example.erpsystem.interceptor;

import com.example.erpsystem.util.JwtUtil;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import java.util.List;

@Component
public class JwtInterceptor implements HandlerInterceptor {

    @Autowired
    private JwtUtil jwtUtil;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        String uri = request.getRequestURI();

        // 从请求头获取Token
        String token = request.getHeader(jwtUtil.getHeader());

        // ===== 关键日志：JwtInterceptor 开始 =====
        System.out.println("\n===== JwtInterceptor =====");
        System.out.println("Request URI: " + uri);
        System.out.println("Authorization Header: " + token);
        System.out.println("Method: " + request.getMethod());
        // ================================

        if (uri.startsWith("/api/login")) {
            System.out.println("JwtInterceptor: URI matched exclude list, return TRUE.\n");
            //return true;
        }

        // 如果Token是以"Bearer "开头，去掉前缀
        if (token != null && token.startsWith("Bearer ")) {
            token = token.substring(7);
        }

        // 如果没有Token，返回401
        if (token == null || token.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"code\":401,\"msg\":\"未登录或Token已失效\",\"data\":null}");
            return false;
        }

        // 验证Token
        if (!jwtUtil.validateToken(token)) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"code\":401,\"msg\":\"Token无效或已过期\",\"data\":null}");
            return false;
        }

        // Token验证通过，把用户信息存到request中，供后续Controller使用
        String username = jwtUtil.getUsernameFromToken(token);
        request.setAttribute("username", username);

        // 如果能解析出userId也写上
        try {
            Long userId = jwtUtil.getUserIdFromToken(token); // 需要在JwtUtil里加这个方法
            request.setAttribute("userId", userId);
        } catch (Exception ignored) {}

        // 【关键】获取角色列表并放入 Request
        List<String> roles = jwtUtil.getRolesFromToken(token);
        request.setAttribute("roles", roles);

        System.out.println("JwtInterceptor: Token validated successfully, set attributes, return TRUE.\n");
        return true;  // 放行
    }
}