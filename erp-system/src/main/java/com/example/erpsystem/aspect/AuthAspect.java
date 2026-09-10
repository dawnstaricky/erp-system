package com.example.erpsystem.aspect;

import com.example.erpsystem.common.Result;
import com.example.erpsystem.mapper.PermissionMapper;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.http.HttpServletResponse;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import java.io.PrintWriter;
import java.lang.reflect.Method;
import java.util.List;

@Aspect
@Component
public class AuthAspect {
    @Autowired
    private PermissionMapper permissionMapper;

    @Around("@annotation(com.example.erpsystem.annotation.RequiresRoles)")
    public Object checkPermission(ProceedingJoinPoint joinPoint) throws Throwable {
        ServletRequestAttributes attributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        if (attributes == null) {
            return Result.error(401, "未登录");
        }

        // 获取当前请求的用户角色（从request attribute中取，JWT拦截器已存入）
        List<String> userRoles = (List<String>) attributes.getRequest().getAttribute("roles");
        if (userRoles == null || userRoles.isEmpty()) {
            return Result.error(401, "未登录");
        }

        // 获取当前请求的接口路径和方法
        String apiPath = attributes.getRequest().getRequestURI();
        String apiMethod = attributes.getRequest().getMethod();

        // 查询该接口所需的角色列表（从数据库查，实现动态配置）
        List<String> requiredRoles = permissionMapper.selectRolesByApi(apiPath, apiMethod);
        if (requiredRoles.isEmpty()) {
            // 接口未配置权限，默认放行（或根据需求改为拦截）
            return joinPoint.proceed();
        }

        // 校验用户角色是否包含任一所需角色
        boolean hasPermission = userRoles.stream().anyMatch(requiredRoles::contains);
        if (hasPermission) {
            return joinPoint.proceed();
        } else {
            HttpServletResponse response = attributes.getResponse();
            response.setStatus(403);
            response.setContentType("application/json;charset=UTF-8");
            PrintWriter writer = response.getWriter();
            writer.write(new ObjectMapper().writeValueAsString(Result.error(403, "无权限访问")));
            writer.flush();
            return null;
        }
    }
}