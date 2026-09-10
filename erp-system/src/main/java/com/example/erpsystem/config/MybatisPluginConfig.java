package com.example.erpsystem.config;

import org.apache.ibatis.plugin.Interceptor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * MyBatis 插件配置：注册多公司隔离拦截器
 */
@Configuration
public class MybatisPluginConfig {

    @Bean
    public Interceptor companyIsolationInterceptor() {
        return new CompanyIsolationInterceptor();
    }
}
