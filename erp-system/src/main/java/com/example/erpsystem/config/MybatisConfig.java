package com.example.erpsystem.config;

import com.example.erpsystem.interceptor.CompanySqlInterceptor;
import org.apache.ibatis.plugin.Interceptor;
import org.mybatis.spring.boot.autoconfigure.ConfigurationCustomizer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * MyBatis 配置：注册多公司隔离 SQL 拦截器（自动注入 company_id）。
 * 通过 ConfigurationCustomizer 保证拦截器被加到 MyBatis Configuration 中，
 * 与 Spring Boot mybatis-starter 版本无关，稳定可靠。
 */
@Configuration
public class MybatisConfig {

    @Bean
    public ConfigurationCustomizer companySqlConfigurationCustomizer(CompanySqlInterceptor companySqlInterceptor) {
        return configuration -> configuration.addInterceptor((Interceptor) companySqlInterceptor);
    }
}
