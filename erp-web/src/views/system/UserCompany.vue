<template>
  <div>
    <el-card>
      <template #header><span>用户-公司-角色分配</span></template>
      
      <!-- 1. 选择用户 -->
      <el-form :inline="true">
        <el-form-item label="用户">
          <!-- 改为下拉选择 -->
          <el-select 
            v-model="selectedUserId" 
            filterable 
            placeholder="请选择用户"
            @change="handleUserChange"
          >
            <el-option 
              v-for="item in userOptions" 
              :key="item.id" 
              :label="`${item.realName}(${item.username})`" 
              :value="item.id" 
            />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" :disabled="!selectedUserId" @click="load">加载已分配</el-button>
        </el-form-item>
      </el-form>

      <!-- 2. 已分配列表 -->
      <el-table :data="rows" v-loading="loading" border style="margin-top: 20px">
        <el-table-column prop="companyName" label="公司名称" />
        <el-table-column prop="roleCode" label="角色编码" />
        <el-table-column label="操作" width="100">
          <template #default="{ $index }">
            <el-button size="small" type="danger" @click="rows.splice($index, 1)">移除</el-button>
          </template>
        </el-table-column>
      </el-table>

      <!-- 3. 新增分配 -->
      <el-divider />
      <el-form :model="assign" label-width="100px" inline>
        <el-form-item label="分配关系">
          <el-select v-model="assign.companyId" placeholder="选择公司">
            <el-option v-for="c in allCompanies" :key="c.id" :label="c.companyName" :value="c.id" />
          </el-select>
          <el-select v-model="assign.roleId" placeholder="选择角色" style="margin-left: 10px">
            <el-option v-for="r in allRoles" :key="r.id" :label="r.roleName" :value="r.id" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="success" @click="addOne">添加</el-button>
        </el-form-item>
      </el-form>

      <!-- 4. 草稿列表 -->
      <el-table :data="rows" border size="small" style="margin-top: 12px">
        <el-table-column prop="companyId" label="公司ID" />
        <el-table-column prop="roleId" label="角色ID" />
      </el-table>

      <!-- 5. 提交 -->
      <div style="margin-top: 20px">
        <el-button type="primary" :disabled="!selectedUserId" @click="submit">
          整体提交分配
        </el-button>
      </div>
    </el-card>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { pageCompanies, getUserCompanies, assignCompanies } from '@/api/company'
import { getUserList  } from '@/api/user'
import { getRoleList } from '@/api/role'

const selectedUserId = ref(null)
const userOptions = ref([])
const allCompanies = ref([])
const allRoles = ref([])
const rows = ref([])
const draft = ref([]) 
const loading = ref(false)
const keyword = ref('')

const assign = reactive({ companyId: null, roleId: null })

// 加载初始数据
onMounted(async () => {
  const [usersRes, companiesRes, rolesRes] = await Promise.all([
    getUserList({ keyword:keyword.value,  pageNum: 1, pageSize: 1000 }),
    pageCompanies({ pageNum: 1, pageSize: 1000 }),
    getRoleList()
  ])
  
  // 注意：这里直接取 res.list，因为 request.js 拦截器已经解包了一层
  userOptions.value = usersRes.list || []
  allCompanies.value = companiesRes.list || []
  allRoles.value = rolesRes.list || []
})

// 用户切换时清空列表
function handleUserChange() {
  rows.value = []
  draft.value = []
}

// 加载该用户的分配关系
async function load() {
  if (!selectedUserId.value) return
  loading.value = true
  try {
    const res = await getUserCompanies(selectedUserId.value)
    // 后端返回的是 List<UserCompanyRole>，需要补充 companyName 和 roleCode 显示
    const list = Array.isArray(res) ? res : (res.data || [])
    rows.value = list.map(item => {
      const company = allCompanies.value.find(c => c.id === item.companyId)
      const role = allRoles.value.find(r => r.id === item.roleId)
      return {
        ...item,
        companyName: company ? company.companyName : '未知公司',
        roleCode: role ? role.roleCode : '未知角色'
      }
    })
  } finally {
    loading.value = false
  }
}

// 添加到草稿
function addOne() {
  if (!assign.companyId || !assign.roleId) {
    ElMessage.warning('请选择公司和角色')
    return
  }
  // 检查重复
  //const exists = rows.value.find(
  //  r => r.companyId === assign.companyId && r.roleId === assign.roleId
  //)
  const exists = draft.value.find(d => d.companyId === assign.companyId && d.roleId === assign.roleId)
  if (exists) {
    ElMessage.warning('该用户在此公司已分配此角色')
    return
  }
  
  //const company = allCompanies.value.find(c => c.id === assign.companyId)
  //const role = allRoles.value.find(r => r.id === assign.roleId)
  
  //rows.value.push({
  //  userId: selectedUserId.value,
  //  companyId: assign.companyId,
  //  roleId: assign.roleId,
  //  companyName: company ? company.companyName : '',
  //  roleCode: role ? role.roleCode : ''
 //})

  draft.value.push({
    userId: selectedUserId.value,
    companyId: assign.companyId,
    roleId: assign.roleId
  })
  
  assign.companyId = null
  assign.roleId = null
}

// 提交保存
async function submit() {
  if (!selectedUserId.value) return
  //if (rows.value.length === 0) 
  if (draft.value.length === 0)
  {
    ElMessage.warning('请至少添加一条分配关系')
    return
  }
  
  // 只提交 userId, companyId, roleId
  //const submitData = rows.value.map(({ userId, companyId, roleId }) => ({
  //  userId,
  //  companyId,
  //  roleId
  //}))

  const submitData = draft.value.map(({ userId, companyId, roleId }) => ({
    userId, companyId, roleId
  }))
  
  await assignCompanies(selectedUserId.value, submitData)
  ElMessage.success('保存成功')
  load() // 重新加载
}
</script>