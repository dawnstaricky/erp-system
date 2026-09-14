<template>
  <div>
    <el-card>
      <template #header><span>质量异议（采购来料 / 销售客户两类；处理后自动联动应付/应收，带扣款明细）</span></template>
      <el-alert v-if="!hasCompany" title="请先在左上角选择公司" type="warning" show-icon :closable="false" style="margin-bottom:12px" />
      <el-form :inline="true">
        <el-form-item><el-select v-model="query.disputeType" placeholder="类型" clearable @change="search">
          <el-option :value="1" label="采购来料" /><el-option :value="2" label="销售客户" />
        </el-select></el-form-item>
        <el-form-item><el-button type="primary" @click="search">查询</el-button></el-form-item>
        <el-form-item><el-button type="success" @click="open()">登记异议</el-button></el-form-item>
      </el-form>
      <el-table :data="rows" v-loading="loading" border>
        <el-table-column prop="disputeNo" label="异议单号" width="160" />
        <el-table-column label="类型" width="100"><template #default="{row}">{{row.disputeType===1?'采购来料':'销售客户'}}</template></el-table-column>
        <el-table-column prop="contractNo" label="关联合同" width="140" />
        <el-table-column prop="claimAmount" label="索赔金额" width="110" />
        <el-table-column prop="adjustType" label="扣款类型" width="110" />
        <el-table-column prop="adjustedAmount" label="扣款金额" width="110" />
        <el-table-column prop="adjustedBillNo" label="关联账单" width="140" />
        <el-table-column label="状态" width="90"><template #default="{row}"><el-tag :type="row.status===1?'success':'warning'">{{row.status===1?'已处理':'待处理'}}</el-tag></template></el-table-column>
        <el-table-column label="操作" width="120"><template #default="{row}"><el-button size="small" type="primary" :disabled="!hasCompany" @click="handle(row)">处理</el-button></template></el-table-column>
      </el-table>
    </el-card>
    <el-dialog v-model="visible" :title="editing?'处理异议（自动联动应付/应收）':'登记异议'" width="540px">
      <el-form :model="form" label-width="110px">
        <el-form-item label="类型" v-if="!editing"><el-select v-model="form.disputeType"><el-option :value="1" label="采购来料" /><el-option :value="2" label="销售客户" /></el-select></el-form-item>
        <el-form-item label="订单ID"><el-input-number v-model="form.orderId" :min="1" :disabled="editing" /></el-form-item>
        <el-form-item label="合同号"><el-input v-model="form.contractNo" /></el-form-item>
        <el-form-item label="索赔金额"><el-input-number v-model="form.claimAmount" :precision="2" :min="0" /></el-form-item>
        <el-form-item label="异议描述"><el-input v-model="form.description" type="textarea" /></el-form-item>
        <template v-if="editing">
          <el-form-item label="处理方式"><el-input v-model="form.handleMethod" type="textarea" /></el-form-item>
          <el-form-item label="扣款类型">
            <el-select v-model="form.adjustType"><el-option label="扣减应付（采购侧）" value="扣减应付" /><el-option label="减免应收（销售侧）" value="减免应收" /></el-select>
          </el-form-item>
          <el-form-item label="扣款金额"><el-input-number v-model="form.adjustedAmount" :precision="2" :min="0" /></el-form-item>
          <el-form-item label="关联账单号"><el-input v-model="form.adjustedBillNo" placeholder="被调整的原始应付/应收账单号" /></el-form-item>
          <el-form-item label="扣款说明"><el-input v-model="form.adjustRemark" type="textarea" placeholder="明细说明（自动改账单依据）" /></el-form-item>
        </template>
      </el-form>
      <template #footer>
        <el-button @click="visible=false">取消</el-button>
        <el-button type="primary" @click="submit">确认</el-button>
      </template>
    </el-dialog>
  </div>
</template>
<script setup>
import { ref, reactive, computed, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { pageDisputes, createDispute, handleDispute } from '@/api/dispute'
import { useUserStore } from '@/stores/user'
const userStore = useUserStore()
const isAdmin = computed(() => (userStore.userInfo?.roles||[]).includes('ADMIN'))
const companyId = computed(() => userStore.currentCompanyId)
const hasCompany = computed(() => isAdmin.value || (companyId.value && companyId.value > 0))
const rows = ref([]), loading = ref(false), visible = ref(false), editing = ref(false)
const query = reactive({ disputeType: null })
const blank = ()=>({id:null, disputeType:1, orderId:null, contractNo:'', claimAmount:0, description:'', handleMethod:'', adjustType:'扣减应付', adjustedAmount:0, adjustedBillNo:'', adjustRemark:''})
const form = reactive(blank())
function open(){ Object.assign(form, blank()); editing.value=false; visible.value=true }
function handle(row){ Object.assign(form, blank(), row); editing.value=true; visible.value=true }
async function search(){ if(!hasCompany.value){loading.value=false;return}; loading.value=true; try{const r=await pageDisputes({...query,companyId,pageNum:1,pageSize:50}); rows.value=r.data?.rows||r.rows||r.data||[]}finally{loading.value=false} }
async function submit(){
  if(editing.value){ await handleDispute(form.id,{handleMethod:form.handleMethod, adjustType:form.adjustType, adjustedAmount:form.adjustedAmount, adjustedBillNo:form.adjustedBillNo, adjustRemark:form.adjustRemark}); ElMessage.success('已处理，应付/应收已联动调整（含明细）') }
  else { await createDispute({...form, companyId}); ElMessage.success('已登记') }
  visible.value=false; search()
}
onMounted(search)
</script>
