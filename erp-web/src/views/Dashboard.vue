<template>
  <div class="dashboard">
    <el-row :gutter="20" class="stat-cards">
      <el-col :span="6">
        <el-card shadow="hover" class="stat-card sales">
          <div class="stat-content">
            <div class="stat-icon"><el-icon :size="28"><Money /></el-icon></div>
            <div class="stat-info">
              <div class="stat-value">{{ formatMoney(dashboard.todaySales) }}</div>
              <div class="stat-label">今日销售额</div>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover" class="stat-card month">
          <div class="stat-content">
            <div class="stat-icon"><el-icon :size="28"><Calendar /></el-icon></div>
            <div class="stat-info">
              <div class="stat-value">{{ formatMoney(dashboard.monthSales) }}</div>
              <div class="stat-label">本月销售额</div>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover" class="stat-card profit">
          <div class="stat-content">
            <div class="stat-icon"><el-icon :size="28"><TrendCharts /></el-icon></div>
            <div class="stat-info">
              <div class="stat-value">{{ formatMoney(dashboard.monthProfit) }}</div>
              <div class="stat-label">本月毛利</div>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover" class="stat-card alert">
          <div class="stat-content">
            <div class="stat-icon"><el-icon :size="28"><Warning /></el-icon></div>
            <div class="stat-info">
              <div class="stat-value">{{ dashboard.lowStockCount }}</div>
              <div class="stat-label">库存预警</div>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <el-row :gutter="20" style="margin-top: 20px;">
      <el-col :span="12">
        <el-card shadow="hover">
          <template #header>
            <div class="card-header">
              <span>商品销售排行 Top10</span>
            </div>
          </template>
          <el-table :data="productRank" stripe size="small" max-height="350">
            <el-table-column prop="rank" label="排名" width="60" />
            <el-table-column prop="productName" label="商品名称" show-overflow-tooltip />
            <el-table-column prop="totalQuantity" label="销量" width="80" />
            <el-table-column prop="totalAmount" label="金额" width="120">
              <template #default="{ row }">{{ formatMoney(row.totalAmount) }}</template>
            </el-table-column>
          </el-table>
        </el-card>
      </el-col>
      <el-col :span="12">
        <el-card shadow="hover">
          <template #header>
            <div class="card-header">
              <span>待办事项</span>
            </div>
          </template>
          <div class="todo-list">
            <div class="todo-item" v-if="dashboard.pendingApprovalCount > 0">
              <el-icon color="#e6a23c"><Bell /></el-icon>
              <span>有 {{ dashboard.pendingApprovalCount }} 条报销单待审批</span>
              <el-button type="primary" link @click="$router.push('/expense')">去处理</el-button>
            </div>
            <div class="todo-item" v-if="dashboard.lowStockCount > 0">
              <el-icon color="#f56c6c"><Warning /></el-icon>
              <span>有 {{ dashboard.lowStockCount }} 个商品库存低于预警线</span>
              <el-button type="primary" link @click="$router.push('/inventory')">去查看</el-button>
            </div>
            <el-empty v-if="!dashboard.pendingApprovalCount && !dashboard.lowStockCount" 
                      description="暂无待办事项" :image-size="80" />
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { getDashboard } from '@/api/report'
import { getProductRank } from '@/api/report'

const dashboard = ref({
  todaySales: 0,
  monthSales: 0,
  monthProfit: 0,
  pendingApprovalCount: 0,
  lowStockCount: 0,
  productCount: 0,
  customerCount: 0
})
const productRank = ref([])

function formatMoney(val) {
  if (!val) return '¥0.00'
  return '¥' + Number(val).toLocaleString('zh-CN', { minimumFractionDigits: 2 })
}

onMounted(async () => {
  try {
    dashboard.value = await getDashboard()
    const rankData = await getProductRank({ limit: 10 })
    productRank.value = rankData.map((item, idx) => ({ ...item, rank: idx + 1 }))
  } catch (e) {}
})
</script>

<style scoped>
.stat-cards .el-col {
  margin-bottom: 20px;
}
.stat-card .stat-content {
  display: flex;
  align-items: center;
  gap: 16px;
}
.stat-icon {
  width: 56px;
  height: 56px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
}
.sales .stat-icon { background: linear-gradient(135deg, #667eea, #764ba2); }
.month .stat-icon { background: linear-gradient(135deg, #f093fb, #f5576c); }
.profit .stat-icon { background: linear-gradient(135deg, #4facfe, #00f2fe); }
.alert .stat-icon { background: linear-gradient(135deg, #fa709a, #fee140); }
.stat-value {
  font-size: 22px;
  font-weight: bold;
  color: #333;
}
.stat-label {
  font-size: 13px;
  color: #999;
  margin-top: 4px;
}
.card-header {
  font-weight: 600;
  font-size: 15px;
}
.todo-list {
  min-height: 200px;
}
.todo-item {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 12px 0;
  border-bottom: 1px solid #f5f5f5;
  font-size: 14px;
}
</style>