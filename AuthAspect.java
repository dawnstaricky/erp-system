package com.example.erpsystem.aspect;

import com.example.erpsystem.annotation.RequiresRoles;
import com.example.erpsystem.common.Result;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.http.HttpServletResponse;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import java.io.PrintWriter;
import java.lang.reflect.Method;

@Aspect
@Component
public class AuthAspect {

    @Around("@annotation(com.example.erpsystem.annotation.RequiresRoles)")
    public Object checkRole(ProceedingJoinPoint joinPoint) throws Throwable {
        ServletRequestAttributes attributes =
                (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        if (attributes == null) {
            return Result.error(401, "未登录");
        }

        String role = (String) attributes.getRequest().getAttribute("role");
        if (role == null) {
            return Result.error(401, "未登录");
        }

        MethodSignature signature = (MethodSignature) joinPoint.getSignature();
        Method method = signature.getMethod();
        RequiresRoles annotation = method.getAnnotation(RequiresRoles.class);

        String[] allowedRoles = annotation.value();
        boolean hasPermission = false;
        for (String allowed : allowedRoles) {
            if (allowed.equals(role)) {
                hasPermission = true;
                break;
            }
        }

        if (hasPermission) {
            return joinPoint.proceed();
        } else {
            HttpServletResponse response = attributes.getResponse();
            response.setStatus(403);
            response.setContentType("application/json;charset=UTF-8");
            PrintWriter writer = response.getWriter();
            writer.write(new ObjectMapper().writeValueAsString(
                    Result.error(403, "无权限访问")
            ));
            writer.flush();
            return null;
        }
    }
}