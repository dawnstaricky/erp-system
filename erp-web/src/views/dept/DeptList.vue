<template>
  <div class="page-container">
    <div class="toolbar">
      <el-button type="primary" @click="openAddDialog">新增部门</el-button>
    </div>
    <el-table :data="deptList" stripe v-loading="loading" border>
      <el-table-column prop="id" label="ID" width="80" />
      <el-table-column prop="deptName" label="部门名称" />
      <el-table-column prop="description" label="部门描述" show-overflow-tooltip />
      <el-table-column prop="status" label="状态" width="100">
        <template #default="{ row }">
          <el-tag :type="row.status === 1 ? 'success' : 'danger'">
            {{ row.status === 1 ? '正常' : '停用' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="160">
        <template #default="{ row }">
          <el-button link @click="openEditDialog(row)">编辑</el-button>
        </template>
      </el-table-column>
    </el-table>

    <!-- 新增/编辑弹窗 -->
    <el-dialog v-model="dialogVisible" :title="dialogTitle" width="500px">
      <el-form ref="formRef" :model="form" label-width="100px">
        <el-form-item label="部门名称" prop="deptName">
          <el-input v-model="form.deptName" />
        </el-form-item>
        <el-form-item label="部门描述" prop="description">
          <el-input v-model="form.description" type="textarea" rows="3" />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-radio-group v-model="form.status">
            <el-radio :value="1">正常</el-radio>
            <el-radio :value="0">停用</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSubmit">提交</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { getDeptList, addDept, updateDept, getNormalUserList } from '@/api/dept'

const loading = ref(false)
const deptList = ref([])
const userList = ref([]) // 正常用户列表，用于选择经理
const dialogVisible = ref(false)
const dialogTitle = ref('')
const formRef = ref()
const form = ref({
  id: null,
  deptName: '',
  managerId: null,
  description: '',
  status: 1
})

// 加载部门列表，关联经理名称
const loadData = async () => {
  loading.value = true
  try {
    deptList.value = await getDeptList()
    // 查经理名称
    for (const dept of deptList.value) {
      if (dept.managerId) {
        const user = await getUserById(dept.managerId)
        dept.managerName = user.realName
      }
    }
  } finally {
    loading.value = false
  }
}

// 加载正常用户列表
const loadUsers = async () => {
  //userList.value = await getNormalUserList()
}

// 打开新增弹窗
const openAddDialog = () => {
  dialogTitle.value = '新增部门'
  form.value = { id: null, deptName: '', managerId: null, description: '', status: 1 }
  dialogVisible.value = true
}

// 打开编辑弹窗
const openEditDialog = (row) => {
  dialogTitle.value = '编辑部门'
  form.value = { ...row }
  dialogVisible.value = true
}

// 提交表单
const handleSubmit = async () => {
  try {
    if (form.value.id) {
      await updateDept(form.value)
      ElMessage.success('更新成功')
    } else {
      await addDept(form.value)
      ElMessage.success('新增成功')
    }
    dialogVisible.value = false
    loadData()
  } catch (e) {
    ElMessage.error(e.message || '操作失败')
  }
}

onMounted(() => {
  loadData()
  loadUsers()
})
</script>