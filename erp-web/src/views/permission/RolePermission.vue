<template>
  <div class="page-container">
    <div class="header">
      <div class="title">
        为角色【<span class="role-name">{{ roleName }}</span>】分配权限
      </div>
      <div class="buttons">
        <el-button type="primary" @click="handleSave" v-role="['ADMIN']">保存权限</el-button>
        <el-button @click="goBack">返回</el-button>
      </div>
    </div>

    <div class="content">
      <el-alert
        title="提示：勾选权限后点击保存，权限立即生效。灰色权限为系统内置，不可修改。"
        type="info"
        show-icon
        :closable="false"
        style="margin-bottom: 16px;"
      />
      
      <el-tree
        ref="treeRef"
        node-key="id"
        :data="permissionTree"
        :props="treeProps"
        show-checkbox
        default-expand-all
        highlight-current
        v-loading="loading"
        :default-checked-keys="checkedKeys"
      >
        <template #default="{ node, data }">
          <span class="tree-node">
            <span class="node-label">{{ data.permissionName }}</span>
            <span class="node-code">({{ data.permissionCode }})</span>
            <el-tag size="small" :type="getMethodTagType(data.apiMethod)" class="node-method">
              {{ data.apiMethod }}
            </el-tag>
            <span class="node-path">{{ data.apiPath }}</span>
          </span>
        </template>
      </el-tree>
    </div>
  </div>
</template>

<script setup>
console.log('[RolePermission] 组件JS模块被加载')
import { ref, onMounted   } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { getPermissionList, getRolePermissions, assignRolePermissions, getAllPermissions } from '@/api/permission'

const route = useRoute()
const router = useRouter()
const treeRef = ref()
const loading = ref(false)
const permissionTree = ref([])
const checkedKeys = ref([])

const roleName = ref(route.query.roleName || '')

// 树形配置
const treeProps = {
  children: 'children',
  label: 'permissionName',
  disabled: (data) => !data?.permissionCode ? false : data.permissionCode.startsWith('SYSTEM_')
}

// 获取请求方法标签类型
const getMethodTagType = (method) => {
  const map = {
    'GET': 'success',
    'POST': 'primary',
    'PUT': 'warning',
    'DELETE': 'danger'
  }
  return map[method] || 'info'
}

const loadData = async () => {
  console.log('[RolePermission] loadData执行，rawRoleId:', route.params.roleId)
  const rawRoleId = route.params.roleId
  const parsedRoleId = parseInt(rawRoleId)
  if (!rawRoleId || isNaN(parsedRoleId)) {
    ElMessage.error('角色ID不存在或无效')
    return
  }

  loading.value = true
  try {
    // ✅ 解构：第一个是分页响应，取 .list
    const [resAll, rolePermissions] = await Promise.all([
      getAllPermissions(),           // { list, total }
      getRolePermissions(parsedRoleId) // 假设返回权限对象数组
    ])
    const allPermissions = resAll.list   // ✅ 这才是数组
    checkedKeys.value = rolePermissions.map(p => p.id)
    
    // 你原有树构建逻辑完全保留，无任何修改
    const moduleMap = {}
    allPermissions.forEach(item => {
      const moduleName = item.apiPath.split('/')[1] || 'other'
      if (!moduleMap[moduleName]) {
        moduleMap[moduleName] = {
          id: `module_${moduleName}`,
          permissionName: getModuleDisplayName(moduleName),
          children: [],
          isModule: true
        }
      }
      moduleMap[moduleName].children.push({
        ...item,
        children: []
      })
    })
    
    permissionTree.value = Object.values(moduleMap)
  } catch (e) {
    ElMessage.error(e.message || '加载失败')
  } finally {
    loading.value = false
  }
}

// 获取模块显示名称
const getModuleDisplayName = (module) => {
  const moduleNames = {
    'user': '用户管理',
    'role': '角色管理',
    'permission': '权限管理',
    'warehouse': '仓库管理',
    'purchase': '采购管理',
    'sales': '销售管理',
    'expense': '报销管理',
    'stock-check': '盘点管理',
    'report': '报表管理',
    'other': '其他'
  }
  return moduleNames[module] || module
}

// 保存权限分配
const handleSave = async () => {
  const checkedNodes = treeRef.value.getCheckedNodes(false, true) // 只获取叶子节点
  const checkedKeys = checkedNodes.map(node => node.id).filter(id => typeof id === 'number')
  
  try {
    await assignRolePermissions(route.params.roleId, checkedKeys)
    ElMessage.success('权限分配成功')
    router.back()
  } catch (e) {
    ElMessage.error(e.message || '保存失败')
  }
}

const goBack = () => {
  router.back()
}
console.log('[RolePermission] 组件初始化，当前地址栏params:', route.params, 'query:', route.query)

onMounted(() => {
  // 2. 看onMounted有没有执行
  console.log('[RolePermission] onMounted触发，准备调用loadData')
  loadData()
})
</script>

<style scoped>
.page-container { padding: 20px; }
.header { margin-bottom: 20px; display: flex; justify-content: space-between; align-items: center; }
.title { font-size: 16px; font-weight: bold; }
.role-name { color: #409eff; font-weight: bold; }
.content { background: #fff; padding: 20px; border-radius: 4px; box-shadow: 0 2px 12px rgba(0,0,0,0.1); }
.tree-node { display: flex; align-items: center; gap: 8px; }
.node-label { font-weight: 500; }
.node-code { color: #909399; font-size: 12px; }
.node-method { margin-left: 8px; }
.node-path { color: #606266; font-size: 12px; margin-left: 8px; }
:deep(.el-tree-node__content) { height: 36px; }
</style>