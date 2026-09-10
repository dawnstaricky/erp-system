package com.example.erpsystem.mapper;

import com.example.erpsystem.entity.ExpenseForm;
import com.example.erpsystem.entity.ExpenseItem;
import com.example.erpsystem.entity.ApprovalRecord;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import java.util.List;
import java.util.Map;

@Mapper
public interface ExpenseMapper {
    // 报销单
    int insertForm(ExpenseForm form);
    int updateForm(ExpenseForm form);
    ExpenseForm selectFormById(Long id);
    List<ExpenseForm> getMyForms(Long applicantId);
    List<ExpenseForm> getPendingForms(Long approverId);
    String generateFormNo();

    // 报销明细
    int insertItems(List<ExpenseItem> items);
    List<ExpenseItem> selectItemsByFormId(Long formId);
    int deleteItemsByFormId(Long formId);

    // 审批记录
    int insertApprovalRecord(ApprovalRecord record);
    //List<ApprovalRecord> selectRecordsByFormId(Long formId);
    List<ApprovalRecord> selectRecordsByFormId(@Param("formId") Long formId, @Param("formType") String formType);

    // ✅ 新增更新附件的SQL（仅更新附件字段，不影响其他）
    @Update("UPDATE expense_form SET attachment_urls = #{urls}, updated_at = NOW() WHERE id = #{id}")
    void updateAttachmentUrls(@Param("id") Long id, @Param("urls") String urls);

    // 新增：查部门经理（关联用户-部门表+角色表，角色包含"经理"）
    @Select("""
        SELECT u.id, u.real_name 
        FROM sys_user u
        JOIN sys_user_dept ud ON u.id = ud.user_id
        JOIN user_role ur ON u.id = ur.user_id
        JOIN sys_role r ON ur.role_id = r.id
        WHERE ud.dept_id = #{deptId} AND r.role_code LIKE '%MANAGER%' AND u.status = 1
        LIMIT 1
    """)
    Long selectDeptManagerId(Long deptId);

    // 新增：查询总经理（部门名称=总经办 + 角色ROLE_GENERAL_MANAGER）
    @Select("""
        SELECT u.id, u.real_name 
        FROM sys_user u
        JOIN sys_user_dept ud ON u.id = ud.user_id
        JOIN sys_department d ON ud.dept_id = d.id
        JOIN user_role ur ON u.id = ur.user_id
        JOIN sys_role r ON ur.role_id = r.id
        WHERE d.dept_name = '总经办' 
          AND r.role_code = 'GM' 
          AND u.status = 1
        LIMIT 1
    """)
    Long selectGeneralManagerId();

    // 新增：查询财务经理（部门名称=财务部 + 角色ROLE_FINANCE_MANAGER）
    @Select("""
        SELECT u.id, u.real_name 
        FROM sys_user u
        JOIN sys_user_dept ud ON u.id = ud.user_id
        JOIN sys_department d ON ud.dept_id = d.id
        JOIN user_role ur ON u.id = ur.user_id
        JOIN sys_role r ON ur.role_id = r.id
        WHERE d.dept_name = '财务部' 
          AND r.role_code = 'DEPT_MANAGER' 
          AND u.status = 1
        LIMIT 1
    """)
    Long selectFinanceManagerId();

    // 新增：查询用户主部门ID（兼容原有sys_user.dept_id逻辑）
    @Select("""
        SELECT dept_id FROM sys_user_dept WHERE user_id = #{userId} AND is_main = 1
    """)
    Long selectUserMainDeptId(Long userId);
}