<template>
  <div class="page-container">
    <div class="toolbar">
      <el-button type="primary" @click="openAddDialog" v-role="['ADMIN']">
        <el-icon><Plus /></el-icon> 新增角色
      </el-button>
      <el-input v-model="searchForm.roleName" placeholder="角色名称" clearable style="width:150px" @keyup.enter="loadData" />
      <el-input v-model="searchForm.roleCode" placeholder="角色编码" clearable style="width:150px;margin:0 10px" @keyup.enter="loadData" />
      <el-button type="primary" @click="loadData">搜索</el-button>
      <el-button @click="resetSearch">重置</el-button>
    </div>

    <el-table :data="tableData" stripe v-loading="loading" border>
      <el-table-column prop="id" label="ID" width="80" />
      <el-table-column prop="roleName" label="角色名称" />
      <el-table-column prop="roleCode" label="角色编码" />
      <el-table-column prop="description" label="角色描述" />
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
          <el-button type="warning" link @click="openAssignPermission(row)" v-role="['ADMIN']">分配权限</el-button>
        </template>
      </el-table-column>
    </el-table>
    <el-pagination
      v-model:current-page="pageNum"
      v-model:page-size="pageSize"
      :total="total"
      :page-sizes="[10, 20, 50]"
      layout="total, sizes, prev, pager, next, jumper"
      style="margin-top:16px;justify-content:flex-end"
      @size-change="loadData"
      @current-change="loadData"
    />
  

  <!-- 新增/编辑弹窗 -->
  <el-dialog v-model="dialogVisible" :title="dialogTitle" width="500px">
    <el-form ref="formRef" :model="form" :rules="rules" label-width="100px">
      <el-form-item label="角色名称" prop="roleName">
        <el-input v-model="form.roleName" placeholder="请输入角色名称" />
      </el-form-item>

      <el-form-item label="角色编码" prop="roleCode">
        <el-input 
          v-model="form.roleCode" 
          placeholder="请输入角色编码（如：CUSTOM_ROLE）" 
          :disabled="!!form.id"  
        />
      </el-form-item>
      <el-form-item label="角色描述">
        <el-input v-model="form.description" type="textarea" rows="3" placeholder="请输入角色描述" />
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
import { getRoleList, addRole, updateRole, deleteRole } from '@/api/role'
import { useRoute, useRouter } from 'vue-router'

const router = useRouter()
const loading = ref(false)
const tableData = ref([])
const dialogVisible = ref(false)
const dialogTitle = ref('')
const formRef = ref()

const total = ref(0) // 自己定义total，解决报错
const pageNum = ref(1)
const pageSize = ref(10)
const searchForm = ref({ roleName: '', roleCode: '' })
const form = ref({ id: null, roleName: '', roleCode: '', description: '', status: 1 })
const rules = {
  roleName: [{ required: true, message: '请输入角色名称', trigger: 'blur' }],
  roleCode: [{ required: true, message: '请选择角色编码', trigger: 'change' }]
}

const loadData = async () => {
  loading.value = true
  try {
    const res = await getRoleList({
      pageNum: pageNum.value,
      pageSize: pageSize.value,
      roleName: searchForm.value.roleName,
      roleCode: searchForm.value.roleCode
    })
    // 你的RoleController返回PageInfo，直接取list和total
    tableData.value = res.list || []
    total.value = res.total || 0
  } catch (e) {
    ElMessage.error(e.message || '加载失败')
  } finally {
    loading.value = false
  }
}

const resetSearch = () => {
  searchForm.value = { roleName: '', roleCode: '' }
  loadData()
}

// 新增弹窗
const openAddDialog = () => {
  dialogTitle.value = '新增角色'
  form.value = { id: null, roleName: '', roleCode: '', description: '', status: 1 }
  dialogVisible.value = true
}

// 编辑弹窗
const openEditDialog = (row) => {
  dialogTitle.value = '编辑角色'
  form.value = { ...row }
  dialogVisible.value = true
}

// 提交表单
const handleSubmit = async () => {
  await formRef.value.validate()
  try {
    if (form.value.id) {
      await updateRole(form.value)
      ElMessage.success('更新成功')
    } else {
      await addRole(form.value)
      ElMessage.success('新增成功')
    }
    dialogVisible.value = false
    loadData()
  } catch (e) {
    ElMessage.error(e.message || '操作失败')
  }
}

// 删除角色
const handleDelete = (row) => {
  ElMessageBox.confirm(`确定删除角色"${row.roleName}"吗？`, '提示', { type: 'warning' })
    .then(async () => {
      await deleteRole(row.id)
      ElMessage.success('删除成功')
      loadData()
    })
}

const openAssignPermission = (row) => {
  router.push({
    name: 'RolePermission',
    params: { roleId: row.id },
    query: { roleName: row.roleName }
  })
}

onMounted(loadData)
</script>

<style scoped>
.page-container { padding: 20px; }
.toolbar { margin-bottom: 16px; }
</style>