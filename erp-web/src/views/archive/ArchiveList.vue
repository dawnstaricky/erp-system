<template>
  <div>
    <el-card>
      <template #header><span>业务闭环归档（严格五环节：采购入库→销售开单→商品出库→全额开票→全额回款，全部满足才归档）</span></template>
      <el-alert v-if="!hasCompany" title="请先在左上角选择公司" type="warning" show-icon :closable="false" style="margin-bottom:12px" />
      <el-table :data="rows" v-loading="loading" border>
        <el-table-column prop="orderNo" label="销售订单号" width="160" />
        <el-table-column label="采购入库" width="90"><template #default="{row}"><el-tag :type="row.purchaseDone?'success':'info'">{{row.purchaseDone?'是':'否'}}</el-tag></template></el-table-column>
        <el-table-column label="销售开单" width="90"><template #default="{row}"><el-tag :type="row.saleDraftDone?'success':'info'">{{row.saleDraftDone?'是':'否'}}</el-tag></template></el-table-column>
        <el-table-column label="商品出库" width="90"><template #default="{row}"><el-tag :type="row.outboundDone?'success':'info'">{{row.outboundDone?'是':'否'}}</el-tag></template></el-table-column>
        <el-table-column label="全额开票" width="90"><template #default="{row}"><el-tag :type="row.invoiceDone?'success':'warning'">{{row.invoiceDone?'是':'否'}}</el-tag></template></el-table-column>
        <el-table-column label="全额回款" width="90"><template #default="{row}"><el-tag :type="row.receiptDone?'success':'warning'">{{row.receiptDone?'是':'否'}}</el-tag></template></el-table-column>
        <el-table-column label="归档状态" width="120">
          <template #default="{row}">
            <el-tag v-if="row.isArchived" type="success">已归档</el-tag>
            <el-tag v-else-if="row.autoUnarchived" type="danger">已退出（{{row.unarchiveReason}}）</el-tag>
            <el-tag v-else type="info">未归档</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="120">
          <template #default="{row}"><el-button size="small" type="primary" @click="refresh(row)" :disabled="!hasCompany">刷新判定</el-button></template>
        </el-table-column>
      </el-table>
    </el-card>
  </div>
</template>
<script setup>
import { ref, computed, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { pageArchives, refreshArchive } from '@/api/archive'
import { useUserStore } from '@/stores/user'
const userStore = useUserStore()
const isAdmin = computed(() => (userStore.userInfo?.roles||[]).includes('ADMIN'))
const companyId = computed(() => userStore.currentCompanyId)
const hasCompany = computed(() => isAdmin.value || (companyId.value && companyId.value > 0))
const rows = ref([]), loading = ref(false)
async function search(){ if(!hasCompany.value){loading.value=false;return}; loading.value=true; try{const r=await pageArchives({companyId,pageNum:1,pageSize:50}); rows.value=r.data?.rows||r.rows||r.data||[]}finally{loading.value=false} }
async function refresh(row){ const a = await refreshArchive(companyId.value, row.orderId); ElMessage.success(a.isArchived?'已达五环节，已归档':'尚未满足全部条件'); search() }
onMounted(search)
</script>
