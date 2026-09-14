<template>
  <el-container class="layout-container">
    <el-aside width="210px" class="aside">
      <div class="logo">
        <el-icon :size="24" color="#409eff"><Box /></el-icon>
        <span>ERP管理系统</span>
      </div>
      <el-menu :default-active="activeMenu" router background-color="#001529" text-color="#b8c2cc" active-text-color="#409eff" class="side-menu">
        <template v-if="!isAdmin || currentCompanyId">
          <el-menu-item v-for="route in menuRoutes" :key="route.path" :index="route.path">
            <el-icon><component :is="route.meta.icon" /></el-icon>
            <span>{{ route.meta.title }}</span>
          </el-menu-item>
        </template>
        <template v-else>
          <el-menu-item v-for="route in adminOnlyRoutes" :key="route.path" :index="route.path">
            <el-icon><component :is="route.meta.icon" /></el-icon>
            <span>{{ route.meta.title }}</span>
          </el-menu-item>
        </template>
      </el-menu>
    </el-aside>

    <el-container>
      <el-header class="header">
        <div class="header-left">
          <CompanySwitcher v-if="userInfo" />
          <el-breadcrumb separator="/">
            <el-breadcrumb-item :to="{ path: '/dashboard' }">首页</el-breadcrumb-item>
            <el-breadcrumb-item>{{ currentTitle }}</el-breadcrumb-item>
          </el-breadcrumb>
        </div>
        <div class="header-right">
          <el-badge :value="pendingCount" :max="99" class="pending-badge" v-if="pendingCount > 0">
            <el-icon :size="18"><Bell /></el-icon>
          </el-badge>
          <el-dropdown @command="handleCommand">
            <span class="user-info">
              <el-icon :size="18"><User /></el-icon>
              {{ userName }}
              <el-icon><ArrowDown /></el-icon>
            </span>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item command="logout">退出登录</el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </el-header>

      <el-main class="main-content">
        <router-view v-slot="{ Component }">
          <transition name="fade" mode="out-in" :key="$route.fullPath">
            <component :is="Component" />
          </transition>
        </router-view>
      </el-main>
    </el-container>
  </el-container>
</template>

<script setup>
import { computed, ref, onMounted, onUnmounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { useUserStore } from '@/stores/user'
import { getPendingExpense } from '@/api/expense'
import CompanySwitcher from '@/components/CompanySwitcher.vue'
import { routes } from '@/router'

const route = useRoute(); const router = useRouter(); const userStore = useUserStore()
const userInfo = computed(() => userStore.userInfo)
const isAdmin = computed(() => (userStore.userInfo?.roles || []).includes('ADMIN'))
const currentCompanyId = computed(() => userStore.currentCompanyId)

const allRoutes = routes[1]?.children.filter(r => !r.meta?.hideInMenu) || []
// 业务菜单：需要公司上下文
const menuRoutes = computed(() => filterRoutes(allRoutes.filter(r => !r.meta?.adminOnly), userStore.userInfo?.roles || []))
// 管理员专属菜单（公司管理/用户管理/角色/权限/部门/日志）：无公司时也显示
const adminOnlyRoutes = computed(() => filterRoutes(allRoutes.filter(r => r.meta?.adminOnly), userStore.userInfo?.roles || []))

const activeMenu = computed(() => route.path)
const currentTitle = computed(() => route.meta.title || '')
const userName = computed(() => {
  const u = localStorage.getItem('userInfo'); return u ? JSON.parse(u).realName || '管理员' : '管理员'
})
const pendingCount = ref(0); let pollTimer = null
const fetchPendingCount = async () => {
  const userId = userStore.userInfo?.userId
  if (!userId) { pendingCount.value = 0; return }
  try {
    const res = await getPendingExpense(userId)
    const data = res?.data || res
    pendingCount.value = Array.isArray(data) ? data.length : 0
  } catch (e) { pendingCount.value = 0 }
}
onMounted(() => { fetchPendingCount(); pollTimer = setInterval(fetchPendingCount, 60000) })
onUnmounted(() => { if (pollTimer) clearInterval(pollTimer) })

function filterRoutes(list, roles) {
  const res = []
  for (const r of list) {
    const tmp = { ...r }
    if (tmp.meta?.roles) { const has = roles.some(role => tmp.meta.roles.includes(role)); if (!has) continue }
    if (tmp.children) { tmp.children = filterRoutes(tmp.children, roles); if (tmp.children.length === 0 && tmp.meta?.roles) continue }
    res.push(tmp)
  }
  return res
}
function handleCommand(cmd) {
  if (cmd === 'logout') {
    ElMessageBox.confirm('确定要退出登录吗？', '提示', { confirmButtonText: '确定', cancelButtonText: '取消', type: 'warning' }).then(() => {
      userStore.logout(); ElMessage.success('已退出登录'); router.push('/login')
    }).catch(() => {})
  }
}
</script>

<style scoped>
.layout-container { height: 100vh; }
.aside { background: #001529; overflow-y: auto; }
.logo { height: 60px; display: flex; align-items: center; justify-content: center; gap: 8px; color: #fff; font-size: 16px; font-weight: bold; border-bottom: 1px solid #1f2d3d; }
.side-menu { border-right: none; }
.side-menu .el-menu-item { height: 48px; line-height: 48px; }
.side-menu .el-menu-item:hover { background: #1f2d3d !important; }
.header { background: #fff; border-bottom: 1px solid #e8e8e8; display: flex; align-items: center; justify-content: space-between; padding: 0 24px; }
.header-left { display: flex; align-items: center; gap: 12px; }
.user-info { display: flex; align-items: center; gap: 6px; cursor: pointer; color: #333; }
.main-content { background: #f0f2f5; padding: 20px; overflow-y: auto; }
.fade-enter-active, .fade-leave-active { transition: opacity 0.2s ease; }
.fade-enter-from, .fade-leave-to { opacity: 0; }
.pending-badge { margin-right: 16px; cursor: pointer; }
</style>
