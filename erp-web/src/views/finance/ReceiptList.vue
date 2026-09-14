<template>
  <div>
    <el-card>
      <template #header><span>销售回款（杜绝无单回款，必须关联销售订单）</span></template>
      <el-form :inline="true" :model="query">
        <el-form-item label="订单号"><el-input v-model="query.orderNo" placeholder="销售订单号" clearable /></el-form-item>
        <el-form-item><el-button type="primary" @click="search">查询</el-button></el-form-item>
      </el-form>
      <el-alert v-if="!hasCompany" title="请先在左上角选择公司" type="warning" show-icon :closable="false" style="margin-bottom:12px" />
      <el-table :data="rows" v-loading="loading" border>
        <el-table-column prop="orderNo" label="销售订单号" width="160" />
        <el-table-column prop="customerName" label="客户" />
        <el-table-column prop="totalAmount" label="应收总额" width="120" />
        <el-table-column prop="paidAmount" label="已收金额" width="120" />
        <el-table-column prop="unpaidAmount" label="未收金额" width="120" />
        <el-table-column label="操作" width="160">
          <template #default="{row}">
            <el-button size="small" type="primary" :disabled="!hasCompany||row.unpaidAmount<=0" @click="open(row)">登记回款</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
    <el-dialog v-model="visible" title="登记回款（回款冲抵应收）" width="500px">
      <el-form :model="form" label-width="100px">
        <el-form-item label="订单号"><el-input v-model="form.orderNo" disabled /></el-form-item>
        <el-form-item label="回款金额">
          <el-input-number v-model="form.amount" :min="0.01" :max="form.maxAmount" :precision="2" />
          <div class="tip">未收金额：{{ form.maxAmount }}</div>
        </el-form-item>
        <el-form-item label="回款日期"><el-date-picker v-model="form.receiptDate" type="date" value-format="YYYY-MM-DD" /></el-form-item>
        <el-form-item label="收款方式">
          <el-select v-model="form.paymentMethod" placeholder="请选择">
            <el-option label="银行转账" value="银行转账" /><el-option label="承兑" value="承兑" /><el-option label="现金" value="现金" />
          </el-select>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="visible=false">取消</el-button>
        <el-button type="primary" @click="submit">确认回款</el-button>
      </template>
    </el-dialog>
  </div>
</template>
<script setup>
import { ref, reactive, computed, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { pageReceipts, createReceipt } from '@/api/receipt'
import { useUserStore } from '@/stores/user'
const userStore = useUserStore()
const isAdmin = computed(() => (userStore.userInfo?.roles||[]).includes('ADMIN'))
const companyId = computed(() => userStore.currentCompanyId)
const hasCompany = computed(() => isAdmin.value || (companyId.value && companyId.value > 0))

const rows = ref([]), loading = ref(false)
const query = reactive({ orderNo: '' })
const visible = ref(false)
const form = reactive({ orderId:null, orderNo:'', amount:0, maxAmount:0, receiptDate: new Date().toISOString().slice(0,10), paymentMethod:'银行转账' })
async function search(){
  if(!hasCompany.value){ loading.value=false; return }
  loading.value=true
  try { const res = await pageReceipts({ ...query, companyId }); rows.value = res.data?.rows || res.rows || res.data || [] }
  finally { loading.value=false }
}
function open(row){ Object.assign(form,{orderId:row.id, orderNo:row.orderNo, amount:row.unpaidAmount, maxAmount:row.unpaidAmount}); visible.value=true }
async function submit(){
  if(form.amount > form.maxAmount){ ElMessage.error('回款金额不能大于未收金额'); return }
  await createReceipt({ ...form, companyId })
  ElMessage.success('回款登记成功（已冲抵应收）'); visible.value=false; search()
}
onMounted(search)
</script>
<style scoped>.tip{font-size:12px;color:#909399;margin-top:4px}</style>
