package com.example.erpsystem.entity;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class Permission {
    private Long id;
    private String permissionName;
    private String permissionCode;
    private String apiPath;
    private String apiMethod;
    private String description;
    private Integer status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}