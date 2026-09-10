import { createRouter, createWebHistory } from 'vue-router'
import { useUserStore } from '../stores/user'
import { ElMessage } from 'element-plus'
import RolePermission from '@/views/permission/RolePermission.vue' 

const routes = [
  { path:'/login', name:'Login', component:()=>import('@/views/Login.vue'), meta:{title:'登录'} },
  {
    path:'/',
    component:()=>import('@/components/Layout.vue'),
    redirect:'/dashboard',
    children:[
      { path:'dashboard',     name:'Dashboard',     component:()=>import('@/views/Dashboard.vue'),          meta:{title:'仪表盘',icon:'Odometer',  roles:['ADMIN','GM','DEPT_MANAGER','FINANCE','SALES','PURCHASER','INVENTORY','STAFF']} },
      { path:'profile',       name:'Profile',       component:()=>import('@/views/profile/Profile.vue'),   meta:{title:'个人中心',icon:'UserFilled',roles:['ADMIN','GM','DEPT_MANAGER','FINANCE','SALES','PURCHASER','INVENTORY','STAFF']} },

      // 系统管理（仅 ADMIN）
      { path:'user',          name:'User',          component:()=>import('@/views/user/UserList.vue'),      meta:{title:'用户管理',icon:'User',       roles:['ADMIN']} },
      { path:'role',          name:'Role',          component:()=>import('@/views/role/RoleList.vue'),      meta:{title:'角色管理',icon:'Key',       roles:['ADMIN']} },
      { path:'permission',    name:'Permission',    component:()=>import('@/views/permission/PermissionList.vue'), meta:{title:'权限管理',icon:'Lock',   roles:['ADMIN']} },
      { path:'dept',          name:'Dept',          component:()=>import('@/views/dept/DeptList.vue'),      meta:{title:'部门管理',icon:'OfficeBuilding',       roles:['ADMIN']} },

      // 业务模块
      { path:'product',       name:'Product',       component:()=>import('@/views/product/ProductList.vue'), meta:{title:'商品管理',icon:'Goods',     roles:['ADMIN','SALES','PURCHASER','INVENTORY']} },
      { path:'supplier',      name:'Supplier',      component:()=>import('@/views/supplier/SupplierList.vue'),meta:{title:'供应商管理',icon:'Van',     roles:['ADMIN','PURCHASER']} },
      { path:'customer',      name:'Customer',      component:()=>import('@/views/customer/CustomerList.vue'),meta:{title:'客户管理',icon:'User',      roles:['ADMIN','SALES']} },
      { path:'warehouse',     name:'Warehouse',     component:()=>import('@/views/warehouse/WarehouseList.vue'),meta:{title:'仓库管理',icon:'House',    roles:['ADMIN','INVENTORY']} },
      { path:'purchase',      name:'Purchase',      component:()=>import('@/views/purchase/PurchaseList.vue'),meta:{title:'采购管理',icon:'ShoppingCart',roles:['ADMIN','PURCHASER']} },
      { path:'sales',         name:'Sales',         component:()=>import('@/views/sales/SalesList.vue'),    meta:{title:'销售管理',icon:'Sell',      roles:['ADMIN','SALES']} },
      { path:'inventory',     name:'Inventory',     component:()=>import('@/views/inventory/InventoryList.vue'),meta:{title:'库存管理',icon:'Box',      roles:['ADMIN','INVENTORY']} },
      { path:'stock-check',   name:'StockCheck',    component:()=>import('@/views/stockCheck/StockCheckList.vue'),meta:{title:'盘点管理',icon:'Checked',  roles:['ADMIN','INVENTORY']} },
      { path:'expense',       name:'Expense',       component:()=>import('@/views/expense/ExpenseList.vue'), meta:{title:'报销管理',icon:'Money',     roles:['ADMIN','GM','DEPT_MANAGER','FINANCE','STAFF']} },
      { path:'report',        name:'Report',        component:()=>import('@/views/report/ReportCenter.vue'),meta:{title:'统计报表',icon:'DataAnalysis',roles:['ADMIN','GM','DEPT_MANAGER','FINANCE']} },

      // 角色权限分配（从角色列表点进来）
      //{ path:'role-permission/:roleId', name:'RolePermission', component:()=>import('@/views/permission/RolePermission.vue'), meta:{title:'角色权限分配',icon:'Lock',roles:['ADMIN']} },
      { 
        path:'role-permission/:roleId', 
        name:'RolePermission', 
        component: RolePermission, 
        meta:{ 
          title:'角色权限分配',
          icon:'Lock',
          roles:['ADMIN'],
          hideInMenu: true // 新增：不在主导航显示
        }
      },
      { 
        path:'operation-log', 
        name:'OperationLog', 
        component:()=>import('@/views/system/OperationLog.vue'), 
        meta:{title:'操作日志',icon:'Document', roles:['ADMIN']} 
      },
      
    ]
  }
]

const router = createRouter({ history:createWebHistory(), routes });

router.onError((error) => {
  if (error.message.includes('Failed to fetch dynamically imported module')) {
    ElMessage.error('页面不存在，请刷新后重试')
    if (error.message.includes('OperationLog')) {
      router.push('/404') // 操作日志报错跳404
    }
  } else {
    ElMessage.error('页面跳转失败，请重试')
  }
})




const whiteList = ['/login']

router.beforeEach(async (to, from) => {
  document.title = to.meta.title ? `${to.meta.title}-ERP系统` : 'ERP系统'
  
  const userStore = useUserStore()
  const token = userStore.token || localStorage.getItem('token')
  
  // 1. 没有token，去登录页
  if (!token && !whiteList.includes(to.path)) {
    return `/login?redirect=${to.path}` // 代替next()return next(`/login?redirect=${to.path}`)
  }
  
  // 2. 有token，去登录页，重定向到首页
  if (token && to.path === '/login') {
    return '/dashboard' // 代替next()return next('/dashboard')
  }
  
  // 3. 有token，不是登录页，检查用户信息
  if (token && to.path !== '/login') {
    // 如果还没有用户信息，先获取
    if (!userStore.userInfo) {
      try {
        // 尝试从localStorage恢复用户信息
        const storedUserInfo = JSON.parse(localStorage.getItem('userInfo') || '{}')
        if (storedUserInfo.userId) {
          userStore.userInfo = storedUserInfo
          console.log('index.js 进入if (storedUserInfo.userId)分支，return true')
          return true
        } else {
          // 如果localStorage没有，调用接口获取
          await userStore.getUserInfo()
          console.log('index.js userStore.getUserInfo()执行，return true')
          return true // 代替next()
        }
      } catch (error) {
        // 获取失败，清除token，去登录页
        userStore.logout()
        ElMessage.error('登录状态已失效，请重新登录')
        return `/login?redirect=${to.path}` // 代替next()return next(`/login?redirect=${to.path}`)
      }
    }
    console.log('index.js 没有进入if (!userStore.userInfo)分支')

    // ✅ 核心修改：仅访问角色权限页时，才校验roleId
    if (to.name === 'RolePermission') {
      console.log('index.js[to.name === RolePermission] beforeEach执行，to.params.roleId:', to.params.roleId)
      const roleId = to.params.roleId
      if (!roleId || isNaN(parseInt(roleId))) {
        return '/role'
      }
    }
    
    // 4. 权限校验
    if (to.meta.roles) {
      const userRoles = userStore.userInfo?.roles || []
      const hasPermission = userRoles.some(role => to.meta.roles.includes(role))
      console.log('index.js进入if (to.meta.roles)分支，hasPermission:', hasPermission)
      
      if (!hasPermission) {
        ElMessage.error('没有权限访问该页面')
        // 没有权限时，留在当前页或去首页，避免死循环
        return from.path || '/dashboard' // 代替next()return next(from.path || '/dashboard')
      }
    }
    
    console.log('[ROUTER] 匹配到的组件:', to.matched[1]?.components.default?.name || to.matched[1]?.components.default)
    //console.log('[Router] 放行RolePermission，匹配到的组件：', to.matched.map(r => r.components.default))
    console.log('index.js执行return true')
    // 5. 放行
    return true // 放行，代替next()return next()
  }
  
  return true // 放行，代替next()next()
})

export default router
export { routes };