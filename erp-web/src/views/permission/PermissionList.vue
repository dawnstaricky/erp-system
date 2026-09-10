<template>
  <div class="page-container">
    <div class="toolbar">
      <el-button type="primary" @click="openAddDialog" v-role="['ADMIN']">
        <el-icon><Plus /></el-icon> 新增权限
      </el-button>
    </div>

    <el-table :data="tableData" stripe v-loading="loading" border>
      <el-table-column prop="id" label="ID" width="80" />
      <el-table-column prop="permissionName" label="权限名称" />
      <el-table-column prop="permissionCode" label="权限编码" />
      <el-table-column prop="apiPath" label="接口路径" />
      <el-table-column prop="apiMethod" label="请求方法" width="100">
        <template #default="{row}">
          <el-tag :type="getMethodTagType(row.apiMethod)">{{ row.apiMethod }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="description" label="描述" />
      <el-table-column prop="status" label="状态" width="100">
        <template #default="{row}">
          <el-tag :type="row.status === 1 ? 'success' : 'danger'">
            {{ row.status === 1 ? '启用' : '禁用' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="180" fixed="right">
        <template #default="{row}">
          <el-button type="primary" link @click="openEditDialog(row)" v-role="['ADMIN']">编辑</el-button>
          <el-button type="danger" link @click="handleDelete(row)" v-role="['ADMIN']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
  

  <el-pagination v-model:current-page="pageNum" v-model:page-size="pageSize"
      :total="total" :page-sizes="[10,20,50]" layout="total, sizes, prev, pager, next"
      style="margin-top:16px; justify-content:flex-end;" @size-change="loadData" @current-change="loadData" />
  

  <!-- 新增/编辑弹窗 -->
  <el-dialog v-model="dialogVisible" :title="dialogTitle" width="500px">
    <el-form ref="formRef" :model="form" :rules="rules" label-width="100px">
      <el-form-item label="权限名称" prop="permissionName">
        <el-input v-model="form.permissionName" placeholder="请输入权限名称" />
      </el-form-item>
      <el-form-item label="权限编码" prop="permissionCode">
        <el-input v-model="form.permissionCode" placeholder="请输入权限编码，如：USER_ADD" />
      </el-form-item>
      <el-form-item label="接口路径" prop="apiPath">
        <el-input v-model="form.apiPath" placeholder="请输入接口路径，如：/user/add" />
      </el-form-item>
      <el-form-item label="请求方法" prop="apiMethod">
        <el-select v-model="form.apiMethod" placeholder="请选择请求方法">
          <el-option label="GET" value="GET" />
          <el-option label="POST" value="POST" />
          <el-option label="PUT" value="PUT" />
          <el-option label="DELETE" value="DELETE" />
        </el-select>
      </el-form-item>
      <el-form-item label="描述">
        <el-input v-model="form.description" type="textarea" rows="3" placeholder="请输入描述" />
      </el-form-item>
      <el-form-item label="状态">
        <el-switch v-model="form.status" :active-value="1" :inactive-value="0" />
      </el-form-item>
    </el-form>
    <template #footer>
      <el-button @click="dialogVisible = false">取消</el-button>
      <el-button type="primary" @click="handleSubmit">确定</el-button>
    </template>
  </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getPermissionList, addPermission, updatePermission, deletePermission } from '@/api/permission'

const loading = ref(false)
const dialogVisible = ref(false)
const dialogTitle = ref('')
const formRef = ref()

const tableData = ref([])
const total = ref(0)
const pageNum = ref(1)
const pageSize = ref(10)
const searchForm = ref({ permissionName: '', apiPath: '' })

const loadData = async () => {
  loading.value = true
  try {
    const res = await getPermissionList({
      pageNum: pageNum.value,
      pageSize: pageSize.value,
      permissionName: searchForm.value.permissionName,
      apiPath: searchForm.value.apiPath
    })
    tableData.value = res.list || []
    total.value = res.total || 0
  } catch (e) {
    ElMessage.error(e.message || '加载失败')
  } finally {
    loading.value = false
  }
}

const resetSearch = () => {
  searchForm.value = { permissionName: '', apiPath: '' }
  loadData()
}

const form = ref({
  id: null,
  permissionName: '',
  permissionCode: '',
  apiPath: '',
  apiMethod: 'GET',
  description: '',
  status: 1
})

const rules = {
  permissionName: [{ required: true, message: '请输入权限名称', trigger: 'blur' }],
  permissionCode: [{ required: true, message: '请输入权限编码', trigger: 'blur' }],
  apiPath: [{ required: true, message: '请输入接口路径', trigger: 'blur' }],
  apiMethod: [{ required: true, message: '请选择请求方法', trigger: 'change' }]
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

// 新增弹窗
const openAddDialog = () => {
  dialogTitle.value = '新增权限'
  form.value = { id: null, permissionName: '', permissionCode: '', apiPath: '', apiMethod: 'GET', description: '', status: 1 }
  dialogVisible.value = true
}

// 编辑弹窗
const openEditDialog = (row) => {
  dialogTitle.value = '编辑权限'
  form.value = { ...row }
  dialogVisible.value = true
}

// 提交表单
const handleSubmit = async () => {
  await formRef.value.validate()
  try {
    if (form.value.id) {
      await updatePermission(form.value)
      ElMessage.success('更新成功')
    } else {
      await addPermission(form.value)
      ElMessage.success('新增成功')
    }
    dialogVisible.value = false
    loadData()
  } catch (e) {
    ElMessage.error(e.message || '操作失败')
  }
}

// 删除权限
const handleDelete = (row) => {
  ElMessageBox.confirm(`确定删除权限"${row.permissionName}"吗？`, '提示', { type: 'warning' })
    .then(async () => {
      await deletePermission(row.id)
      ElMessage.success('删除成功')
      loadData()
    })
}

onMounted(loadData)
</script>

<style scoped>
.page-container { padding: 20px; }
.toolbar { margin-bottom: 16px; }
</style>