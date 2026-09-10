package com.example.erpsystem.entity;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class Warehouse {
    private Long id;
    private String warehouseCode;
    private String warehouseName;
    private String address;
    private String manager;
    private String phone;
    private Integer status;
    private String remark;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}