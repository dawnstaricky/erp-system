<template>
  <div class="page-container">
    <div class="toolbar">
      <el-input
        v-model="keyword"
        placeholder="搜索客户名称/联系人/电话"
        clearable
        style="width: 280px"
        @keyup.enter="loadData"
      />
      <el-button type="primary" @click="loadData">搜索</el-button>
      <el-button @click="resetSearch">重置</el-button>
      <div style="flex: 1"></div>
      <el-button type="primary" @click="openAddDialog">
        <el-icon><Plus /></el-icon> 新增客户
      </el-button>
    </div>

    <el-table :data="tableData" stripe v-loading="loading" border>
      <el-table-column prop="id" label="ID" width="60" />
      <el-table-column prop="id" label="客户编码" width="140" />
      <el-table-column prop="customerName" label="客户名称" show-overflow-tooltip />
      <el-table-column prop="contactPerson" label="联系人" width="100" />
      <el-table-column prop="phone" label="电话" width="140" />
      <el-table-column prop="email" label="邮箱" show-overflow-tooltip />
      <el-table-column prop="address" label="地址" show-overflow-tooltip />
      <el-table-column prop="level" label="客户等级" width="100">
        <template #default="{ row }">
          <el-tag :type="levelType(row.level)">{{ row.level }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="status" label="状态" width="80">
        <template #default="{ row }">
          <el-tag :type="row.status === 1 ? 'success' : 'danger'">
            {{ row.status === 1 ? '启用' : '停用' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="150" fixed="right">
        <template #default="{ row }">
          <el-button type="primary" link @click="openEditDialog(row)">编辑</el-button>
          <el-button type="danger" link @click="handleDelete(row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <el-pagination
      v-model:current-page="pageNum"
      v-model:page-size="pageSize"
      :total="total"
      :page-sizes="[10, 20, 50]"
      layout="total, sizes, prev, pager, next, jumper"
      style="margin-top: 16px; justify-content: flex-end"
      @size-change="loadData"
      @current-change="loadData"
    />

    <!-- 新增/编辑弹窗 -->
    <el-dialog v-model="dialogVisible" :title="dialogTitle" width="550px" destroy-on-close>
      <el-form ref="formRef" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="客户名称" prop="customerName">
          <el-input v-model="form.customerName" placeholder="请输入客户名称" />
        </el-form-item>
        <el-form-item label="联系人">
          <el-input v-model="form.contactPerson" placeholder="请输入联系人姓名" />
        </el-form-item>
        <el-form-item label="联系电话" prop="phone">
          <el-input v-model="form.phone" placeholder="请输入联系电话" />
        </el-form-item>
        <el-form-item label="邮箱">
          <el-input v-model="form.email" placeholder="请输入邮箱" />
        </el-form-item>
        <el-form-item label="联系地址">
          <el-input v-model="form.address" type="textarea" :rows="2" placeholder="请输入联系地址" />
        </el-form-item>
        <el-form-item label="客户等级">
          <el-select v-model="form.level" placeholder="请选择客户等级" style="width: 100%">
            <el-option label="普通客户" value="普通" />
            <el-option label="VIP客户" value="VIP" />
            <el-option label="战略客户" value="战略" />
          </el-select>
        </el-form-item>
        <el-form-item label="状态" v-if="form.id !== null">
          <el-switch v-model="form.status" :active-value="1" :inactive-value="0" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="submitting" @click="handleSubmit">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getCustomerList, addCustomer, updateCustomer, deleteCustomer } from '@/api/customer'

const loading = ref(false)
const tableData = ref([])
const total = ref(0)
const pageNum = ref(1)
const pageSize = ref(10)
const keyword = ref('')
const dialogVisible = ref(false)
const dialogTitle = ref('')
const submitting = ref(false)
const formRef = ref()
const form = reactive({
  id: null,
  customerName: '',
  contactPerson: '',
  phone: '',
  email: '',
  address: '',
  level: '普通',
  status: 1
})

const rules = {
  customerName: [{ required: true, message: '请输入客户名称', trigger: 'blur' }],
  phone: [{ pattern: /^1[3-9]\d{9}$/, message: '手机号格式不正确', trigger: 'blur' }],
  email: [{ type: 'email', message: '邮箱格式不正确', trigger: 'blur' }]
}

function levelType(level) {
  const map = { '普通': 'info', 'VIP': 'warning', '战略': 'danger' }
  return map[level] || 'info'
}

async function loadData() {
  loading.value = true
  try {
    const data = await getCustomerList({ pageNum: pageNum.value, pageSize: pageSize.value, keyword: keyword.value })
    tableData.value = data.list || []
    total.value = data.total || 0
  } catch (e) {
    ElMessage.error(e.message || '加载数据失败')
  } finally {
    loading.value = false
  }
}

function resetSearch() {
  keyword.value = ''
  pageNum.value = 1
  loadData()
}

function openAddDialog() {
  dialogTitle.value = '新增客户'
  Object.assign(form, { id: null, customerName: '', contactPerson: '', phone: '', email: '', address: '', level: '普通', status: 1 })
  dialogVisible.value = true
}

function openEditDialog(row) {
  dialogTitle.value = '编辑客户'
  Object.assign(form, row)
  dialogVisible.value = true
}

async function handleSubmit() {
  await formRef.value.validate()
  submitting.value = true
  try {
    if (form.id) {
      await updateCustomer(form)
      ElMessage.success('更新客户成功')
    } else {
      await addCustomer(form)
      ElMessage.success('新增客户成功')
    }
    dialogVisible.value = false
    loadData()
  } catch (e) {
    ElMessage.error(e.message || '操作失败')
  } finally {
    submitting.value = false
  }
}

function handleDelete(row) {
  ElMessageBox.confirm(`确定删除客户"${row.customerName}"吗？`, '提示', { type: 'warning' })
    .then(async () => {
      await deleteCustomer(row.id)
      ElMessage.success('删除成功')
      loadData()
    })
    .catch(() => {})
}

onMounted(loadData)
</script>

<style scoped>
.page-container { padding: 0; }
.toolbar { display: flex; align-items: center; gap: 10px; margin-bottom: 16px; }
</style>