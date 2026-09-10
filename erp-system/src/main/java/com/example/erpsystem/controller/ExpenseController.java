package com.example.erpsystem.controller;

import com.example.erpsystem.annotation.RequiresRoles;
import com.example.erpsystem.common.Result;
import com.example.erpsystem.entity.ExpenseForm;
import com.example.erpsystem.entity.ExpenseItem;
import com.example.erpsystem.mapper.SysUserDeptMapper;
import com.example.erpsystem.service.ExpenseService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/expense")
public class ExpenseController {

    @Autowired
    private ExpenseService expenseService;

    @Autowired
    private SysUserDeptMapper sysUserDeptMapper;

    /**
     * 提交报销单（支持文件上传）
     * 用@RequestPart接收JSON，@RequestPart接收文件，解决404问题
     */

//    public Result<?> submit(@RequestBody @Valid SubmitRequest req) {
//        Long formId = expenseService.submitForm(req.getForm(), req.getItems());
//        return Result.success(formId);
//    }
    @PostMapping(value = "/submit", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public Result<?> submit(
            @RequestPart("form") @Valid ExpenseForm form,
            @RequestPart("items") @Valid List<ExpenseItem> items,
            @RequestPart(value = "files", required = false) List<MultipartFile> files,
            HttpServletRequest request) {
        try {
            // ✅ 从JWT取申请人
            Long applicantId = (Long) request.getAttribute("userId");
            form.setApplicantId(applicantId);
            // ✅ 查主部门
            Long mainDeptId = sysUserDeptMapper.selectMainDeptId(applicantId);
            form.setDeptId(mainDeptId);
            // 4. 上传附件（如果有）
            // 5. 提交报销单
            Long formId = expenseService.submitForm(form, items);
            if (files != null && !files.isEmpty()) {
                expenseService.uploadAttachments(formId, files);
            }

            return Result.success(formId);
        } catch (Exception e) {
            return Result.error(500, e.getMessage());
        }
    }

    @RequiresRoles({"ADMIN", "FINANCE", "MANAGER", "GM"})
    @PostMapping("/approve/{formId}")
    public Result<?> approve(
            @PathVariable Long formId,
            @RequestParam Integer approveResult,
            @RequestParam(required = false) String comment,
            HttpServletRequest request) {
        try {
            Long approverId = (Long) request.getAttribute("userId");
            expenseService.approve(formId, approverId, approveResult, comment);
            return Result.success();
        } catch (Exception e) {
            return Result.error(500, e.getMessage());
        }
    }

    @GetMapping("/my")
    public Result<List<ExpenseForm>> my(HttpServletRequest request) {
        Long applicantId = (Long) request.getAttribute("userId");
        return Result.success(expenseService.getMyForms(applicantId));
    }

//    @GetMapping("/pending")
//    public Result<List<ExpenseForm>> pending(@RequestParam Long approverId) {
//        return Result.success(expenseService.getPendingForms(approverId));
//    }

    // 待审批列表（完全无参，从Token解析当前用户ID）
    @RequiresRoles({"ADMIN", "FINANCE", "MANAGER", "GM"})
    @GetMapping("/pending")
    public Result<List<ExpenseForm>> pending(HttpServletRequest request) {
        Long currentUserId = (Long) request.getAttribute("userId");
        return Result.success(expenseService.getPendingForms(currentUserId));
    }

    @GetMapping("/{formId}")
    public Result<Map<String, Object>> detail(@PathVariable Long formId) {
        return Result.success(expenseService.getDetail(formId));
    }

    public static class SubmitRequest {
        @Valid
        private ExpenseForm form;
        @Valid
        private List<ExpenseItem> items;
        public ExpenseForm getForm() { return form; }
        public void setForm(ExpenseForm form) { this.form = form; }
        public List<ExpenseItem> getItems() { return items; }
        public void setItems(List<ExpenseItem> items) { this.items = items; }
    }

    // ✅ 新增：上传报销附件接口（提交报销单后再上传，不破坏原有submit逻辑）
    @PostMapping("/upload-attachments/{formId}")
    public Result<?> uploadAttachments(
            @PathVariable Long formId,
            @RequestParam("files") List<MultipartFile> files) throws IOException {
        expenseService.uploadAttachments(formId, files);
        return Result.success("附件上传成功");
    }

    // ✅ 新增：预览附件接口（用request拦截器自动带token，解决401问题）
    @GetMapping("/preview-attachment")
    public void previewAttachment(
            @RequestParam String url,
            HttpServletResponse response) throws IOException {
        File file = expenseService.getExpenseFileByUrl(url);
        if (!file.exists()) {
            response.setStatus(404);
            return;
        }
        // 根据文件类型设置响应头
        String suffix = url.substring(url.lastIndexOf(".") + 1).toLowerCase();
        if ("pdf".equals(suffix)) {
            response.setContentType("application/pdf");
        } else if (List.of("jpg", "jpeg", "png").contains(suffix)) {
            response.setContentType("image/" + suffix);
        }
        response.setHeader("Content-Disposition", "inline; filename=" + file.getName());
        Files.copy(file.toPath(), response.getOutputStream());
        response.getOutputStream().flush();
    }
}