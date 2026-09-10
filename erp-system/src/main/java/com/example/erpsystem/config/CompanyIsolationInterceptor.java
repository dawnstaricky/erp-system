package com.example.erpsystem.config;

import com.example.erpsystem.common.CompanyContext;
import com.example.erpsystem.annotation.CompanyScope;
import lombok.extern.slf4j.Slf4j;
import net.sf.jsqlparser.JSQLParserException;
import net.sf.jsqlparser.parser.CCJSqlParserUtil;
import net.sf.jsqlparser.statement.Statement;
import net.sf.jsqlparser.statement.select.Select;
import net.sf.jsqlparser.statement.select.SelectBody;
import net.sf.jsqlparser.statement.select.PlainSelect;
import net.sf.jsqlparser.expression.Expression;
import net.sf.jsqlparser.expression.StringValue;
import net.sf.jsqlparser.expression.operators.conditional.AndExpression;
import net.sf.jsqlparser.util.TablesFinder;
import org.apache.ibatis.executor.statement.StatementHandler;
import org.apache.ibatis.mapping.BoundSql;
import org.apache.ibatis.mapping.MappedStatement;
import org.apache.ibatis.mapping.SqlCommandType;
import org.apache.ibatis.plugin.*;
import org.apache.ibatis.reflection.MetaObject;
import org.apache.ibatis.reflection.SystemMetaObject;

import javax.servlet.http.HttpServletRequest;
import java.lang.reflect.Method;
import java.sql.Connection;
import java.util.List;
import java.util.Properties;

/**
 * 多公司隔离拦截器：
 * - 仅对标注 @CompanyScope 的 Mapper 方法生效（避免误伤权限/字典/公司管理等基础表）
 * - 对 SELECT/UPDATE/DELETE 自动追加 "AND company_id = ?"
 * - company_id 取自请求头 X-Company-Id（通过 CompanyContext）
 * 说明：INSERT 的 company_id 由业务代码显式设置（实体字段），拦截器不处理 INSERT。
 */
@Slf4j
@Intercepts({@Signature(type = StatementHandler.class, method = "prepare", args = {Connection.class, Integer.class})})
public class CompanyIsolationInterceptor implements Interceptor {

    @Override
    public Object intercept(Invocation invocation) throws Throwable {
        StatementHandler handler = (StatementHandler) invocation.getTarget();
        MetaObject metaObject = SystemMetaObject.forObject(handler);
        MappedStatement ms = (MappedStatement) metaObject.getValue("delegate.mappedStatement");
        SqlCommandType cmd = ms.getSqlCommandType();

        // 仅处理查询/更新/删除
        if (cmd != SqlCommandType.SELECT && cmd != SqlCommandType.UPDATE && cmd != SqlCommandType.DELETE) {
            return invocation.proceed();
        }

        // 判断是否标注 @CompanyScope
        if (!isCompanyScope(ms.getId())) {
            return invocation.proceed();
        }

        // 获取当前公司
        Long companyId = CompanyContext.getCurrentCompanyId(getRequest());
        if (companyId == null) {
            // 未选择公司：管理员场景或基础数据，放行（不拼条件）
            return invocation.proceed();
        }

        BoundSql boundSql = handler.getBoundSql();
        String sql = boundSql.getSql();
        List<ParameterMapping> mappings = boundSql.getParameterMappings();

        // 解析并改写 SQL（简单场景：追加 AND company_id = ?）
        String newSql = appendCompanyCondition(sql, cmd);
        if (newSql.equals(sql)) {
            return invocation.proceed();
        }

        // 把 companyId 作为额外参数追加到参数数组末尾
        // 通过改写 parameterObject 为 Map，加入 __companyId
        Object param = boundSql.getParameterObject();
        param = addCompanyParam(param, mappings, companyId);

        metaObject.setValue("delegate.boundSql.parameterObject", param);
        metaObject.setValue("delegate.boundSql.sql", newSql);

        return invocation.proceed();
    }

    /** 在 SQL 末尾追加 company_id 条件（SELECT/UPDATE/DELETE 通用） */
    private String appendCompanyCondition(String sql, SqlCommandType cmd) {
        try {
            Statement stmt = CCJSqlParserUtil.parse(sql);
            if (stmt instanceof Select) {
                Select select = (Select) stmt;
                SelectBody body = select.getSelectBody();
                if (body instanceof PlainSelect) {
                    PlainSelect ps = (PlainSelect) body;
                    Expression where = ps.getWhere();
                    Expression companyExpr = new net.sf.jsqlparser.expression.LongValue(1); // 占位，实际参数化
                    // 简化：直接字符串拼接占位 ?，参数由 addCompanyParam 补充
                    String placeholder = " 1=1 AND company_id = ? ";
                    if (where == null) {
                        ps.setWhere(CCJSqlParserUtil.parseExpression("company_id = ?"));
                    } else {
                        ps.setWhere(new AndExpression(where, CCJSqlParserUtil.parseExpression("company_id = ?")));
                    }
                    return ps.toString();
                }
            }
            // UPDATE/DELETE：简单在 WHERE 后追加（若无可解析性风险，建议改用 XML 显式写 company_id）
            if (cmd == SqlCommandType.UPDATE || cmd == SqlCommandType.DELETE) {
                if (!sql.toLowerCase().contains("company_id")) {
                    return sql.replaceFirst("(?i)where", "WHERE company_id = ? AND ");
                }
            }
        } catch (JSQLParserException e) {
            log.warn("company isolation parse failed, skip: {}", e.getMessage());
        }
        return sql;
    }

    /** 将 companyId 追加到参数对象（Map 或 POJO） */
    private Object addCompanyParam(Object param, List<ParameterMapping> mappings, Long companyId) {
        // 使用 MapperMethod.ParamMap 兼容多参数
        MapperMethod.ParamMap<Object> map;
        if (param instanceof MapperMethod.ParamMap) {
            map = (MapperMethod.ParamMap<Object>) param;
        } else {
            map = new MapperMethod.ParamMap<>();
            if (param != null) map.put("param1", param);
        }
        map.put("__companyId", companyId);
        return map;
    }

    private boolean isCompanyScope(String msId) {
        try {
            // msId = "com.xxx.mapper.XxxMapper.methodName"
            int lastDot = msId.lastIndexOf('.');
            String clazzName = msId.substring(0, lastDot);
            String methodName = msId.substring(lastDot + 1);
            Class<?> clazz = Class.forName(clazzName);
            for (Method m : clazz.getMethods()) {
                if (m.getName().equals(methodName)) {
                    return m.isAnnotationPresent(CompanyScope.class);
                }
            }
        } catch (Exception ignored) {}
        return false;
    }

    private HttpServletRequest getRequest() {
        // 通过 RequestContextHolder 获取当前请求
        org.springframework.web.context.request.ServletRequestAttributes attrs =
                (org.springframework.web.context.request.ServletRequestAttributes)
                        org.springframework.web.context.request.RequestContextHolder.getRequestAttributes();
        return attrs == null ? null : attrs.getRequest();
    }

    @Override
    public Object plugin(Object target) {
        return Plugin.wrap(target, this);
    }

    @Override
    public void setProperties(Properties properties) {}
}
