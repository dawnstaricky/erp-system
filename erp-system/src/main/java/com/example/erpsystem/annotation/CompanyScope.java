package com.example.erpsystem.annotation;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * 标注在 Mapper 方法上，表示该方法需要自动拼接 company_id 隔离条件。
 * 只有标注了此注解的方法才会被 CompanyIsolationInterceptor 改写。
 */
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface CompanyScope {
}
