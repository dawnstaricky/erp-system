<template>
  <div class="page-container">
    <div class="toolbar">
      <el-button type="primary" @click="dialogVisible = true">
        <el-icon><Plus /></el-icon> 新建盘点单
      </el-button>
    </div>

    <el-table :data="tableData" stripe v-loading="loading" border>
      <el-table-column prop="checkNo" label="盘点单号" width="180" />
      <el-table-column prop="productName" label="商品名称" />
      <el-table-column prop="bookQuantity" label="账面数量" width="100" />
      <el-table-column prop="actualQuantity" label="实际数量" width="100" />
      <el-table-column prop="difference" label="差异" width="80">
        <template #default="{ row }">
          <span :style="{ color: row.difference < 0 ? '#f56c6c' : '#67c23a' }">
            {{ row.difference > 0 ? '+' : '' }}{{ row.difference }}
          </span>
        </template>
      </el-table-column>
      <el-table-column prop="status" label="状态" width="80">
        <template #default="{ row }">
          <el-tag :type="row.status === 1 ? 'success' : 'warning'">
            {{ row.status === 1 ? '已审核' : '草稿' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="100">
        <template #default="{ row }">
          <el-button type="primary" link v-if="row.status === 0" @click="handleApprove(row)">审核</el-button>
        </template>
      </el-table-column>
    </el-table>

    <el-dialog v-model="dialogVisible" title="新建盘点单" width="500px">
      <el-form ref="formRef" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="仓库" prop="warehouseId">
          <el-select v-model="form.warehouseId" style="width:100%">
            <el-option v-for="w in warehouses" :key="w.id" :label="w.warehouseName" :value="w.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="商品" prop="productId">
          <el-select v-model="form.productId" filterable style="width:100%">
            <el-option v-for="p in products" :key="p.id" :label="p.productName" :value="p.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="实际数量" prop="actualQuantity">
          <el-input-number v-model="form.actualQuantity" :min="0" style="width:100%" />
        </el-form-item>
        <el-form-item label="原因">
          <el-input v-model="form.reason" type="textarea" :rows="2" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="submitting" @click="handleCreate">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { createCheck, approveCheck, getCheckList } from '@/api/stockCheck'
import { getWarehouseList } from '@/api/warehouse'
import { getProductList } from '@/api/product'

const loading = ref(false)
const tableData = ref([])
const warehouses = ref([])
const products = ref([])
const dialogVisible = ref(false)
const submitting = ref(false)
const formRef = ref()
const form = reactive({
  warehouseId: null,
  productId: null,
  actualQuantity: 0,
  reason: ''
})

const rules = {
  warehouseId: [{ required: true, message: '请选择仓库', trigger: 'change' }],
  productId: [{ required: true, message: '请选择商品', trigger: 'change' }],
  actualQuantity: [{ required: true, message: '请输入实际数量', trigger: 'blur' }]
}

async function loadData() {
  loading.value = true
  try {
    tableData.value = await getCheckList({})
  } catch (e) {
    ElMessage.error(e.message || '加载盘点单失败')
  } finally {
    loading.value = false
  }
}

async function handleCreate() {
  await formRef.value.validate()
  submitting.value = true
  try {
    await createCheck({
      ...form,
      checkDate: new Date().toISOString().slice(0, 10),
      checkerId: 1
    })
    ElMessage.success('盘点单创建成功')
    dialogVisible.value = false
    loadData()
  } catch (e) {} finally {
    submitting.value = false
  }
}

function handleApprove(row) {
  ElMessageBox.confirm(`确认审核盘点单${row.checkNo}？`, '提示', { type: 'warning' })
    .then(async () => {
      await approveCheck(row.id)
      ElMessage.success('审核成功')
      loadData()
    }).catch(() => {})
}

onMounted(async () => {
  try {
    const [wh, prod] = await Promise.all([
      getWarehouseList({ pageNum: 1, pageSize: 100 }),
      getProductList({ pageNum: 1, pageSize: 100 })
    ])
    warehouses.value = wh.list || []
    products.value = prod.list || []
  } catch (e) {}
  loadData()
})
</script>

<style scoped>
.page-container { padding: 0; }
.toolbar { margin-bottom: 16px; }
</style>