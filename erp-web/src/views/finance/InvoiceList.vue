<template>
  <div>
    <el-card>
      <template #header><span>销售开票</span></template>
      <el-form :inline="true" :model="query">
        <el-form-item label="订单号"><el-input v-model="query.orderNo" placeholder="销售订单号" clearable /></el-form-item>
        <el-form-item><el-button type="primary" @click="search">查询</el-button></el-form-item>
      </el-form>
      <el-alert v-if="!hasCompany" title="请先在左上角选择公司" type="warning" show-icon :closable="false" style="margin-bottom:12px" />
      <el-table :data="rows" v-loading="loading" border>
        <el-table-column prop="orderNo" label="销售订单号" width="160" />
        <el-table-column prop="customerName" label="客户" />
        <el-table-column prop="totalAmount" label="订单总额" width="120" />
        <el-table-column prop="uninvoicedAmount" label="未开票金额" width="120" />
        <el-table-column label="开票状态" width="100">
          <template #default="{row}">
            <el-tag :type="row.invoiceDone===2?'success':(row.invoiceDone===1?'warning':'info')">
              {{ row.invoiceDone===2?'全开':(row.invoiceDone===1?'部分开':'未开') }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="160">
          <template #default="{row}">
            <el-button size="small" type="primary" :disabled="!hasCompany||row.uninvoicedAmount<=0" @click="open(row)">开票</el-button>
          </template>
        </el-table-column>
      </el-table>
      <el-pagination v-model:current-page="pageNum" :page-size="pageSize" :total="total" @current-change="search" layout="total, prev, pager, next" />
    </el-card>

    <el-dialog v-model="visible" title="销售开票（杜绝无单开票，必须关联订单）" width="500px">
      <el-form :model="form" label-width="100px">
        <el-form-item label="订单号"><el-input v-model="form.orderNo" disabled /></el-form-item>
        <el-form-item label="开票金额">
          <el-input-number v-model="form.amount" :min="0.01" :max="form.maxAmount" :precision="2" />
          <div class="tip">最大可开（未开票）：{{ form.maxAmount }}</div>
        </el-form-item>
        <el-form-item label="发票号码"><el-input v-model="form.invoiceNo" /></el-form-item>
        <el-form-item label="开票日期"><el-date-picker v-model="form.invoiceDate" type="date" value-format="YYYY-MM-DD" /></el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="visible=false">取消</el-button>
        <el-button type="primary" @click="submit">确认开票</el-button>
      </template>
    </el-dialog>
  </div>
</template>
<script setup>
import { ref, reactive, computed, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { pageInvoices, createInvoice } from '@/api/invoice'
import { useUserStore } from '@/stores/user'
const userStore = useUserStore()
const isAdmin = computed(() => (userStore.userInfo?.roles||[]).includes('ADMIN'))
const companyId = computed(() => userStore.currentCompanyId)
const hasCompany = computed(() => isAdmin.value || (companyId.value && companyId.value > 0))

const rows = ref([]), loading = ref(false), total = ref(0), pageNum = ref(1), pageSize = ref(10)
const query = reactive({ orderNo: '' })
const visible = ref(false)
const form = reactive({ orderId:null, orderNo:'', amount:0, maxAmount:0, invoiceNo:'', invoiceDate: new Date().toISOString().slice(0,10) })
async function search() {
  if(!hasCompany.value){ loading.value=false; return }
  loading.value = true
  try {
    const res = await pageInvoices({ ...query, companyId, pageNum: pageNum.value, pageSize: pageSize.value })
    rows.value = (res.data?.rows || res.rows || res.data || []).map(r=>({...r, uninvoicedAmount: (r.totalAmount||0) - (r.invoicedAmount||0)}))
    total.value = res.data?.total || res.total || rows.value.length
  } finally { loading.value = false }
}
function open(row){ Object.assign(form, {orderId:row.id, orderNo:row.orderNo, amount:row.uninvoicedAmount, maxAmount:row.uninvoicedAmount}); visible.value=true }
async function submit(){
  if(form.amount > form.maxAmount){ ElMessage.error('开票金额不能大于未开票金额'); return }
  await createInvoice({ ...form, companyId })
  ElMessage.success('开票成功（已登记应收）'); visible.value=false; search()
}
onMounted(search)
</script>
<style scoped>.tip{font-size:12px;color:#909399;margin-top:4px}</style>
