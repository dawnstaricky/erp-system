package com.example.erpsystem.controller;

import com.example.erpsystem.common.Result;
import com.example.erpsystem.mapper.BusinessArchiveMapper;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/archive")
public class BusinessArchiveController {

    @Autowired private BusinessArchiveMapper archiveMapper;

    @GetMapping("/list")
    public Result<?> list(@RequestParam(defaultValue = "1") int pageNum,
                          @RequestParam(defaultValue = "10") int pageSize,
                          @RequestParam(required = false) Integer isArchived) {
        PageHelper.startPage(pageNum, pageSize);
        List<?> list = archiveMapper.selectList(isArchived, null, null);
        return Result.success(new PageInfo<>(list));
    }
}
