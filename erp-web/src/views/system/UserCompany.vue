<template>
  <div>
    <el-card>
      <template #header><span>用户-公司-角色分配（一个用户在每家公司可有不同角色）</span></template>
      <el-form :inline="true">
        <el-form-item label="用户ID"><el-input-number v-model="userId" :min="1" /></el-form-item>
        <el-form-item><el-button type="primary" @click="load">加载该用户公司/角色</el-button></el-form-item>
      </el-form>
      <el-table :data="rows" v-loading="loading" border>
        <el-table-column prop="companyId" label="公司ID" width="90" />
        <el-table-column prop="companyName" label="公司名称" />
        <el-table-column prop="roleId" label="角色ID" width="90" />
        <el-table-column prop="roleCode" label="角色编码" />
      </el-table>
      <el-divider />
      <el-form :model="assign" label-width="100px" inline>
        <el-form-item label="分配关系">
          <el-select v-model="assign.companyId" placeholder="公司"><el-option v-for="c in allCompanies" :key="c.id" :label="c.companyName" :value="c.id" /></el-select>
          <el-select v-model="assign.roleId" placeholder="角色"><el-option v-for="r in allRoles" :key="r.id" :label="r.roleCode" :value="r.id" /></el-select>
        </el-form-item>
        <el-form-item><el-button type="success" @click="addOne">添加一条（保存时整体提交）</el-button></el-form-item>
      </el-form>
      <el-table :data="draft" border size="small">
        <el-table-column prop="companyId" label="公司ID" />
        <el-table-column prop="roleId" label="角色ID" />
        <el-table-column label="操作" width="100"><template #default="{row,$index}"><el-button size="small" type="danger" @click="draft.splice($index,1)">移除</el-button></template></el-table-column>
      </el-table>
      <div style="margin-top:12px"><el-button type="primary" :disabled="!userId" @click="submit">整体提交分配</el-button></div>
    </el-card>
  </div>
</template>
<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { getUserCompanies, assignCompanies, listCompanies } from '@/api/company'
import { getRoleList } from '@/api/role'
const userId = ref(null), rows = ref([]), loading = ref(false)
const allCompanies = ref([]), allRoles = ref([])
const assign = reactive({ companyId:null, roleId:null })
const draft = ref([])
async function load(){ if(!userId.value) return; loading.value=true; try{const r=await getUserCompanies(userId.value); rows.value=r.data||r||[]; draft.value=rows.value.map(x=>({companyId:x.companyId,roleId:x.roleId}))}finally{loading.value=false} }
function addOne(){ if(!assign.companyId||!assign.roleId){ElMessage.warning('请选择公司和角色');return}; draft.value.push({companyId:assign.companyId,roleId:assign.roleId}) }
async function submit(){ await assignCompanies(userId.value, draft.value.map(d=>({userId:userId.value, companyId:d.companyId, roleId:d.roleId}))); ElMessage.success('已保存'); load() }
onMounted(async ()=>{ const c=await listCompanies({pageNum:1,pageSize:100}); allCompanies.value=c.data?.rows||c.rows||[]; const r=await getRoleList({pageNum:1,pageSize:100}); allRoles.value=r.data?.rows||r.rows||[] })
</script>
