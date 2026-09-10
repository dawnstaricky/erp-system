<template>
  <div class="page-container">
    <el-tabs v-model="activeTab">
      <!-- 创建销售单 -->
      <el-tab-pane label="创建销售单" name="create">
        <el-form ref="orderFormRef" :model="orderForm" :rules="orderRules" label-width="100px" style="max-width: 800px">
          <el-row :gutter="16">
            <el-col :span="12">
              <el-form-item label="客户" prop="customerId">
                <el-select v-model="orderForm.customerId" filterable placeholder="选择客户" style="width: 100%">
                  <el-option v-for="c in customers" :key="c.id" :label="c.customerName" :value="c.id" />
                </el-select>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="仓库" prop="warehouseId">
                <el-select v-model="orderForm.warehouseId" placeholder="选择仓库" style="width: 100%">
                  <el-option v-for="w in warehouses" :key="w.id" :label="w.warehouseName" :value="w.id" />
                </el-select>
              </el-form-item>
            </el-col>
          </el-row>
          <el-form-item label="订单日期">
            <el-date-picker v-model="orderForm.orderDate" type="date" value-format="YYYY-MM-DD" style="width: 100%" />
          </el-form-item>

          <el-divider>销售明细</el-divider>

          <div v-for="(item, idx) in orderForm.items" :key="idx" class="item-row">
            <el-select v-model="item.productId" filterable placeholder="选择商品" style="width: 220px">
              <el-option v-for="p in products" :key="p.id" :label="`${p.productName}(${p.skuCode})`" :value="p.id" />
            </el-select>
            <el-input-number v-model="item.quantity" :min="1" placeholder="数量" style="width: 130px" />
            <el-input-number v-model="item.price" :precision="2" :min="0" placeholder="单价" style="width: 150px" />
            <span class="item-amount">{{ formatMoney(item.quantity * item.price) }}</span>
            <el-button type="danger" circle @click="removeItem(idx)" v-if="orderForm.items.length > 1">
              <el-icon><Delete /></el-icon>
            </el-button>
          </div>
          <el-button @click="addItem">
            <el-icon><Plus /></el-icon> 添加明细
          </el-button>

          <el-divider />
          <div class="total-row">
            <span>合计金额：</span>
            <span class="total-amount">{{ formatMoney(totalAmount) }}</span>
          </div>
          <div style="margin-top: 20px">
            <el-button type="primary" :loading="submitting" @click="handleCreate">创建销售单</el-button>
          </div>
        </el-form>
      </el-tab-pane>

      <!-- Excel导入 -->
      <el-tab-pane label="Excel导入" name="import">
        <el-card>
          <template #header>
            <div style="display: flex; justify-content: space-between; align-items: center">
              <span>批量导入销售单</span>
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
            style="max-width: 500px; margin: 0 auto"
          >
            <el-icon :size="48" color="#c0c4cc"><Upload /></el-icon>
            <div style="margin-top: 10px">将Excel文件拖到此处，或<em>点击上传</em></div>
            <template #tip>
              <div style="color: #999; font-size: 12px; margin-top: 8px">
                支持 .xlsx 格式，第一行是表头，请按模板格式填写
              </div>
            </template>
          </el-upload>
          <div style="text-align: center; margin-top: 20px">
            <el-button type="primary" :loading="importing" :disabled="!selectedFile" @click="handleImport">
              开始导入
            </el-button>
          </div>
        </el-card>

        <!-- 导入结果 -->
        <el-card v-if="importResult" style="margin-top: 16px">
          <el-alert :title="importResult" type="info" :closable="false" show-icon />
        </el-card>

        <!-- 草稿单列表 -->
        <el-card style="margin-top: 16px" v-if="draftList.length > 0">
          <template #header>
            <div style="display: flex; justify-content: space-between; align-items: center">
              <span>草稿销售单（待出库）</span>
              <el-button type="success" :loading="stockOutLoading" @click="handleBatchStockOut">
                <el-icon><Check /></el-icon> 批量出库
              </el-button>
            </div>
          </template>
          <el-table :data="draftList" stripe @selection-change="handleSelectionChange">
            <el-table-column type="selection" width="50" />
            <el-table-column prop="orderNo" label="单号" width="180" />
            <el-table-column prop="customerName" label="客户名称" width="150" />
            <el-table-column prop="totalAmount" label="金额">
              <template #default="{ row }">{{ formatMoney(row.totalAmount) }}</template>
            </el-table-column>
            <el-table-column prop="orderDate" label="日期" width="120" />
            <el-table-column label="操作" width="100">
              <template #default="{ row }">
                <el-button type="primary" link @click="handleSingleStockOut(row)">出库</el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-card>
      </el-tab-pane>

      <el-tab-pane label="销售订单列表" name="list">
        <div class="toolbar">
          <el-input v-model="searchForm.orderNo" placeholder="订单编号" clearable @keyup.enter="loadData" />
          <el-input v-model="searchForm.customerName" placeholder="客户名称" clearable style="margin:0 10px" @keyup.enter="loadData" />
          <el-button type="primary" @click="loadData">搜索</el-button>
          <el-button @click="resetSearch">重置</el-button>
          <!-- ✅ 新增导出按钮 -->
          <el-button type="success" @click="handleExport" :loading="exportLoading">导出销售单</el-button>
        </div>

        <el-table :data="tableData" stripe v-loading="loading" border>
          <el-table-column prop="id" label="ID" width="80" />
          <el-table-column prop="orderNo" label="订单编号" />
          <el-table-column prop="customerName" label="客户名称" />
          <!-- ✅ 新增销售日期、备注列（对齐采购） -->
          <el-table-column prop="orderDate" label="销售日期" width="120" />
          <el-table-column prop="remark" label="备注" show-overflow-tooltip />
          <el-table-column prop="totalAmount" label="总金额" width="120" />
          <el-table-column prop="status" label="状态">
            <template #default="{row}">
              <el-tag :type="row.status === 1 ? 'success' : 'warning'">
                {{ row.status === 1 ? '已出库' : '待出库' }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column label="操作" width="120">
            <template #default="{row}">
              <!-- ✅ 弹窗查看（已存在按钮，保留） -->
              <el-button type="primary" link @click="openDetailDialog(row)">查看</el-button>
              <el-button v-if="row.status!==1" type="success" link @click="handleStockOut(row)">出库</el-button>
            </template>
          </el-table-column>
        </el-table>

        <!-- ✅ 新增销售详情弹窗（完全对齐采购结构） -->
        <el-dialog v-model="detailVisible" title="销售单详情" width="900px">
          <el-descriptions :column="2" border>
            <el-descriptions-item label="订单编号">{{ detailInfo.orderNo }}</el-descriptions-item>
            <el-descriptions-item label="客户名称">{{ detailInfo.customerName }}</el-descriptions-item>
            <el-descriptions-item label="销售日期">{{ detailInfo.orderDate }}</el-descriptions-item>
            <el-descriptions-item label="状态">
              <el-tag :type="detailInfo.status === 1 ? 'success' : 'warning'">
                {{ detailInfo.status === 1 ? '已出库' : '待出库' }}
              </el-tag>
            </el-descriptions-item>
            <el-descriptions-item label="总金额">{{ detailInfo.totalAmount }}</el-descriptions-item>
            <el-descriptions-item label="备注" :span="2">{{ detailInfo.remark }}</el-descriptions-item>
          </el-descriptions>

          <div class="sub-title" style="margin: 16px 0 8px; font-weight: bold;">销售明细</div>
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
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus, Delete, Download, Upload, Check } from '@element-plus/icons-vue'
import { createSales, stockOut, batchStockOut, getDraftList, downloadTemplate, importSales, exportSaleOrder, getSalesOrderList, getSalesOrderDetail    } from '@/api/sales'
import { getCustomerList } from '@/api/customer'
import { getWarehouseList } from '@/api/warehouse'
import { getProductList } from '@/api/product'
import { useRoute, useRouter } from 'vue-router'

const route = useRoute()
const router = useRouter()
const activeTab = ref('create')
const submitting = ref(false)
const importing = ref(false)
const stockOutLoading = ref(false)
const selectedFile = ref(null)
const importResult = ref('')
const draftList = ref([])
const selectedOrders = ref([])

const customers = ref([])
const warehouses = ref([])
const products = ref([])

const loading = ref(false)
const tableData = ref([])
const total = ref(0)
const pageNum = ref(1)
const pageSize = ref(10)
const searchForm = ref({ orderNo: '', customerName: '' })

// ✅ 导出 loading
const exportLoading = ref(false)
// ✅ 详情弹窗控制
const detailVisible = ref(false)
const detailInfo = ref({}) // SalesOrderDTO

// ✅ 导出方法（对齐采购）
const handleExport = async () => {
  if (exportLoading.value) return
  exportLoading.value = true
  try {
    const params = {
      orderNo: searchForm.value.orderNo,
      customerName: searchForm.value.customerName
    }
    const blob = await exportSaleOrder(params)
    const url = URL.createObjectURL(blob)
    const a = document.createElement('a')
    a.href = url
    a.download = `销售单列表_${new Date().getTime()}.xlsx`
    a.click()
    URL.revokeObjectURL(url)
    ElMessage.success('导出成功')
  } catch (e) {
    ElMessage.error(e.message || '导出失败')
  } finally {
    exportLoading.value = false
  }
}


const loadData = async () => {
  loading.value = true
  try {
    const res = await getSalesOrderList({
      orderNo: searchForm.value.orderNo,
      customerName: searchForm.value.customerName,
      pageNum: pageNum.value,
      pageSize: pageSize.value
    })
    // 兼容分页（PageInfo）和非分页（数组）返回
    if (res.list) {
      tableData.value = res.list
      total.value = res.total
    } else {
      tableData.value = res
      total.value = res.length
    }
  } catch (e) {
    ElMessage.error(e.message || '加载失败')
  } finally {
    loading.value = false
  }
}

const resetSearch = () => {
  searchForm.value = { orderNo: '', customerName: '' }
  loadData()
}
const viewDetail = (row) => {
  router.push(`/sales/detail/${row.id}`)
  // ElMessage.info(`查看销售单${row.orderNo}`) // 无详情页时用这行测试
}
const openDetailDialog = async (row) => {
  try {
    const res = await getSalesOrderDetail(row.id)
    detailInfo.value = res
    detailVisible.value = true
  } catch (e) {
    ElMessage.error(e.message || '加载详情失败')
  }
}

const orderFormRef = ref()
const orderForm = reactive({
  customerId: null,
  warehouseId: null,
  orderDate: new Date().toISOString().slice(0, 10),
  items: [{ productId: null, quantity: 1, price: 0 }]
})

const orderRules = {
  customerId: [{ required: true, message: '请选择客户', trigger: 'change' }],
  warehouseId: [{ required: true, message: '请选择仓库', trigger: 'change' }]
}

const totalAmount = computed(() => {
  return orderForm.items.reduce((sum, item) => sum + (item.quantity * item.price || 0), 0)
})

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
      customerId: orderForm.customerId,
      warehouseId: orderForm.warehouseId,
      orderDate: orderForm.orderDate,
      remark: '前端创建'
    }
    const items = orderForm.items.map(item => ({
      productId: item.productId,
      quantity: item.quantity,
      price: item.price
    }))
    await createSales({ order, items })
    ElMessage.success('销售单创建成功')
    orderForm.items = [{ productId: null, quantity: 1, price: 0 }]
  } catch (e) {
    ElMessage.error(e.message || '创建失败')
  } finally {
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
    const res = await importSales(selectedFile.value, 1)
    importResult.value = '导入成功'
    ElMessage.success('导入成功')
    selectedFile.value = null
    loadDraftList()
  } catch (e) {
    importResult.value = e.message || '导入失败'
    ElMessage.error(e.message || '导入失败')
  } finally {
    importing.value = false
  }
}

async function downloadTemplateFile() {
  try {
    const blob = await downloadTemplate()
    const url = URL.createObjectURL(blob)
    const a = document.createElement('a')
    a.href = url
    a.download = '销售单导入模板.xlsx'
    a.click()
    URL.revokeObjectURL(url)
    ElMessage.success('模板下载成功')
  } catch (e) {
    ElMessage.error('下载模板失败')
  }
}

function handleSelectionChange(rows) {
  selectedOrders.value = rows
}

async function handleBatchStockOut() {
  if (selectedOrders.value.length === 0) {
    ElMessage.warning('请先选择要出库的单据')
    return
  }
  try {
    await ElMessageBox.confirm(`确定批量出库${selectedOrders.value.length}笔单据吗？`, '提示', { type: 'warning' })
    stockOutLoading.value = true
    const ids = selectedOrders.value.map(o => o.id)
    await batchStockOut(ids, 1)
    ElMessage.success(`批量出库成功，共${ids.length}笔`)
    loadDraftList()
  } catch (e) {
    if (e !== 'cancel') {
      ElMessage.error(e.message || '出库失败，可能库存不足')
    }
  } finally {
    stockOutLoading.value = false
  }
}

async function handleSingleStockOut(row) {
  try {
    await ElMessageBox.confirm(`确定对单号${row.orderNo}进行出库吗？`, '提示', { type: 'warning' })
    await stockOut(row.id)
    ElMessage.success(`单号${row.orderNo}出库成功`)
    loadDraftList()
  } catch (e) {
    if (e !== 'cancel') {
      ElMessage.error(e.message || '出库失败，可能库存不足')
    }
  }
}

async function handleStockOut(row) {
  try {
    await ElMessageBox.confirm(`确定对单号${row.orderNo}进行出库吗？`, '提示', { type: 'warning' })
    await stockOut(row.id)
    ElMessage.success(`单号${row.orderNo}出库成功`)
    loadData()
  } catch (e) {
    if (e !== 'cancel') {
      ElMessage.error(e.message || '出库失败，可能库存不足')
    }
  }
}


async function loadDraftList() {
  try {
    draftList.value = await getDraftList(1)
  } catch (e) {
    console.error(e)
  }
}

onMounted(async () => {
  try {
    const [custData, whData, prodData] = await Promise.all([
      getCustomerList({ pageNum: 1, pageSize: 100 }),
      getWarehouseList({ pageNum: 1, pageSize: 100 }),
      getProductList({ pageNum: 1, pageSize: 100 })
    ])
    customers.value = custData.list || []
    warehouses.value = whData.list || []
    products.value = prodData.list || []
    if (route.query.tab === 'list') activeTab.value = 'list'
    if (activeTab.value === 'list') loadData()
  } catch (e) {
    console.error(e)
  }
  loadDraftList()
})
watch(activeTab, (val) => val === 'list' && loadData())
</script>

<style scoped>
.page-container { padding: 0; }
.item-row { display: flex; align-items: center; gap: 12px; margin-bottom: 12px; }
.item-amount { min-width: 100px; font-weight: bold; color: #f56c6c; }
.total-row { font-size: 16px; text-align: right; }
.total-amount { font-size: 22px; font-weight: bold; color: #f56c6c; margin-left: 8px; }
</style>