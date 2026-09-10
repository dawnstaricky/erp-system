<template>
  <div class="page-container">
    <div class="toolbar">
      <el-input v-model="keyword" placeholder="搜索供应商" clearable style="width:220px" @keyup.enter="loadData" />
      <el-button type="primary" @click="loadData">搜索</el-button>
      <div style="flex:1"></div>
      <el-button type="primary" @click="openAdd"><el-icon><Plus /></el-icon> 新增供应商</el-button>
    </div>
    <el-table :data="tableData" stripe v-loading="loading" border>
      <el-table-column prop="id" label="编码" width="120" />
      <el-table-column prop="supplierName" label="名称" />
      <el-table-column prop="contactPerson" label="联系人" width="100" />
      <el-table-column prop="phone" label="电话" width="140" />
      <el-table-column prop="level" label="等级" width="80" />
      <el-table-column prop="status" label="状态" width="80">
        <template #default="{ row }">
          <el-tag :type="row.status === 1 ? 'success' : 'danger'">
            {{ row.status === 1 ? '启用' : '停用' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="150">
        <template #default="{ row }">
          <el-button link @click="openEdit(row)">编辑</el-button>
          <el-button type="danger" link @click="handleDelete(row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    <el-pagination v-model:current-page="pageNum" v-model:page-size="pageSize"
      :total="total" :page-sizes="[10,20,50]" layout="total, sizes, prev, pager, next"
      style="margin-top:16px; justify-content:flex-end;" @size-change="loadData" @current-change="loadData" />

    <el-dialog v-model="dialogVisible" :title="dialogTitle" width="500px">
      <el-form ref="formRef" :model="form" label-width="100px">
        <el-form-item label="供应商名称" required><el-input v-model="form.supplierName" /></el-form-item>
        <el-form-item label="联系人"><el-input v-model="form.contactPerson" /></el-form-item>
        <el-form-item label="电话"><el-input v-model="form.phone" /></el-form-item>
        <el-form-item label="邮箱"><el-input v-model="form.email" /></el-form-item>
        <el-form-item label="地址"><el-input v-model="form.address" /></el-form-item>
        <el-form-item label="等级">
          <el-select v-model="form.level" style="width:100%">
            <el-option label="普通" value="普通" />
            <el-option label="VIP" value="VIP" />
            <el-option label="战略" value="战略" />
          </el-select>
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
import { getSupplierList, addSupplier, updateSupplier, deleteSupplier } from '@/api/supplier'

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
const form = reactive({ id: null, supplierName: '', contactPerson: '', phone: '', email: '', address: '', level: '普通', status: 1 })

async function loadData() {
  loading.value = true
  try {
    const data = await getSupplierList({ pageNum: pageNum.value, pageSize: pageSize.value, keyword: keyword.value })
    tableData.value = data.list || []
    total.value = data.total || 0
  } catch (e) {} finally { loading.value = false }
}

function openAdd() {
  dialogTitle.value = '新增供应商'
  Object.assign(form, { id: null, supplierName: '', contactPerson: '', phone: '', email: '', address: '', level: '普通', status: 1 })
  dialogVisible.value = true
}

function openEdit(row) {
  dialogTitle.value = '编辑供应商'
  Object.assign(form, row)
  dialogVisible.value = true
}

async function handleSubmit() {
  submitting.value = true
  try {
    if (form.id) await updateSupplier(form); else await addSupplier(form)
    ElMessage.success('保存成功')
    dialogVisible.value = false
    loadData()
  } catch (e) {} finally { submitting.value = false }
}

function handleDelete(row) {
  ElMessageBox.confirm(`确定删除"${row.supplierName}"？`, '提示', { type: 'warning' })
    .then(async () => { await deleteSupplier(row.id); ElMessage.success('删除成功'); loadData() })
    .catch(() => {})
}

onMounted(loadData)
</script>

<style scoped>
.page-container { padding: 0; }
.toolbar { display: flex; align-items: center; gap: 10px; margin-bottom: 16px; }
</style>