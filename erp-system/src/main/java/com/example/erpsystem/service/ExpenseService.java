package com.example.erpsystem.service;

import com.example.erpsystem.entity.ApprovalRecord;
import com.example.erpsystem.entity.ExpenseForm;
import com.example.erpsystem.entity.ExpenseItem;
import com.example.erpsystem.mapper.ExpenseMapper;
import com.example.erpsystem.mapper.SysUserDeptMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ExpenseService {

    @Autowired
    private ExpenseMapper expenseMapper;
    @Autowired
    private FileService fileService;
    @Autowired
    private SysUserDeptMapper sysUserDeptMapper;

    // 提交报销单
    @Transactional
    public Long submitForm(ExpenseForm form, List<ExpenseItem> items) {
        // 生成单号
        String formNo = expenseMapper.generateFormNo();
        form.setFormNo(formNo);
        form.setStatus(1);  // 审批中

        // 计算总金额
        BigDecimal total = BigDecimal.ZERO;
        for (ExpenseItem item : items) {
            total = total.add(item.getAmount());
        }
        form.setTotalAmount(total);

        // 3. 获取申请人主部门ID（兼容原有sys_user.dept_id逻辑）
        Long mainDeptId = expenseMapper.selectUserMainDeptId(form.getApplicantId());
        if (mainDeptId == null) {
            throw new RuntimeException("申请人未配置主部门，请联系管理员");
        }
        form.setDeptId(mainDeptId);
        // 4. 获取部门经理作为第一审批人
        Long deptManagerId = expenseMapper.selectDeptManagerId(mainDeptId);
        if (deptManagerId == null) {
            throw new RuntimeException("该部门未配置部门经理，请联系管理员");
        }
        // 5. 设置当前审批人+状态
        form.setCurrentApproverId(deptManagerId);
        form.setStatus(1); // 1=审批中
        form.setDeptId(mainDeptId);

        // 插入报销单
        expenseMapper.insertForm(form);

        // 插入明细
        for (ExpenseItem item : items) {
            item.setFormId(form.getId());
        }
        expenseMapper.insertItems(items);

        return form.getId();
    }

    // 审批（同意/驳回）
    @Transactional
    public void approve(Long formId, Long approverId, Integer approveResult, String comment) {
        ExpenseForm form = expenseMapper.selectFormById(formId);
        if (form == null) throw new RuntimeException("报销单不存在");
        if (!approverId.equals(form.getCurrentApproverId())) {
            throw new RuntimeException("您不是当前审批人");
        }

        // 获取当前审批层级
        Integer currentLevel = getCurrentLevel(form, approverId);
        // 记录审批记录
        ApprovalRecord record = new ApprovalRecord();
        record.setFormId(formId);
        record.setFormType("expense");
        record.setApproverId(approverId);
        record.setApproveResult(approveResult);
        record.setApproveComment(comment);
        record.setApproveTime(LocalDateTime.now());
        record.setLevel(currentLevel);
        expenseMapper.insertApprovalRecord(record);

        if (approveResult == 0) {
            // 驳回：状态改为已驳回
            form.setStatus(3);
            form.setCurrentApproverId(null);
        } else {
            // 同意：流转到下一级
            Long nextApprover = getNextApprover(form);
            if (nextApprover == null) {
                // 没有下一级了，审批通过
                form.setStatus(2);  // 已通过
                form.setCurrentApproverId(null);
            } else {
                form.setCurrentApproverId(nextApprover);
            }
        }
        expenseMapper.updateForm(form);
    }

    /**
     * 获取当前审批层级（部门经理=1，总经理=2，财务经理=3）
     */
    private Integer getCurrentLevel(ExpenseForm form, Long approverId) {
        // 部门经理层级
        Long deptManagerId = expenseMapper.selectDeptManagerId(form.getDeptId());
        if (approverId.equals(deptManagerId)) {
            return 1;
        }
        // 总经理层级
        Long generalManagerId = expenseMapper.selectGeneralManagerId();
        if (approverId.equals(generalManagerId)) {
            return 2;
        }
        // 财务经理层级
        Long financeManagerId = expenseMapper.selectFinanceManagerId();
        if (approverId.equals(financeManagerId)) {
            return 3;
        }
        return 1;
    }

    // 获取下一级审批人
    private Long getNextApprover(ExpenseForm form) {
        BigDecimal total = form.getTotalAmount();
        Long currentApprover = form.getCurrentApproverId();
        Long deptId = form.getDeptId();

        // 1. 查当前部门经理
        Long deptManagerId = expenseMapper.selectDeptManagerId(deptId);
        // 2. 查总经理（总经办+ROLE_GENERAL_MANAGER）
        Long generalManagerId = expenseMapper.selectGeneralManagerId();
        // 3. 查财务经理（财务部+ROLE_FINANCE_MANAGER）
        Long financeManagerId = expenseMapper.selectFinanceManagerId();

        if (total.compareTo(new BigDecimal("5000")) <= 0) {
            // 金额≤5000：部门经理 → 财务经理
            if (currentApprover.equals(deptManagerId)) {
                return financeManagerId;
            }
        } else {
            // 金额>5000：部门经理 → 总经理 → 财务经理
            if (currentApprover.equals(deptManagerId)) {
                return generalManagerId;
            } else if (currentApprover.equals(generalManagerId)) {
                return financeManagerId;
            }
        }
        return null;
    }

    // 我的报销单
    public List<ExpenseForm> getMyForms(Long applicantId) {
        return expenseMapper.getMyForms(applicantId);
    }

    // 我的待办
    public List<ExpenseForm> getPendingForms(Long approverId) {
        return expenseMapper.getPendingForms(approverId);
    }

    // 报销单详情（返回Map，包含表单、明细、审批记录）
    public Map<String, Object> getDetail(Long formId) {
        Map<String, Object> result = new HashMap<>();
        ExpenseForm form = expenseMapper.selectFormById(formId);
        result.put("form", form);
        result.put("items", expenseMapper.selectItemsByFormId(formId));
        result.put("records", expenseMapper.selectRecordsByFormId(formId, "expense"));
        return result;
    }

    // ✅ 新增：上传附件逻辑（关联报销单ID）
    @Transactional
    public void uploadAttachments(Long formId, List<MultipartFile> files) throws IOException {
        ExpenseForm form = expenseMapper.selectFormById(formId);
        if (form == null) throw new RuntimeException("报销单不存在");
        String attachmentUrls = fileService.uploadFiles(files);
        expenseMapper.updateAttachmentUrls(formId, attachmentUrls);
    }

    // ✅ 新增：获取文件用于预览
    public File getExpenseFileByUrl(String url) {
        return fileService.getFileByUrl(url);
    }
}