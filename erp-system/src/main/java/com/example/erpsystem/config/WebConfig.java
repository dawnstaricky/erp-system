package com.example.erpsystem.config;

import com.example.erpsystem.interceptor.JwtInterceptor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Autowired
    private JwtInterceptor jwtInterceptor;

    @Value("${file.upload.expense}")
    private String expenseUploadDir;

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(jwtInterceptor)
                .addPathPatterns("/**")           // 拦截所有请求
                .excludePathPatterns(             // 放行以下路径
                        "/login",                 // 登录接口
                        "/register",              // 注册接口（以后可能用到）
                        "/error",                // 错误页面
                        "/product/**",
                        "/swagger-ui/**",         // Swagger文档（以后可能用到）
                        "/v3/api-docs/**",
                        "/admin/user/**",
                        "/user/change-password",
                        "/user/profile"
                );
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // 映射报销附件，前端可直接通过URL访问
        registry.addResourceHandler("/uploads/expense/**")
                .addResourceLocations("file:" + expenseUploadDir);
    }
}