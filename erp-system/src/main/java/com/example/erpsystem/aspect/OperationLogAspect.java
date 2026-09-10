package com.example.erpsystem.aspect;

import com.example.erpsystem.entity.OperationLog;
import com.example.erpsystem.mapper.OperationLogMapper;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.http.HttpServletRequest;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import java.time.LocalDateTime;
import java.util.Arrays;

@Aspect
@Component
public class OperationLogAspect {

    @Autowired
    private OperationLogMapper operationLogMapper;
    
    private static final ObjectMapper objectMapper = new ObjectMapper();

    @Pointcut("execution(* com.example.erpsystem.controller..*(..))")
    public void controllerPointcut() {}

    @Around("controllerPointcut()")
    public Object logOperation(ProceedingJoinPoint joinPoint) throws Throwable {
        ServletRequestAttributes attributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        if (attributes == null) {
            return joinPoint.proceed();
        }

        HttpServletRequest request = attributes.getRequest();
        String url = request.getRequestURI();
        String method = request.getMethod();
        String ipAddress = getClientIp(request);

        OperationLog log = new OperationLog();
        log.setModule(extractModule(url));
        log.setAction(extractAction(url, method));
        log.setMethod(method + " " + url);
        log.setIpAddress(ipAddress);
        log.setOperationTime(LocalDateTime.now());

        //从JWT拦截器写入的request属性中取真实用户名
        String username = (String) request.getAttribute("username");
        Long userId = (Long) request.getAttribute("userId");

        // 如果取不到，用"unknown"而不是"system"
        if (username == null) username = "unknown";
        if (userId == null) userId = 1L;
        log.setUserId(userId);
        log.setUsername(username);

        try {
            Object result = joinPoint.proceed();
            log.setStatus(1);
            log.setParams(buildParams(joinPoint));
            operationLogMapper.insert(log);
            return result;
        } catch (Throwable e) {
            log.setStatus(0);
            log.setErrorMsg(truncate(e.getMessage(), 500));
            log.setParams(buildParams(joinPoint));
            operationLogMapper.insert(log);
            throw e;
        }
    }

    private String buildParams(ProceedingJoinPoint joinPoint) {
        try {
            Object[] args = joinPoint.getArgs();
            if (args == null || args.length == 0) {
                return null;
            }
            String params = objectMapper.writeValueAsString(args);
            return truncate(params, 2000);
        } catch (Exception e) {
            return Arrays.toString(joinPoint.getArgs());
        }
    }

    private String extractModule(String url) {
        if (url.contains("purchase")) return "采购";
        if (url.contains("sales")) return "销售";
        if (url.contains("stock-check")) return "盘点";
        if (url.contains("expense")) return "报销";
        if (url.contains("inventory")) return "库存";
        if (url.contains("customer")) return "客户";
        if (url.contains("supplier")) return "供应商";
        return "其他";
    }

    private String extractAction(String url, String method) {
        if (url.contains("/create") || url.contains("/add") || url.contains("/submit")) return "新增";
        if (url.contains("/update")) return "修改";
        if (url.contains("/delete")) return "删除";
        if (url.contains("/approve")) return "审批";
        if (url.contains("/stock-in")) return "采购入库";
        if (url.contains("/stock-out")) return "销售出库";
        return method;
    }

    private String getClientIp(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip != null && ip.length() != 0 && !"unknown".equalsIgnoreCase(ip)) {
            return ip.split(",")[0];
        }
        ip = request.getHeader("X-Real-IP");
        if (ip != null && ip.length() != 0 && !"unknown".equalsIgnoreCase(ip)) {
            return ip;
        }
        return request.getRemoteAddr();
    }

    private String truncate(String str, int maxLength) {
        if (str == null) return null;
        return str.length() > maxLength ? str.substring(0, maxLength) : str;
    }
}