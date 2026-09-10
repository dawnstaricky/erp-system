<template>
  <div class="page-container">
    <div class="toolbar">
      <el-input
        v-model="keyword"
        placeholder="搜索仓库名称/编码/负责人/电话"
        clearable
        style="width: 280px"
        @keyup.enter="loadData"
      />
      <el-button type="primary" @click="loadData">搜索</el-button>
      <el-button @click="resetSearch">重置</el-button>
      <div style="flex: 1"></div>
      <el-button type="primary" @click="openAddDialog">
        <el-icon><Plus /></el-icon> 新增仓库
      </el-button>
    </div>

    <el-table
      :data="tableData"
      stripe
      v-loading="loading"
      border
      :row-class-name="rowClassName"
    >
      <el-table-column prop="id" label="ID" width="60" />
      <el-table-column prop="warehouseCode" label="仓库编码" width="160" />
      <!-- 状态列提前 -->
      <el-table-column prop="status" label="状态" width="90">
        <template #default="{ row }">
          <el-tag :type="row.status === 1 ? 'success' : 'info'">
            {{ row.status === 1 ? '启用' : '已停用' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="warehouseName" label="仓库名称" show-overflow-tooltip />
      <el-table-column prop="address" label="仓库地址" show-overflow-tooltip />
      <el-table-column prop="manager" label="负责人" width="100" />
      <el-table-column prop="phone" label="联系电话" width="140" />
      <el-table-column label="操作" width="160" fixed="right">
        <template #default="{ row }">
          <!-- 正常仓库：编辑 + 删除（停用） -->
          <template v-if="row.status === 1">
            <el-button type="primary" link @click="openEditDialog(row)">编辑</el-button>
            <el-button v-role="['ADMIN']" type="danger" link @click="handleDelete(row)">删除</el-button>
          </template>
          <!-- 已停用仓库：编辑 + 启用 -->
          <template v-else>
            <el-button type="primary" link @click="openEditDialog(row)">编辑</el-button>
            <el-button v-role="['ADMIN']" type="success" link @click="handleEnable(row)">启用</el-button>
          </template>
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

    <!-- 新增/编辑弹窗（无仓库编码输入框） -->
    <el-dialog v-model="dialogVisible" :title="dialogTitle" width="550px" destroy-on-close>
      <el-form ref="formRef" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="仓库名称" prop="warehouseName">
          <el-input v-model="form.warehouseName" placeholder="请输入仓库名称" />
        </el-form-item>
        <el-form-item label="仓库地址">
          <el-input v-model="form.address" type="textarea" :rows="2" placeholder="请输入仓库地址" />
        </el-form-item>
        <el-form-item label="负责人">
          <el-input v-model="form.manager" placeholder="请输入负责人姓名" />
        </el-form-item>
        <el-form-item label="联系电话" prop="phone">
          <el-input v-model="form.phone" placeholder="请输入联系电话" />
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
import { Plus } from '@element-plus/icons-vue'
import { getWarehouseList, addWarehouse, updateWarehouse } from '@/api/warehouse'

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
  warehouseName: '',
  address: '',
  manager: '',
  phone: '',
  status: 1
})

const rules = {
  warehouseName: [{ required: true, message: '请输入仓库名称', trigger: 'blur' }],
  phone: [{ pattern: /^1[3-9]\d{9}$/, message: '手机号格式不正确', trigger: 'blur' }]
}

/* ========== 数据加载 ========== */

async function loadData() {
  loading.value = true
  try {
    const data = await getWarehouseList({
      keyword: keyword.value,
      pageNum: pageNum.value,
      pageSize: pageSize.value
    })
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

/* ========== 弹窗 ========== */

function openAddDialog() {
  dialogTitle.value = '新增仓库'
  Object.assign(form, {
    id: null,
    warehouseName: '',
    address: '',
    manager: '',
    phone: '',
    status: 1
  })
  dialogVisible.value = true
}

function openEditDialog(row) {
  dialogTitle.value = '编辑仓库'
  Object.assign(form, row)
  dialogVisible.value = true
}

async function handleSubmit() {
  await formRef.value.validate()
  submitting.value = true
  try {
    if (form.id) {
      await updateWarehouse(form)
      ElMessage.success('更新仓库成功')
    } else {
      await addWarehouse(form)
      ElMessage.success('新增仓库成功，编码已自动生成')
    }
    dialogVisible.value = false
    loadData()
  } catch (e) {
    ElMessage.error(e.message || '操作失败')
  } finally {
    submitting.value = false
  }
}

/* ========== 删除（停用） / 启用 ========== */

function handleDelete(row) {
  ElMessageBox.confirm(`确定停用仓库"${row.warehouseName}"吗？`, '提示', { type: 'warning' })
    .then(async () => {
      // 调停用接口（复用 update，把 status 置 0）
      await updateWarehouse({ id: row.id, status: 0 })
      ElMessage.success('仓库已停用')
      loadData()
    })
    .catch(() => {})
}

function handleEnable(row) {
  ElMessageBox.confirm(`确定重新启用仓库"${row.warehouseName}"吗？`, '提示', { type: 'warning' })
    .then(async () => {
      await updateWarehouse({ id: row.id, status: 1 })
      ElMessage.success('仓库已启用')
      loadData()
    })
    .catch(() => {})
}

/* ========== 表格样式：停用行加删除线 + 置灰 ========== */

function rowClassName({ row }) {
  return row.status === 0 ? 'row-disabled' : ''
}

onMounted(loadData)
</script>

<style scoped>
.page-container { padding: 0; }
.toolbar { display: flex; align-items: center; gap: 10px; margin-bottom: 16px; }

/* 停用行：删除线 + 文字置灰 */
:global(.row-disabled td) {
  text-decoration: line-through;
  color: #aaa;
  background-color: #fafafa;
}
</style>