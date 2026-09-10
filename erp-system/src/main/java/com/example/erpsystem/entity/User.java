package com.example.erpsystem.entity;

import lombok.Data; // 这个注解能帮我们自动生成 get/set 方法，不用手写

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@Data // 别忘了这个注解
public class User {
    private Long id;
    private String username;
    private String password;
    private String realName;
    private Long deptId;
    private String phone;
    private String email;
    private String avatar;
    private String role;
    private Integer status;
    // 注意：数据库里的 created_at 会自动映射，因为我们在 yml 里开了驼峰转换
    // 新增：用于接收前端传来的角色ID数组
    private List<Long> roleIds;
    private List<Long> deptIds;
    private Long mainDeptId;
}