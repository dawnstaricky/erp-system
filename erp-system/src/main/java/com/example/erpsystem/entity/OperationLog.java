package com.example.erpsystem.entity;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class OperationLog {
    private Long id;
    private Long userId;
    private String username;
    private String module;
    private String action;
    private String method;
    private String params;
    private String ipAddress;
    private Integer status;
    private String errorMsg;
    private LocalDateTime operationTime;
}