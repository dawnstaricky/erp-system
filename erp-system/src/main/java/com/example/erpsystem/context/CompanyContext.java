package com.example.erpsystem.context;

public class CompanyContext {
    private static final ThreadLocal<Long> COMPANY = new ThreadLocal<>();
    private static final ThreadLocal<Boolean> ADMIN = new ThreadLocal<>();

    public static void setCompanyId(Long id) { COMPANY.set(id); }
    public static Long getCompanyId() { return COMPANY.get(); }
    public static void setAdmin(boolean admin) { ADMIN.set(admin); }
    public static boolean isAdmin() { return Boolean.TRUE.equals(ADMIN.get()); }
    public static void clear() { COMPANY.remove(); ADMIN.remove(); }
}
