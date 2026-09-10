package com.example.erpsystem.annotation;

import java.lang.annotation.*;

@Target({ElementType.METHOD, ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface RequiresRoles {
    String[] value(); // 允许的角色
    boolean logical() default true; // true=AND, false=OR
}