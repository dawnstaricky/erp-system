<template>
  <div>
    <el-card>
      <template #header><span>销售合同（销售侧，套销售模板，含硬度/锡层/含税）</span></template>
      <el-form :inline="true" :model="query">
        <el-form-item label="合同号"><el-input v-model="query.contractNo" clearable /></el-form-item>
        <el-form-item><el-button type="primary" @click="search">查询</el-button></el-form-item>
      </el-form>
      <el-alert v-if="!hasCompany" title="请先在左上角选择公司" type="warning" show-icon :closable="false" style="margin-bottom:12px" />
      <el-table :data="rows" v-loading="loading" border>
        <el-table-column prop="contractNo" label="合同号" width="180" />
        <el-table-column prop="customerName" label="客户" />
        <el-table-column prop="totalAmount" label="总额" width="120" />
        <el-table-column prop="deliveryMethod" label="交货方式" width="100" />
        <el-table-column label="状态" width="100">
          <template #default="{row}"><el-tag>{{ row.status===0?'草稿':(row.status===1?'已签章':'已作废') }}</el-tag></template>
        </el-table-column>
        <el-table-column label="操作" width="260">
          <template #default="{row}">
            <el-button size="small" @click="gen(row)" :disabled="!hasCompany">生成合同</el-button>
            <el-button size="small" @click="dl(row)">下载</el-button>
            <el-button size="small" type="danger" @click="voidC(row)">作废</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
    <el-dialog v-model="visible" title="生成销售合同（基于销售订单）" width="500px">
      <el-form :model="form" label-width="100px">
        <el-form-item label="销售订单ID"><el-input-number v-model="form.orderId" :min="1" /></el-form-item>
        <el-form-item label="编号前缀"><el-input v-model="form.prefix" placeholder="如 SS（可配置）" /></el-form-item>
        <el-form-item label="交货方式">
          <el-select v-model="form.deliveryMethod"><el-option label="自提" value="自提" /><el-option label="送货" value="送货" /></el-select>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="visible=false">取消</el-button>
        <el-button type="primary" @click="submit">生成并下载</el-button>
      </template>
    </el-dialog>
  </div>
</template>
<script setup>
import { ref, reactive, computed, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { pageSalesContracts, generateSalesContract, downloadSalesContract, voidSalesContract } from '@/api/contract'
import { useUserStore } from '@/stores/user'
const userStore = useUserStore()
const isAdmin = computed(() => (userStore.userInfo?.roles||[]).includes('ADMIN'))
const companyId = computed(() => userStore.currentCompanyId)
const hasCompany = computed(() => isAdmin.value || (companyId.value && companyId.value > 0))
const rows = ref([]), loading = ref(false), visible = ref(false)
const query = reactive({ contractNo: '' })
const form = reactive({ orderId:null, prefix:'SS', deliveryMethod:'送货' })
async function search(){ if(!hasCompany.value){loading.value=false;return}; loading.value=true; try{const r=await pageSalesContracts({...query,companyId,pageNum:1,pageSize:10}); rows.value=r.data?.rows||r.rows||r.data||[]}finally{loading.value=false} }
function gen(row){ form.orderId=row.orderId; visible.value=true }
async function submit(){ const id = await generateSalesContract({...form, companyId}); ElMessage.success('已生成合同：'+id); visible.value=false; search() }
async function dl(row){ const r = await downloadSalesContract(row.id); const b = new Blob([r],{type:'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'}); const a=document.createElement('a'); a.href=URL.createObjectURL(b); a.download=row.contractNo+'.xlsx'; a.click() }
async function voidC(row){ await voidSalesContract(row.id); ElMessage.success('已作废'); search() }
onMounted(search)
</script>
