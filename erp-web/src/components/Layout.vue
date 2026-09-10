<template>
  <el-container class="layout-container">
    <el-aside width="210px" class="aside">
      <div class="logo">
        <el-icon :size="24" color="#409eff"><Box /></el-icon>
        <span>ERP管理系统</span>
      </div>
      <el-menu
        :default-active="activeMenu"
        router
        background-color="#001529"
        text-color="#b8c2cc"
        active-text-color="#409eff"
        class="side-menu"
      >
        <el-menu-item
          v-for="route in menuRoutes"
          :key="route.path"
          :index="route.path"
        >
          <el-icon><component :is="route.meta.icon" /></el-icon>
          <span>{{ route.meta.title }}</span>
        </el-menu-item>
      </el-menu>
    </el-aside>

    <el-container>
      <el-header class="header">
        <div class="header-left">
          <el-breadcrumb separator="/">
            <el-breadcrumb-item :to="{ path: '/dashboard' }">首页</el-breadcrumb-item>
            <el-breadcrumb-item>{{ currentTitle }}</el-breadcrumb-item>
          </el-breadcrumb>
        </div>
        <div class="header-right">
        <!-- ✅ 新增：待办徽标，用你已有的接口数据 -->
          <el-badge 
            :value="pendingCount" 
            :max="99" 
            class="pending-badge"
            v-if="pendingCount > 0"
          >
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
              <component 
                :is="Component" 
                @vue:mounted="() => console.log('[LAYOUT] 子组件挂载:', Component.name)"
                @vue:unmounted="() => console.log('[LAYOUT] 子组件卸载:', Component.name)"
              />
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
// 在你Layout.vue现有的图标导入基础上，加Bell
//import { Box, User, ArrowDown, Bell } from '@element-plus/icons-vue'

const route = useRoute()
const router = useRouter()
const userStore = useUserStore()

//const menuRoutes = computed(() => {
// return router.options.routes.find(r => r.path === '/').children || []
//})
// 使用：从router里拿到路由表，过滤后渲染
import { routes } from '@/router'
const roles = userStore.userInfo?.roles || []
const menuRoutes = filterRoutes(routes[1]?.children.filter(r => !r.meta?.hideInMenu) || [], roles) // routes[1]是带children的那个

const activeMenu = computed(() => route.path)

const currentTitle = computed(() => route.meta.title || '')

const userName = computed(() => {
  const user = localStorage.getItem('userInfo')
  return user ? JSON.parse(user).realName || '管理员' : '管理员'
})

//待办数量（用你已有的接口，不模拟数据）
const pendingCount = ref(0)
let pollTimer = null

// 获取待办数量的函数（调用你已有的/expense/pending接口）
const fetchPendingCount = async () => {
  //1. 先判断userId是否存在，不存在直接返回，不发请求
  const userId = userStore.userInfo?.userId
  if (!userId) {
    pendingCount.value = 0
    return
  }
  try {
    //2. 参数放在params里，axios会自动拼到URL Query上，完全适配后端@RequestParam
    const res = await getPendingExpense( userId )
    //3. 兼容你的接口返回格式（你之前的接口返回的是Result<List<ExpenseForm>>）
    const data = res?.data || res // 适配request.js是否解构了response
    pendingCount.value = Array.isArray(data) ? data.length : 0
  } catch (e) {
    //4. 仅打印错误，不影响页面渲染
    console.warn('待办获取失败（非致命）：', e.response?.data || e.message)
    pendingCount.value = 0
  }
}

// 启动轮询（1分钟一次，和你之前商量的方案一致）
onMounted(() => {
  fetchPendingCount()
  pollTimer = setInterval(fetchPendingCount, 60000)
})

// 销毁时清理定时器
onUnmounted(() => {
  if (pollTimer) clearInterval(pollTimer)
})


// 过滤出当前用户有权访问的路由
function filterRoutes(routes, roles) {
  const res = []
  for (const route of routes) {
    const tmp = { ...route }
    // 如果路由配置了roles，检查当前用户是否有权限
    if (tmp.meta?.roles) {
      const has = roles.some(r => tmp.meta.roles.includes(r))
      if (!has) continue // 没权限，跳过
    }
    // 递归过滤children
    if (tmp.children) {
      tmp.children = filterRoutes(tmp.children, roles)
      // 如果父菜单的所有子项都被过滤掉了，父菜单也隐藏
      if (tmp.children.length === 0 && tmp.meta?.roles) continue
    }
    res.push(tmp)
  }
  return res
}

function handleCommand(cmd) {
  if (cmd === 'logout') {
    ElMessageBox.confirm('确定要退出登录吗？', '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    }).then(() => {
      userStore.logout()
      ElMessage.success('已退出登录')
      router.push('/login')
    }).catch(() => {})
  }
}
</script>

<style scoped>
.layout-container {
  height: 100vh;
}
.aside {
  background: #001529;
  overflow-y: auto;
}
.logo {
  height: 60px;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  color: #fff;
  font-size: 16px;
  font-weight: bold;
  border-bottom: 1px solid #1f2d3d;
}
.side-menu {
  border-right: none;
}
.side-menu .el-menu-item {
  height: 48px;
  line-height: 48px;
}
.side-menu .el-menu-item:hover {
  background: #1f2d3d !important;
}
.header {
  background: #fff;
  border-bottom: 1px solid #e8e8e8;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 24px;
}
.user-info {
  display: flex;
  align-items: center;
  gap: 6px;
  cursor: pointer;
  color: #333;
}
.main-content {
  background: #f0f2f5;
  padding: 20px;
  overflow-y: auto;
}
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.2s ease;
}
.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
.pending-badge {
  margin-right: 16px;
  cursor: pointer;
}
</style>