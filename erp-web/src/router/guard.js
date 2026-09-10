import router from './index'
import { useUserStore } from '@/stores/user'

const ADMIN_ONLY = ['/admin/company', '/admin/user', '/admin/role',
                    '/admin/dept', '/admin/permission', '/admin/log', '/profile']

router.beforeEach(async (to, from, next) => {
  const userStore = useUserStore()
  const token = localStorage.getItem('token')

  if (!token) {
    return to.path === '/login' ? next() : next('/login')
  }

  // 已登录：确保用户信息已加载
  if (!userStore.userInfo) {
    try { await userStore.fetchUserInfo() } catch (e) {}
  }

  const isAdmin = userStore.roles.includes('ADMIN')

  // 管理员：可访问所有管理页，无需选公司
  if (isAdmin) return next()

  // 业务用户：必须已选中公司，否则除个人中心/登录外一律拦截到空白提示页
  const hasCompany = !!userStore.currentCompany
  if (!hasCompany && !ADMIN_ONLY.includes(to.path) && to.path !== '/no-company') {
    return next('/no-company')
  }

  next()
})
