<template>
  <div>
    <el-card>
      <template #header><span>公司/抬头管理（仅 ADMIN）</span></template>
      <el-form :inline="true">
        <el-form-item><el-button type="primary" @click="open()">新增公司</el-button></el-form-item>
      </el-form>
      <el-table :data="rows" v-loading="loading" border>
        <el-table-column prop="companyCode" label="编码" width="100" />
        <el-table-column prop="companyName" label="公司名称/抬头" />
        <el-table-column prop="taxNumber" label="税号" width="180" />
        <el-table-column prop="bankName" label="开户行" />
        <el-table-column prop="bankAccount" label="银行账号" />
        <el-table-column prop="status" label="状态" width="80"><template #default="{row}"><el-tag>{{row.status==='1'?'正常':'停用'}}</el-tag></template></el-table-column>
        <el-table-column label="操作" width="160"><template #default="{row}"><el-button size="small" @click="open(row)">编辑</el-button><el-button size="small" type="danger" @click="del(row)">删除</el-button></template></el-table-column>
      </el-table>
    </el-card>
    <el-dialog v-model="visible" title="公司信息" width="600px">
      <el-form :model="form" label-width="110px">
        <el-form-item label="编码"><el-input v-model="form.companyCode" /></el-form-item>
        <el-form-item label="公司名称"><el-input v-model="form.companyName" /></el-form-item>
        <el-form-item label="法定代表人"><el-input v-model="form.legalPerson" /></el-form-item>
        <el-form-item label="税号"><el-input v-model="form.taxNumber" /></el-form-item>
        <el-form-item label="地址"><el-input v-model="form.address" /></el-form-item>
        <el-form-item label="电话"><el-input v-model="form.phone" /></el-form-item>
        <el-form-item label="开户行"><el-input v-model="form.bankName" /></el-form-item>
        <el-form-item label="银行账号"><el-input v-model="form.bankAccount" /></el-form-item>
        <el-form-item label="状态">
          <el-radio-group v-model="form.status"><el-radio-button label="1">正常</el-radio-button><el-radio-button label="0">停用</el-radio-button></el-radio-group>
        </el-form-item>
      </el-form>
      <template #footer><el-button @click="visible=false">取消</el-button><el-button type="primary" @click="submit">保存</el-button></template>
    </el-dialog>
  </div>
</template>
<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { pageCompanies, addCompany, updateCompany, deleteCompany } from '@/api/company'
const rows = ref([]), loading = ref(false), visible = ref(false)
const blank = ()=>({id:null, companyCode:'', companyName:'', legalPerson:'', taxNumber:'', address:'', phone:'', bankName:'', bankAccount:'', status:'1'})
const form = reactive(blank())
async function search(){ loading.value=true; try{const r=await pageCompanies({pageNum:1,pageSize:100}); rows.value=r.list||[]; console.log('Company list loaded:', rows.value.length)} catch (e) { console.error('Load company failed:', e)  } finally{loading.value=false} }
function open(row){ Object.assign(form, blank(), row||{}); visible.value=true }
async function submit(){ if(form.id){ await updateCompany(form) } else { await addCompany(form) }; ElMessage.success('保存成功'); visible.value=false; search() }
async function del(row){ await ElMessageBox.confirm('确定删除该公司？','提示',{type:'warning'}); await deleteCompany(row.id); ElMessage.success('已删除'); search() }
onMounted(search)
</script>
