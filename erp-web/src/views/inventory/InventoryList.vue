<template>
  <div class="page-container">
    <div class="toolbar">
      <el-select v-model="warehouseId" placeholder="选择仓库" clearable style="width:180px" @change="loadData">
        <el-option v-for="w in warehouses" :key="w.id" :label="w.warehouseName" :value="w.id" />
      </el-select>
      <el-input v-model="keyword" placeholder="搜索商品" clearable style="width:220px" @keyup.enter="loadData" />
      <el-button type="primary" @click="loadData">搜索</el-button>
      <div style="flex:1"></div>
      <el-button type="primary" @click="handlePreviewCheck" :disabled="!warehouseId">在线预览盘点表</el-button>
      <el-button @click="handleExportCheck"><el-icon><Download /></el-icon> 导出盘点表</el-button>
      <el-button type="warning" @click="handlePreviewFlow" :disabled="!warehouseId">在线预览流水</el-button>
      <el-button @click="handleExportFlow"><el-icon><Download /></el-icon> 导出流水</el-button>
    </div>

    <el-table :data="tableData" stripe v-loading="loading" border>
      <el-table-column prop="productName" label="商品名称" show-overflow-tooltip />
      <el-table-column prop="skuCode" label="SKU编码" width="160" />
      <el-table-column prop="spec" label="规格" width="100" />
      <el-table-column prop="quantity" label="库存数量" width="100" />
      <el-table-column prop="costPrice" label="成本价" width="100">
        <template #default="{ row }">{{ formatMoney(row.costPrice) }}</template>
      </el-table-column>
      <el-table-column label="库存金额" width="120">
        <template #default="{ row }">{{ formatMoney(row.costPrice * row.quantity) }}</template>
      </el-table-column>
      <el-table-column label="预警" width="80">
        <template #default="{ row }">
          <el-tag type="danger" v-if="row.minStock && row.quantity < row.minStock">缺货</el-tag>
          <el-tag type="success" v-else>正常</el-tag>
        </template>
      </el-table-column>
    </el-table>
    <!-- ✅ 新增预览弹窗（完整界面代码） -->
    <el-dialog v-model="previewVisible" :title="previewTitle" width="80%">
      <div class="preview-tips">提示：可直接打印本页面，无需导出文件</div>
      <iframe :src="previewUrl" style="width:100%;height:600px;border:none"></iframe>
      <template #footer>
        <el-button @click="previewVisible = false">关闭</el-button>
        <el-button type="primary" @click="handlePrint">打印</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<el-pagination v-model:current-page="pageNum" v-model:page-size="pageSize"
      :total="total" :page-sizes="[10,20,50]" layout="total, sizes, prev, pager, next"
      style="margin-top:16px; justify-content:flex-end;" @size-change="loadData" @current-change="loadData" />

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { getInventoryList, exportForCheck, exportFlow, previewInventory } from '@/api/inventory'
import { getWarehouseList } from '@/api/warehouse'

const loading = ref(false)
//const tableData = ref([])
const warehouseId = ref(null)
const keyword = ref('')
const warehouses = ref([])
const tableData = ref([])
const total = ref(0)
const pageNum = ref(1)
const pageSize = ref(10)
const searchForm = ref({ warehouseId: '', keyword: '' })

const previewVisible = ref(false)
const previewUrl = ref('')
const previewTitle = ref('')
const exportLoading = ref(false)
const flowExportLoading = ref(false)

// 加载仓库列表（完全对齐你现有的onMounted逻辑）
const loadWarehouses = async () => {
  try {
    const data = await getWarehouseList({ pageNum: 1, pageSize: 100 })
    warehouses.value = data.list || []
    // 默认选中第一个仓库
    if (warehouses.value.length > 0) {
      warehouseId.value = warehouses.value[0].id
    }
  } catch (e) {
    ElMessage.error(e.message || '加载仓库失败')
  }
}

const loadData = async () => {
  loading.value = true
  try {
    const res = await getInventoryList({
      pageNum: pageNum.value,
      pageSize: pageSize.value,
      warehouseId: warehouseId.value, keyword: keyword.value
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
  searchForm.value = { warehouseId: '', keyword: '' }
  loadData()
}

// ✅ 预览盘点表，用request自动带token，解决401
const handlePreviewCheck = async () => {
  if (!warehouseId.value) {
    ElMessage.warning('请先选择仓库')
    return
  }
  previewTitle.value = '库存盘点表预览'
  previewVisible.value = true
  try {
    const blob = await exportForCheck({
      warehouseId: warehouseId.value,
      startTime: null,
      endTime: null,
      productId: null
    })
    previewUrl.value = URL.createObjectURL(blob)
  } catch (e) {
    ElMessage.error(e.message || '预览失败')
    previewVisible.value = false
  }
}

// ✅ 预览流水，逻辑同盘点表
const handlePreviewFlow = async () => {
  if (!warehouseId.value) {
    ElMessage.warning('请先选择仓库')
    return
  }
  previewTitle.value = '库存流水预览'
  previewVisible.value = true
  try {
    const blob = await exportFlow({
      warehouseId: warehouseId.value,
      startTime: null,
      endTime: null,
      productId: null
    })
    previewUrl.value = URL.createObjectURL(blob)
  } catch (e) {
    ElMessage.error(e.message || '预览失败')
    previewVisible.value = false
  }
}

// ✅ 新增打印功能
const handlePrint = () => {
  const iframe = document.querySelector('iframe')
  iframe.contentWindow.print()
}

function formatMoney(val) {
  if (!val) return '¥0.00'
  return '¥' + Number(val).toLocaleString('zh-CN', { minimumFractionDigits: 2 })
}

//async function loadData() {
//  loading.value = true
//  try {
//    const data = await getInventoryList({ warehouseId: warehouseId.value, keyword: keyword.value })
//    tableData.value = data.list || []
//  } catch (e) {} finally {
//    loading.value = false
//  }
//}

async function handleExportCheck() {
  if (!warehouseId.value) {
    ElMessage.warning('请先选择仓库')
    return
  }
  try {
    const blob = await exportForCheck({ warehouseId: warehouseId.value })
    const url = URL.createObjectURL(blob)
    const a = document.createElement('a')
    a.href = url
    a.download = '库存盘点表.xlsx'
    a.click()
    URL.revokeObjectURL(url)
    ElMessage.success('导出成功')
  } catch (e) {}
}

async function handleExportFlow() {
  if (!warehouseId.value) {
    ElMessage.warning('请先选择仓库')
    return
  }
  try {
    const blob = await exportFlow({ warehouseId: warehouseId.value })
    const url = URL.createObjectURL(blob)
    const a = document.createElement('a')
    a.href = url
    a.download = '库存流水.xlsx'
    a.click()
    URL.revokeObjectURL(url)
    ElMessage.success('导出成功')
  } catch (e) {}
}

onMounted(async () => {
  try {
    const data = await getWarehouseList({ pageNum: 1, pageSize: 100 })
    warehouses.value = data.list || []
  } catch (e) {}
  loadData()
})
</script>

<style scoped>
.page-container { padding: 0; }
.toolbar { display: flex; align-items: center; gap: 10px; margin-bottom: 16px; }
/* ✅ 新增附件样式 */
.attachment-list { margin: 10px 0; }
.attachment-item { margin-bottom: 8px; }
.no-attachment { color: #999; font-size: 12px; margin: 10px 0; }
.no-preview { text-align: center; color: #999; padding: 40px 0; }
</style>