<template>
  <div class="page-container">
    <el-row :gutter="20">
      <el-col :span="12">
        <el-card>
          <template #header><span>销售趋势</span></template>
          <el-table :data="dailyData" stripe size="small" max-height="300">
            <el-table-column prop="reportDate" label="日期" width="120" />
            <el-table-column prop="orderCount" label="订单数" width="80" />
            <el-table-column prop="totalAmount" label="销售额">
              <template #default="{ row }">{{ formatMoney(row.totalAmount) }}</template>
            </el-table-column>
            <el-table-column prop="grossProfit" label="毛利">
              <template #default="{ row }">{{ formatMoney(row.grossProfit) }}</template>
            </el-table-column>
          </el-table>
          <div style="margin-top:10px; text-align:right;">
            <el-button size="small" @click="handleExportDaily"><el-icon><Download /></el-icon> 导出</el-button>
          </div>
        </el-card>
      </el-col>
      <el-col :span="12">
        <el-card>
          <template #header><span>商品销售排行</span></template>
          <el-table :data="productRank" stripe size="small" max-height="300">
            <el-table-column prop="prodRank" label="排名" width="60" />
            <el-table-column prop="productName" label="商品" show-overflow-tooltip />
            <el-table-column prop="totalQuantity" label="销量" width="80" />
            <el-table-column prop="totalAmount" label="金额">
              <template #default="{ row }">{{ formatMoney(row.totalAmount) }}</template>
            </el-table-column>
          </el-table>
          <div style="margin-top:10px; text-align:right;">
            <el-button size="small" @click="handleExportRank"><el-icon><Download /></el-icon> 导出</el-button>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <el-row :gutter="20" style="margin-top:20px;">
      <el-col :span="24">
        <el-card>
          <template #header><span>库存健康度分析</span></template>
          <el-table :data="invAnalysis" stripe size="small" max-height="350">
            <el-table-column prop="productName" label="商品" show-overflow-tooltip />
            <el-table-column prop="quantity" label="库存" width="80" />
            <el-table-column prop="stockAmount" label="库存金额" width="120">
              <template #default="{ row }">{{ formatMoney(row.stockAmount) }}</template>
            </el-table-column>
            <el-table-column prop="sales30d" label="30天销量" width="100" />
            <el-table-column prop="turnoverDays" label="周转天数" width="100" />
            <el-table-column prop="healthStatus" label="健康度" width="100">
              <template #default="{ row }">
                <el-tag :type="healthType(row.healthStatus)">{{ row.healthStatus }}</el-tag>
              </template>
            </el-table-column>
          </el-table>
          <div style="margin-top:10px; text-align:right;">
            <el-button size="small" @click="handleExportInv"><el-icon><Download /></el-icon> 导出</el-button>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { getSalesDaily, getProductRank, getInventoryAnalysis, exportSalesDaily, exportProductRank, exportInventoryAnalysis } from '@/api/report'

const dailyData = ref([])
const productRank = ref([])
const invAnalysis = ref([])

function formatMoney(val) {
  if (!val) return '¥0.00'
  return '¥' + Number(val).toLocaleString('zh-CN', { minimumFractionDigits: 2 })
}

function healthType(s) {
  return { '快周转': 'success', '正常': 'primary', '补货': 'warning', '滞销': 'danger' }[s] || 'info'
}

function downloadBlob(blob, name) {
  const url = URL.createObjectURL(blob)
  const a = document.createElement('a')
  a.href = url; a.download = name; a.click()
  URL.revokeObjectURL(url)
}

async function handleExportDaily() {
  try {
    const blob = await exportSalesDaily({})
    downloadBlob(blob, '销售日报.xlsx')
    ElMessage.success('导出成功')
  } catch (e) {}
}

async function handleExportRank() {
  try {
    const blob = await exportProductRank({ limit: 20 })
    downloadBlob(blob, '商品销售排行.xlsx')
    ElMessage.success('导出成功')
  } catch (e) {}
}

async function handleExportInv() {
  try {
    const blob = await exportInventoryAnalysis({})
    downloadBlob(blob, '库存分析.xlsx')
    ElMessage.success('导出成功')
  } catch (e) {}
}

onMounted(async () => {
  const endDate = new Date().toISOString().slice(0, 10)
  const startDate = new Date(Date.now() - 30 * 86400000).toISOString().slice(0, 10)
  try {
    const [d, r, i] = await Promise.all([
      getSalesDaily({ startDate, endDate }),
      getProductRank({ startDate, endDate, limit: 10 }),
      getInventoryAnalysis({})
    ])
    dailyData.value = d || []
    productRank.value = r || []
    invAnalysis.value = i || []
  } catch (e) {}
})
</script>

<style scoped>
.page-container { padding: 0; }
</style>