import { createRouter, createWebHistory } from 'vue-router'
import { useUserStore } from '../stores/user'
import { ElMessage } from 'element-plus'

const routes = [
  { path:'/login', name:'Login', component:()=>import('@/views/Login.vue'), meta:{title:'登录'} },
  {
    path:'/', component:()=>import('@/components/Layout.vue'), redirect:'/dashboard',
    children:[
      { path:'dashboard', name:'Dashboard', component:()=>import('@/views/Dashboard.vue'), meta:{title:'仪表盘',icon:'Odometer',roles:['ADMIN','GM','DEPT_MANAGER','FINANCE','SALES','PURCHASER','INVENTORY','STAFF']} },
      { path:'profile', name:'Profile', component:()=>import('@/views/profile/Profile.vue'), meta:{title:'个人中心',icon:'UserFilled',roles:['ADMIN','GM','DEPT_MANAGER','FINANCE','SALES','PURCHASER','INVENTORY','STAFF']} },

      // 系统管理（仅 ADMIN，adminOnly：管理员未选公司也可见）
      { path:'company', name:'Company', component:()=>import('@/views/system/CompanyList.vue'), meta:{title:'公司管理',icon:'OfficeBuilding',roles:['ADMIN'],adminOnly:true} },
      { path:'user-company', name:'UserCompany', component:()=>import('@/views/system/UserCompany.vue'), meta:{title:'用户公司角色',icon:'Connection',roles:['ADMIN'],adminOnly:true} },
      { path:'user', name:'User', component:()=>import('@/views/user/UserList.vue'), meta:{title:'用户管理',icon:'User',roles:['ADMIN'],adminOnly:true} },
      { path:'role', name:'Role', component:()=>import('@/views/role/RoleList.vue'), meta:{title:'角色管理',icon:'Key',roles:['ADMIN'],adminOnly:true} },
      { path:'permission', name:'Permission', component:()=>import('@/views/permission/PermissionList.vue'), meta:{title:'权限管理',icon:'Lock',roles:['ADMIN'],adminOnly:true} },
      { path:'dept', name:'Dept', component:()=>import('@/views/dept/DeptList.vue'), meta:{title:'部门管理',icon:'OfficeBuilding',roles:['ADMIN'],adminOnly:true} },
      { path:'operation-log', name:'OperationLog', component:()=>import('@/views/system/OperationLog.vue'), meta:{title:'操作日志',icon:'Document',roles:['ADMIN'],adminOnly:true} },

      // 业务模块（需选公司）
      { path:'product', name:'Product', component:()=>import('@/views/product/ProductList.vue'), meta:{title:'商品管理',icon:'Goods',roles:['ADMIN','SALES','PURCHASER','INVENTORY']} },
      { path:'supplier', name:'Supplier', component:()=>import('@/views/supplier/SupplierList.vue'), meta:{title:'供应商管理',icon:'Van',roles:['ADMIN','PURCHASER']} },
      { path:'customer', name:'Customer', component:()=>import('@/views/customer/CustomerList.vue'), meta:{title:'客户管理',icon:'User',roles:['ADMIN','SALES']} },
      { path:'warehouse', name:'Warehouse', component:()=>import('@/views/warehouse/WarehouseList.vue'), meta:{title:'仓库管理',icon:'House',roles:['ADMIN','INVENTORY']} },
      { path:'purchase', name:'Purchase', component:()=>import('@/views/purchase/PurchaseList.vue'), meta:{title:'采购管理',icon:'ShoppingCart',roles:['ADMIN','PURCHASER']} },
      { path:'sales', name:'Sales', component:()=>import('@/views/sales/SalesList.vue'), meta:{title:'销售管理',icon:'Sell',roles:['ADMIN','SALES']} },
      { path:'inventory', name:'Inventory', component:()=>import('@/views/inventory/InventoryList.vue'), meta:{title:'库存管理',icon:'Box',roles:['ADMIN','INVENTORY']} },
      { path:'stock-check', name:'StockCheck', component:()=>import('@/views/stockCheck/StockCheckList.vue'), meta:{title:'盘点管理',icon:'Checked',roles:['ADMIN','INVENTORY']} },
      { path:'expense', name:'Expense', component:()=>import('@/views/expense/ExpenseList.vue'), meta:{title:'报销管理',icon:'Money',roles:['ADMIN','GM','DEPT_MANAGER','FINANCE','STAFF']} },

      // === 新增：业财 + 合同 + 归档 + 异议 ===
      { path:'invoice', name:'Invoice', component:()=>import('@/views/finance/InvoiceList.vue'), meta:{title:'销售开票',icon:'Tickets',roles:['ADMIN','FINANCE','SALES']} },
      { path:'receipt', name:'Receipt', component:()=>import('@/views/finance/ReceiptList.vue'), meta:{title:'销售回款',icon:'Money',roles:['ADMIN','FINANCE']} },
      { path:'contract-purchase', name:'PurchaseContract', component:()=>import('@/views/contract/PurchaseContractList.vue'), meta:{title:'采购合同',icon:'Document',roles:['ADMIN','PURCHASER']} },
      { path:'contract-sales', name:'SalesContract', component:()=>import('@/views/contract/SalesContractList.vue'), meta:{title:'销售合同',icon:'Document',roles:['ADMIN','SALES']} },
      { path:'archive', name:'Archive', component:()=>import('@/views/archive/ArchiveList.vue'), meta:{title:'业务归档',icon:'FolderChecked',roles:['ADMIN','GM','FINANCE']} },
      { path:'dispute', name:'Dispute', component:()=>import('@/views/dispute/DisputeList.vue'), meta:{title:'质量异议',icon:'Warning',roles:['ADMIN','PURCHASER','SALES','FINANCE']} },
      { path:'report', name:'Report', component:()=>import('@/views/report/ReportCenter.vue'), meta:{title:'统计报表',icon:'DataAnalysis',roles:['ADMIN','GM','DEPT_MANAGER','FINANCE']} },

      { path:'role-permission/:roleId', name:'RolePermission', component:()=>import('@/views/permission/RolePermission.vue'), meta:{title:'角色权限分配',icon:'Lock',roles:['ADMIN'],hideInMenu:true} },
    ]
  }
]

const router = createRouter({ history:createWebHistory(), routes })

router.onError((error) => {
  if (error.message.includes('Failed to fetch dynamically imported module')) ElMessage.error('页面不存在，请刷新后重试')
  else ElMessage.error('页面跳转失败，请重试')
})

const whiteList = ['/login']

router.beforeEach(async (to, from) => {
  document.title = to.meta.title ? `${to.meta.title}-ERP系统` : 'ERP系统'
  const userStore = useUserStore()
  const token = userStore.token || localStorage.getItem('token')

  if (!token && !whiteList.includes(to.path)) return `/login?redirect=${to.path}`
  if (token && to.path === '/login') return '/dashboard'

  if (token && to.path !== '/login') {
    if (!userStore.userInfo) {
      try {
        const stored = JSON.parse(localStorage.getItem('userInfo') || '{}')
        if (stored.userId) { userStore.userInfo = stored; userStore.currentCompanyId = stored.currentCompanyId || null; return true }
        await userStore.getUserInfo(); return true
      } catch (e) { userStore.logout(); ElMessage.error('登录状态已失效，请重新登录'); return `/login?redirect=${to.path}` }
    }
    // 多公司：业务页（非 adminOnly）要求已选公司
    if (to.meta?.adminOnly !== true && to.path !== '/dashboard' && to.path !== '/profile') {
      const roles = userStore.userInfo?.roles || []
      if (!roles.includes('ADMIN') && !userStore.currentCompanyId) {
        ElMessage.warning('请先在左上角选择公司')
        return from.path || '/dashboard'
      }
    }
    if (to.name === 'RolePermission') { const roleId = to.params.roleId; if (!roleId || isNaN(parseInt(roleId))) return '/role' }
    if (to.meta.roles) {
      const userRoles = userStore.userInfo?.roles || []
      if (!userRoles.some(r => to.meta.roles.includes(r))) { ElMessage.error('没有权限访问该页面'); return from.path || '/dashboard' }
    }
    return true
  }
  return true
})

export default router
export { routes }
