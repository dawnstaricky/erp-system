<!--
  在 Layout.vue 的头部（header）区域，路由菜单之前插入公司切换器：
    <template>
      <div class="app-wrapper">
        <header>
          <!-- 新增：公司切换下拉（管理员无公司时不显示） -->
          <CompanySwitcher v-if="showSwitcher" />
          ... 原有菜单 ...
        </header>
      </div>
    </template>

    <script setup>
    import CompanySwitcher from '@/components/CompanySwitcher.vue'
    import { useUserStore } from '@/stores/user'
    const userStore = useUserStore()
    // 管理员(ADMIN)不绑定公司，只显管理菜单，不显示切换器
    const showSwitcher = computed(() =>
      userStore.companies && userStore.companies.length > 0
    )
    </script>

  空白页逻辑（无公司时的提示）：
    - 若 userStore.companies.length === 0：
      显示空白页 + 提示"您还未分配公司，请联系管理员"
    - 管理员(ADMIN)默认不选中公司，仅展示：
      个人中心 / 公司管理 / 用户管理 / 角色管理 / 部门管理 / 权限管理 / 操作日志
    - 业务用户选中公司后才列出其它业务模块（路由守卫中判断 currentCompany）
-->
