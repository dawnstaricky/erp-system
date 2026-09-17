package com.example.erpsystem.interceptor;

import com.example.erpsystem.context.CompanyContext;
import org.apache.ibatis.executor.statement.StatementHandler;
import org.apache.ibatis.mapping.BoundSql;
import org.apache.ibatis.mapping.MappedStatement;
import org.apache.ibatis.mapping.SqlCommandType;
import org.apache.ibatis.plugin.*;
import org.apache.ibatis.reflection.MetaObject;
import org.apache.ibatis.reflection.SystemMetaObject;
import org.springframework.stereotype.Component;

import java.lang.reflect.Field;
import java.sql.Connection;
import java.util.Map;
import java.util.Properties;

/**
 * MyBatis 拦截器：多公司数据隔离（架构底座）
 * - INSERT：自动补 company_id 列与值（从 CompanyContext 取）
 * - SELECT/UPDATE/DELETE：自动追加 WHERE company_id = ?（仅业务表，白名单控制）
 * 管理员（ADMIN）请求 companyId 为 null，则不注入（管理员只访问系统管理接口，均被白名单排除）
 */
@Component
@Intercepts({@Signature(type = StatementHandler.class, method = "prepare", args = {Connection.class, Integer.class})})
public class CompanySqlInterceptor implements Interceptor {

    /** 需要 company_id 隔离的业务表（白名单，避免误改系统表） */
    private static final java.util.Set<String> TABLES = new java.util.HashSet<>(java.util.Arrays.asList(
            "supplier", "customer", "product", "warehouse",
            "purchase_order", "purchase_order_item", "purchase_contract", "purchase_contract_item",
            "sales_order", "sales_order_item", "sales_contract", "sales_contract_item",
            "inventory", "inventory_flow", "stock_check",
            "invoice", "receipt", "business_archive", "quality_dispute",
            "expense_form", "expense_item"
    ));

    @Override
    public Object intercept(Invocation invocation) throws Throwable {
        // 1. 拿到原始 SQL（通过 BoundSql，不碰 delegate）
        StatementHandler handler = (StatementHandler) invocation.getTarget();
        BoundSql boundSql = handler.getBoundSql();
        String sql = boundSql.getSql();

        System.out.println("[CompanySqlInterceptor] SQL: " + sql);

        if (sql == null) {
            return invocation.proceed();
        }

        String lower = sql.toLowerCase();
        Long companyId = CompanyContext.getCompanyId();

        // 管理员（companyId 为 null 或 0）不注入
        if (companyId == null || companyId == 0 || CompanyContext.isAdmin()) {
            return invocation.proceed();
        }

        // 防止 SQL 注入
        if (!String.valueOf(companyId).matches("\\d+")) {
            return invocation.proceed();
        }

        // 解析出操作的表名
        String table = findTable(lower);
        if (table == null || !TABLES.contains(table)) {
            return invocation.proceed();
        }

        // 只对受管表注入
        if (lower.contains("insert into " + table)) {
            // INSERT：在列清单和 VALUES 中同步插入 company_id
            String newSql = injectInsert(sql, companyId);
            if (!newSql.equals(sql)) {
                // 用标准反射设置 BoundSql 的 sql 字段（不碰 delegate）
                Field field = BoundSql.class.getDeclaredField("sql");
                field.setAccessible(true);
                field.set(boundSql, newSql);
            }
        }
//        else if (lower.contains(" where ") && !lower.contains("company_id")) {
//            // SELECT/UPDATE/DELETE：追加 WHERE company_id = ?
//            String newSql = injectWhere(sql, companyId);
//            if (!newSql.equals(sql)) {
//                Field field = BoundSql.class.getDeclaredField("sql");
//                field.setAccessible(true);
//                field.set(boundSql, newSql);
//                // 把 companyId 追加到参数对象，供新增的 ? 绑定
//                Object param = boundSql.getParameterObject();
//                // 仅当参数是 Map 时才追加，避免破坏 Bean 参数（Bean 由 XML 里 #{} 直接取属性）
//                if (param instanceof Map) {
//                    @SuppressWarnings("unchecked")
//                    Map<String, Object> map = (Map<String, Object>) param;
//                    map.put("companyId", companyId);
//                }
//                // 注意：若 XML 里 WHERE company_id = #{companyId}，则 map 里必须有 companyId
//            }
//        }
        else if (lower.contains(" where ") && !lower.contains("company_id")) {
            // SELECT/UPDATE/DELETE：追加 WHERE company_id = companyId（直接拼接值，不用?）
            String condition = " company_id = " + companyId;
            String newSql;
            if (lower.contains("where")) {
                newSql = sql.replaceFirst("(?i)where", "where " + condition + " and ");
            } else {
                newSql = sql + " where " + condition;
            }
            Field field = BoundSql.class.getDeclaredField("sql");
            field.setAccessible(true);
            field.set(boundSql, newSql);
            // 注意：不再往参数 Map 里放 companyId，因为 SQL 里没有 ? 了
        }

        return invocation.proceed();
    }

    //@Override
    public Object intercept_bak(Invocation invocation) throws Throwable {
        StatementHandler handler = (StatementHandler) invocation.getTarget();
        MetaObject meta = SystemMetaObject.forObject(handler);
        MappedStatement ms = (MappedStatement) meta.getValue("delegate.mappedStatement");
        BoundSql boundSql = handler.getBoundSql();
        String sql = boundSql.getSql();
        if (sql == null) return invocation.proceed();

        String lower = sql.toLowerCase();
        Long companyId = CompanyContext.getCompanyId();

        // 管理员不注入（管理员不绑定公司，只操作系统管理接口）
        if (companyId == null) return invocation.proceed();

        String table = findTable(lower);
        if (table == null || !TABLES.contains(table)) return invocation.proceed();

        String newSql = sql;
        if (ms.getSqlCommandType() == SqlCommandType.INSERT) {
            newSql = injectInsert(sql, companyId);
        } else if (ms.getSqlCommandType() == SqlCommandType.SELECT
                || ms.getSqlCommandType() == SqlCommandType.UPDATE
                || ms.getSqlCommandType() == SqlCommandType.DELETE) {
            newSql = injectWhere(sql, companyId);
        }

        if (!newSql.equals(sql)) {
            meta.setValue("delegate.boundSql.sql", newSql);
            // 把 companyId 作为参数追加到 parameterObject，供 ? 占位符绑定
            Object param = boundSql.getParameterObject();
            meta.setValue("delegate.boundSql.parameterObject", wrapParam(param, companyId));
        }
        return invocation.proceed();
    }

    private String findTable(String lower) {
        // 只在这些关键字后精确匹配白名单表名
        String[] prefixes = {"from ", "update ", "insert into ", "delete from "};
        for (String prefix : prefixes) {
            int idx = lower.indexOf(prefix);
            while (idx >= 0) {
                int start = idx + prefix.length();
                int end = start;
                while (end < lower.length() && (Character.isLetterOrDigit(lower.charAt(end)) || lower.charAt(end) == '_')) {
                    end++;
                }
                String tbl = lower.substring(start, end);
                if (TABLES.contains(tbl)) {
                    return tbl;
                }
                idx = lower.indexOf(prefix, idx + 1);
            }
        }
        return null;
    }

    /** 极简表名提取（取第一个匹配的受管表名） */
    private String findTable_bak(String lower) {
        for (String t : TABLES) {
            if (lower.contains(" " + t + " ") || lower.contains("\t" + t + "\t")
                    || lower.contains(" " + t + "(") || lower.contains(" " + t + "\n")
                    || lower.startsWith(t + " ") || lower.contains("into " + t)
                    || lower.contains("from " + t) || lower.contains("update " + t + " ")
                    || lower.contains("delete from " + t)) {
                return t;
            }
        }
        return null;
    }

    /** INSERT 语句补 company_id：在列清单和 VALUES 中同步插入 */
    private String injectInsert(String sql, Long companyId) {
        // 处理 "INSERT INTO tbl (a,b) VALUES (?,?)" 形式
        String s = sql.replaceAll("(?i)\\s+INTO\\s+(\\w+)", " INTO $1");
        java.util.regex.Matcher m = java.util.regex.Pattern.compile("(?i)\\(([^)]*)\\)\\s*VALUES\\s*\\(([^)]*)\\)").matcher(s);
        if (m.find()) {
            String cols = m.group(1).trim();
            String vals = m.group(2).trim();
            // 若已含 company_id 则不重复
            if (cols.toLowerCase().contains("company_id")) return sql;
            String newCols = cols.isEmpty() ? "company_id" : cols + ", company_id";
            String newVals = vals.isEmpty() ? "?" : vals + ", ?";
            s = s.substring(0, m.start()) + "(" + newCols + ") VALUES (" + newVals + ")" + s.substring(m.end());
        }
        return s;
    }

    /** SELECT/UPDATE/DELETE 追加 WHERE company_id = ?（已有 WHERE 则用 AND） */
    private String injectWhere(String sql, Long companyId) {
        String s = sql.trim().replaceAll("\\s+", " ");
        if (s.toLowerCase().contains("company_id")) return sql; // 已显式带 company_id，不重复
        int whereIdx = s.toLowerCase().lastIndexOf(" where ");
        if (whereIdx > 0) {
            return s.substring(0, whereIdx) + " WHERE " + s.substring(whereIdx + 7) + " AND company_id = ?";
        } else {
            return s + " WHERE company_id = ?";
        }
    }

    /** 将 companyId 追加到参数对象，使新增的 ? 能绑定。Map/bean 均兼容 */
    private Object wrapParam(Object param, Long companyId) {
        if (param instanceof java.util.Map) {
            java.util.Map<String, Object> map = new java.util.HashMap<>((java.util.Map<String, Object>) param);
            map.put("companyId", companyId);
            return map;
        }
        // bean 或 null：包装成 Map，保留原参数以 "param" 键供 MyBatis 访问
        java.util.Map<String, Object> map = new java.util.HashMap<>();
        map.put("param", param);
        map.put("companyId", companyId);
        return map;
    }

    @Override
    public Object plugin(Object target) { return Plugin.wrap(target, this); }

    @Override
    public void setProperties(Properties properties) {}
}
