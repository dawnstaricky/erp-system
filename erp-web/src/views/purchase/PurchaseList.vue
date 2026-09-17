<template>
  <div class="page-container">
    <el-tabs v-model="activeTab">
      <!-- 创建采购单 -->
      <el-tab-pane label="创建采购单" name="create">
        <el-form ref="orderFormRef" :model="orderForm" :rules="orderRules" label-width="100px" style="max-width: 800px;">
          <el-row :gutter="16">
            <el-col :span="12">
              <el-form-item label="供应商" prop="supplierId">
                <el-select v-model="orderForm.supplierId" filterable placeholder="选择供应商" style="width:100%">
                  <el-option v-for="s in suppliers" :key="s.id" :label="s.supplierName" :value="s.id" />
                </el-select>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="仓库" prop="warehouseId">
                <el-select v-model="orderForm.warehouseId" placeholder="选择仓库" style="width:100%">
                  <el-option v-for="w in warehouses" :key="w.id" :label="w.warehouseName" :value="w.id" />
                </el-select>
              </el-form-item>
            </el-col>
          </el-row>
          <el-form-item label="订单日期">
            <el-date-picker v-model="orderForm.orderDate" type="date" value-format="YYYY-MM-DD" style="width:100%" />
          </el-form-item>

          <el-divider>采购明细</el-divider>

          <div v-for="(item, idx) in orderForm.items" :key="idx" class="item-row">
            <el-select v-model="item.productId" filterable placeholder="选择商品" style="width:220px">
              <el-option v-for="p in products" :key="p.id" :label="p.productName" :value="p.id" />
            </el-select>
            <el-input-number v-model="item.quantity" :min="1" placeholder="数量" style="width:130px" />
            <el-input-number v-model="item.price" :precision="2" :min="0" placeholder="单价" style="width:150px" />
            <span class="item-amount">{{ formatMoney(item.quantity * item.price) }}</span>
            <el-button type="danger" circle @click="removeItem(idx)" v-if="orderForm.items.length > 1">
              <el-icon><Delete /></el-icon>
            </el-button>
          </div>
          <el-button @click="addItem"><el-icon><Plus /></el-icon> 添加明细</el-button>

          <el-divider />
          <div class="total-row">
            <span>合计金额：</span>
            <span class="total-amount">{{ formatMoney(totalAmount) }}</span>
          </div>
          <div style="margin-top: 20px;">
            <el-button type="primary" :loading="submitting" @click="handleCreate">创建采购单</el-button>
          </div>
        </el-form>
      </el-tab-pane>

      <!-- Excel导入 -->
      <el-tab-pane label="Excel导入" name="import">
        <el-card>
          <template #header>
            <div style="display:flex; justify-content:space-between; align-items:center;">
              <span>批量导入采购单</span>
              <el-button @click="downloadTemplateFile">
                <el-icon><Download /></el-icon> 下载模板
              </el-button>
            </div>
          </template>
          <el-upload
            drag
            :auto-upload="false"
            :on-change="handleFileChange"
            :limit="1"
            accept=".xlsx,.xls"
            style="max-width:500px; margin:0 auto;"
          >
            <el-icon :size="48" color="#c0c4cc"><Upload /></el-icon>
            <div style="margin-top:10px;">将Excel文件拖到此处，或<em>点击上传</em></div>
            <template #tip>
              <div style="color:#999; font-size:12px; margin-top:8px;">
                支持 .xlsx 格式，第一行是表头，请按模板格式填写
              </div>
            </template>
          </el-upload>
          <div style="text-align:center; margin-top:20px;">
            <el-button type="primary" :loading="importing" :disabled="!selectedFile" @click="handleImport">
              开始导入
            </el-button>
          </div>
        </el-card>

        <!-- 导入结果 -->
        <el-card v-if="importResult" style="margin-top:16px;">
          <el-alert :title="importResult" type="info" :closable="false" show-icon />
        </el-card>

        <!-- 草稿单列表 -->
        <el-card style="margin-top:16px;" v-if="draftList.length > 0">
          <template #header>
            <div style="display:flex; justify-content:space-between; align-items:center;">
              <span>草稿采购单（待入库）</span>
              <el-button type="success" :loading="stockInLoading" @click="handleBatchStockIn">
                <el-icon><Check /></el-icon> 批量入库
              </el-button>
            </div>
          </template>
          <el-table :data="draftList" stripe @selection-change="handleSelectionChange">
            <el-table-column type="selection" width="50" />
            <el-table-column prop="orderNo" label="单号" width="180" />
            <el-table-column prop="totalAmount" label="金额">
              <template #default="{ row }">{{ formatMoney(row.totalAmount) }}</template>
            </el-table-column>
            <el-table-column prop="orderDate" label="日期" width="120" />
            <el-table-column label="操作" width="100">
              <template #default="{ row }">
                <el-button type="primary" link @click="handleSingleStockIn(row)">入库</el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-card>
      </el-tab-pane>
      <!-- 采购订单列表tab -->
      <el-tab-pane label="采购订单列表" name="list">
        <div class="toolbar">
          <el-input v-model="searchForm.orderNo" placeholder="订单编号" clearable @keyup.enter="loadData" />
          <el-button type="primary" @click="loadData">搜索</el-button>
          <el-button @click="resetSearch">重置</el-button>
          <!-- ✅ 新增导出按钮 -->
          <el-button type="success" @click="handleExport" :loading="exportLoading">导出采购单</el-button>
        </div>

        <el-table :data="tableData" stripe v-loading="loading" border>
          <el-table-column prop="id" label="ID" width="80" />
          <el-table-column prop="orderNo" label="订单编号" />
          <el-table-column prop="supplierName" label="供应商" />
          <!-- ✅ 新增采购日期、备注列 -->
          <el-table-column prop="orderDate" label="采购日期" width="120" />
          <el-table-column prop="remark" label="备注" show-overflow-tooltip />
          <el-table-column prop="totalAmount" label="总金额" width="120" />
          <el-table-column prop="status" label="状态" width="100">
            <template #default="{row}">
              <el-tag :type="row.status === 1 ? 'success' : 'warning'">
                {{ row.status === 1 ? '已入库' : '待入库' }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column label="操作" width="120" fixed="right">
            <template #default="{row}">
              <!-- ✅ 改为弹窗查看，和编辑用户逻辑一致 -->
              <el-button type="primary" link @click="openDetailDialog(row)">查看</el-button>
              <el-button 
                v-if="row.status !== 1" 
                type="success" link 
                @click="handleStockIn(row.id)">
                入库
              </el-button>
              <!-- <el-button size="small" @click="downContract(row.id)">下载合同</el-button> -->
            </template>
          </el-table-column>
        </el-table>

        <!-- ✅ 新增采购详情弹窗（无需跳转新页） -->
        <el-dialog v-model="detailVisible" title="采购单详情" width="900px">
          <el-descriptions :column="2" border>
            <el-descriptions-item label="订单编号">{{ detailInfo.orderNo }}</el-descriptions-item>
            <el-descriptions-item label="供应商">{{ detailInfo.supplierName }}</el-descriptions-item>
            <el-descriptions-item label="采购日期">{{ detailInfo.orderDate }}</el-descriptions-item>
            <el-descriptions-item label="状态">
              <el-tag :type="detailInfo.status === 1 ? 'success' : 'warning'">
                {{ detailInfo.status === 1 ? '已入库' : '待入库' }}
              </el-tag>
            </el-descriptions-item>
            <el-descriptions-item label="总金额">{{ detailInfo.totalAmount }}</el-descriptions-item>
            <el-descriptions-item label="备注" :span="2">{{ detailInfo.remark }}</el-descriptions-item>
          </el-descriptions>

          <!-- ✅ 新增采购明细表格（数量/单价，后端已返回） -->
          <div class="sub-title">采购明细</div>
          <el-table :data="detailInfo.items || []" stripe border size="small">
            <el-table-column prop="productName" label="商品名称" />
            <el-table-column prop="spec" label="规格" />
            <el-table-column prop="quantity" label="数量" width="100" />
            <el-table-column prop="price" label="单价" width="120" />
            <el-table-column prop="amount" label="金额" width="120" />
          </el-table>
        </el-dialog>

        <el-pagination
          v-model:current-page="pageNum"
          v-model:page-size="pageSize"
          :total="total"
          :page-sizes="[10,20,50]"
          layout="total, sizes, prev, pager, next, jumper"
          @size-change="loadData"
          @current-change="loadData"
        />
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted, watch } from 'vue'
import { ElMessage } from 'element-plus'
import { Plus, Delete, Download, Upload, Check } from '@element-plus/icons-vue'
import { createPurchase, stockIn, batchStockIn, getDraftList, downloadTemplate, importPurchase, getPurchaseOrderList, getPurchaseOrderDetail, exportPurchaseOrder } from '@/api/purchase'
import { getSupplierList } from '@/api/supplier'
import { getWarehouseList } from '@/api/warehouse'
import { getProductList } from '@/api/product'
import { useRoute, useRouter } from 'vue-router'
//import { saveAs } from 'file-saver'

const route = useRoute()
const router = useRouter()
const activeTab = ref('create')
const submitting = ref(false)
const importing = ref(false)
const stockInLoading = ref(false)
const selectedFile = ref(null)
const importResult = ref('')
const draftList = ref([])
const selectedOrders = ref([])

const suppliers = ref([])
const warehouses = ref([])
const products = ref([])

const loading = ref(false)
const tableData = ref([])
const total = ref(0)
const pageNum = ref(1)
const pageSize = ref(10)
const searchForm = ref({ orderNo: '' })
// ✅ 详情弹窗相关变量
const detailVisible = ref(false)
const detailInfo = ref({})
const exportLoading = ref(false)

const orderFormRef = ref()
const orderForm = reactive({
  supplierId: null,
  warehouseId: null,
  orderDate: new Date().toISOString().slice(0, 10),
  items: [{ productId: null, quantity: 1, price: 0 }]
})

const orderRules = {
  supplierId: [{ required: true, message: '请选择供应商', trigger: 'change' }],
  warehouseId: [{ required: true, message: '请选择仓库', trigger: 'change' }]
}

const totalAmount = computed(() => {
  return orderForm.items.reduce((sum, item) => sum + (item.quantity * item.price || 0), 0)
})

const loadData = async () => {
  loading.value = true
  try {
    const res = await getPurchaseOrderList({
      orderNo: searchForm.value.orderNo,
      pageNum: pageNum.value,
      pageSize: pageSize.value
    })
    tableData.value = res.list || []
    total.value = res.total || 0
  } catch (e) {
    ElMessage.error(e.message || '加载失败')
  } finally {
    loading.value = false
  }
}

// ✅ 打开详情弹窗（替代原来的跳转，后端接口已集成）
const openDetailDialog = async (row) => {
  try {
    const res = await getPurchaseOrderDetail(row.id)
    detailInfo.value = res
    detailVisible.value = true
  } catch (e) {
    ElMessage.error(e.message || '加载详情失败')
  }
}

const downContract = (id) => {
  window.open(`/api/contract/purchase/${id}/download`, '_blank')
}

// ✅ 新增导出功能（对接后端已集成的接口）
const handleExport = async () => {
  if (exportLoading.value) return
  exportLoading.value = true
  try {
    const blob = await exportPurchaseOrder({ orderNo: searchForm.value.orderNo })
    const url = URL.createObjectURL(blob)
    const a = document.createElement('a')
    a.href = url
    a.download = `采购单列表_${new Date().getTime()}.xlsx`
    a.click()
    URL.revokeObjectURL(url)
    ElMessage.success('导出成功')
  } catch (e) {
    ElMessage.error(e.message || '导出失败')
  } finally {
    exportLoading.value = false
  }
}

const resetSearch = () => {
  searchForm.value.orderNo = ''
  loadData() // 重置后重新加载列表
}

const handleStockIn = async (id) => {
  try {
    await stockIn(id)
    ElMessage.success('入库成功')
    loadData()
  } catch (e) {
    ElMessage.error(e.message || '入库失败')
  }
}

function formatMoney(val) {
  if (!val) return '¥0.00'
  return '¥' + Number(val).toLocaleString('zh-CN', { minimumFractionDigits: 2 })
}

function addItem() {
  orderForm.items.push({ productId: null, quantity: 1, price: 0 })
}

function removeItem(idx) {
  orderForm.items.splice(idx, 1)
}

async function handleCreate() {
  await orderFormRef.value.validate()
  submitting.value = true
  try {
    const order = {
      supplierId: orderForm.supplierId,
      warehouseId: orderForm.warehouseId,
      orderDate: orderForm.orderDate,
      remark: '前端创建'
    }
    const items = orderForm.items.map(item => ({
      productId: item.productId,
      quantity: item.quantity,
      price: item.price
    }))
    await createPurchase({ order, items })
    loadDraftList()
    ElMessage.success('采购单创建成功')
    // 重置表单
    orderForm.items = [{ productId: null, quantity: 1, price: 0 }]
  } catch (e) {} finally {
    submitting.value = false
  }
}

function handleFileChange(file) {
  selectedFile.value = file.raw
  importResult.value = ''
}

async function handleImport() {
  if (!selectedFile.value) return
  importing.value = true
  try {
    const res = await importPurchase(selectedFile.value, 1)
    importResult.value = '导入成功'
    ElMessage.success('导入成功')
    selectedFile.value = null
    loadDraftList()
  } catch (e) {
    importResult.value = e.message || '导入失败'
  } finally {
    importing.value = false
  }
}

async function downloadTemplateFile() {
  console.log('[模板下载] 开始执行')
  try {
    console.log('[模板下载] 准备调用 downloadTemplate()')
    const res = await downloadTemplate()
    console.log('[模板下载] 返回结果类型:', typeof res, '是否为Blob:', res instanceof Blob)
    console.log('[模板下载] Blob size:', res.size, 'type:', res.type)
    
    if (!res || res.size === 0) {
      ElMessage.error('下载失败：返回为空')
      return
    }
    
    const url = URL.createObjectURL(res)
    console.log('[模板下载] 创建URL:', url)
    
    const a = document.createElement('a')
    a.href = url
    a.download = '采购单导入模板.xlsx'
    document.body.appendChild(a)
    console.log('[模板下载] 触发点击')
    a.click()
    document.body.removeChild(a)
    URL.revokeObjectURL(url)
    console.log('[模板下载] 完成')
    ElMessage.success('模板下载成功')
  } catch (e) {
    console.error('[模板下载] 异常:', e)
    console.error('[模板下载] 异常响应:', e.response)
    if (e.response?.data instanceof Blob) {
      const reader = new FileReader()
      reader.onload = () => console.error('[模板下载] 错误内容:', reader.result)
      reader.readAsText(e.response.data)
    }
    ElMessage.error(e.message || '模板下载失败')
  }
}

function handleSelectionChange(rows) {
  selectedOrders.value = rows
}

async function handleBatchStockIn() {
  if (selectedOrders.value.length === 0) {
    ElMessage.warning('请先选择要入库的单据')
    return
  }
  stockInLoading.value = true
  try {
    const ids = selectedOrders.value.map(o => o.id)
    await batchStockIn(ids, 1)
    ElMessage.success(`批量入库成功，共${ids.length}笔`)
    loadDraftList()
  } catch (e) {} finally {
    stockInLoading.value = false
  }
}

async function handleSingleStockIn(row) {
  try {
    await stockIn(row.id)
    ElMessage.success(`单号${row.orderNo}入库成功`)
    loadDraftList()
  } catch (e) {}
}

async function loadDraftList() {
  try {
    draftList.value = await getDraftList(1)
  } catch (e) {}
}

onMounted(async () => {
  try {
    const [supData, whData, prodData] = await Promise.all([
      getSupplierList({ pageNum: 1, pageSize: 100 }),
      getWarehouseList({ pageNum: 1, pageSize: 100 }),
      getProductList({ pageNum: 1, pageSize: 100 })
    ])
    suppliers.value = supData.list || []
    warehouses.value = whData.list || []
    products.value = prodData.list || []
    if (route.query.tab === 'list') activeTab.value = 'list'
    if (activeTab.value === 'list') loadData()
  } catch (e) {}
})
watch(activeTab, (val) => val === 'list' && loadData())
</script>

<style scoped>
.page-container { padding: 0; }
.item-row {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 12px;
}
.item-amount {
  min-width: 100px;
  font-weight: bold;
  color: #f56c6c;
}
.total-row {
  font-size: 16px;
  text-align: right;
}
.total-amount {
  font-size: 22px;
  font-weight: bold;
  color: #f56c6c;
  margin-left: 8px;
}
</style>