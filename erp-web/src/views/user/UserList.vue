<template>
  <div class="page-container">
    <div class="toolbar">
      <el-input v-model="keyword" placeholder="搜索账号/姓名/手机" clearable style="width:260px" @keyup.enter="loadData" />
      <el-button type="primary" @click="loadData">搜索</el-button>
      <el-button @click="resetSearch">重置</el-button>
      <div style="flex:1"></div>
      <el-button v-role="['ADMIN']" type="primary" @click="openAdd">
        <el-icon><Plus /></el-icon> 新增用户
      </el-button>
    </div>

    <el-table :data="tableData" stripe v-loading="loading" border>
      <el-table-column prop="id" label="ID" width="60" />
      <el-table-column prop="username" label="登录账号" width="140" />
      <el-table-column prop="realName" label="真实姓名" width="120" />
      <el-table-column prop="phone" label="手机号" width="140" />
      <el-table-column prop="email" label="邮箱" show-overflow-tooltip />
      <el-table-column prop="role" label="岗位" width="100">
        <template #default="{ row }">
          <el-tag :type="roleType(row.role)">{{ roleText(row.role) }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="status" label="状态" width="80">
        <template #default="{ row }">
          <el-tag :type="row.status===1?'success':'danger'">
            {{ row.status===1?'启用':'停用' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="150" fixed="right">
        <template #default="{ row }">
          <el-button type="primary" link @click="openEdit(row)">编辑</el-button>
          <el-button v-role="['ADMIN']" type="danger" link @click="handleDelete(row)">删除</el-button>
          <el-button type="warning" link @click="openAssignRole(row)" v-role="['ADMIN']">分配角色</el-button>
        </template>
      </el-table-column>
    </el-table>

    <el-pagination v-model:current-page="pageNum" v-model:page-size="pageSize"
      :total="total" :page-sizes="[10,20,50]" layout="total,sizes,prev,pager,next,jumper"
      style="margin-top:16px;justify-content:flex-end"
      @size-change="loadData" @current-change="loadData" />

    <el-dialog v-model="dialogVisible" :title="dialogTitle" width="520px" destroy-on-close>
      <el-form ref="formRef" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="登录账号" prop="username">
          <el-input v-model="form.username" :disabled="!!form.id" />
        </el-form-item>
        <el-form-item label="真实姓名" prop="realName">
          <el-input v-model="form.realName" />
        </el-form-item>
        <el-form-item label="手机号">
          <el-input v-model="form.phone" />
        </el-form-item>
        <el-form-item label="邮箱">
          <el-input v-model="form.email" />
        </el-form-item>
		    <el-form-item label="岗位" prop="role">
          <el-select v-model="form.role" style="width:100%">
            <el-option label="员工" value="staff" />
            <el-option label="总经理" value="gm" />
            <el-option label="部门经理" value="manager" />
            <el-option label="财务" value="finance" />
            <el-option label="管理员" value="admin" />
          </el-select>
        </el-form-item>

        <el-form-item label="所属部门" prop="deptIds">
          <div class="dept-select-group">
            <el-select
              v-model="form.deptIds"
              multiple
              placeholder="请选择所属部门"
              style="width: 100%; margin-bottom: 8px"
            >
              <el-option
                v-for="dept in deptList"
                :key="dept.id"
                :label="dept.deptName"
                :value="dept.id"
              />
            </el-select>
            <!-- 新增：选择主部门 -->
            <div v-if="form.deptIds.length > 0">
              <span style="margin-right: 8px">主部门：</span>
              <el-radio-group v-model="form.mainDeptId">
                <el-radio 
                  v-for="deptId in form.deptIds" 
                  :key="deptId" 
                  :value="deptId"
                >
                  {{ deptList.find(d => d.id === deptId)?.deptName }}
                </el-radio>
              </el-radio-group>
            </div>
          </div>
        </el-form-item>

        <el-form-item label="状态" v-if="form.id">
          <el-switch v-model="form.status" :active-value="1" :inactive-value="0" />
        </el-form-item>
        <el-alert v-if="!form.id" title="默认密码为 123456" type="info" :closable="false" show-icon />
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible=false">取消</el-button>
        <el-button type="primary" :loading="submitting" @click="handleSubmit">确定</el-button>
      </template>
    </el-dialog>

    <el-dialog v-model="assignDialogVisible" title="分配角色" width="400px">
        <el-checkbox-group v-model="assignRoleIds" value-key="id">
            <el-checkbox v-for="r in allRoles" :key="r.id" :value="r.id">
            {{ r.roleName }}（{{ r.roleCode }}）
            </el-checkbox>
        </el-checkbox-group>
        <template #footer>
            <el-button @click="assignDialogVisible = false">取消</el-button>
            <el-button type="primary" @click="handleAssignSubmit">确定</el-button>
        </template>
    </el-dialog>

  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getUserList, addUser, updateUser, deleteUser, getUserDepts, getUserRoles, getUserRoleIds  } from '@/api/user'
import { assignUserRoles, getRoleList } from '@/api/role'
import { getDeptList } from '@/api/dept'

const loading = ref(false)
const tableData = ref([])
const total = ref(0)
const pageNum = ref(1)
const pageSize = ref(10)
const keyword = ref('')
const dialogVisible = ref(false)
const dialogTitle = ref('')
const submitting = ref(false)
const formRef = ref()
const form = reactive({ 
  id:null, 
  username:'', 
  realName:'', 
  phone:'', 
  email:'', 
  deptIds: [], 
  mainDeptId: null, 
  role:'staff', 
  status:1 })
const assignDialogVisible = ref(false)
const assignUserId = ref(null)
const assignRoleIds = ref([])
const allRoles = ref([])

// 加载部门列表（解决下拉无数据问题）
const deptList = ref([])
const loadDepts = async () => {
  try {
    deptList.value = await getDeptList() // 调用已有的/dept/list接口
    console.log('部门列表加载成功', deptList.value)
  } catch (e) {
    ElMessage.error('加载部门失败')
  }
}

async function openAssignRole(row) {
  assignUserId.value = row.id
  // 加载全部角色
  const res = await getRoleList()
  allRoles.value = res.list || []
  console.log('allRoles数据:', JSON.stringify(allRoles.value)) // ✅ 看数据结构
  console.log('第一条role的key:', Object.keys(allRoles.value[0] || {})) // ✅ 看字段名
  // ✅ 加载已有角色，不再空白
  try {
    const res = await getUserRoleIds(row.id) // 返回角色ID数组
    assignRoleIds.value = res || []
  } catch {
    assignRoleIds.value = []
  }
  assignDialogVisible.value = true
}

async function handleAssignSubmit() {
  await assignUserRoles(assignUserId.value, assignRoleIds.value)
  ElMessage.success('角色分配成功')
  assignDialogVisible.value = false
}

const rules = {
  username: [{ required:true, message:'请输入登录账号', trigger:'blur' }],
  realName: [{ required:true, message:'请输入真实姓名', trigger:'blur' }],
  role: [{ required:true, message:'请选择角色', trigger:'change' }]
}

function roleType(r){ return {admin:'danger',gm:'warning',manager:'warning',staff:'primary',finance:'success'}[r]||'info' }
function roleText(r){ return {admin:'管理员',gm:'总经理',manager:'部门经理',staff:'员工',finance:'财务'}[r]||'未知' }

async function loadData() {
  loading.value = true
  try {
    const data = await getUserList({ keyword:keyword.value, pageNum:pageNum.value, pageSize:pageSize.value })
    tableData.value = data.list || []
    total.value = data.total || 0
    loadDepts()
  } catch(e) { ElMessage.error(e.message||'加载失败') }
  finally { loading.value = false }
}

function resetSearch(){ keyword.value=''; pageNum.value=1; loadData() }

function openAdd(){
  dialogTitle.value='新增用户'
  Object.assign(form,{id:null,username:'',realName:'',phone:'',email:'',role:'staff',status:1,deptIds: [],mainDeptId: null})
  dialogVisible.value=true
}
async function openEdit(row){
  dialogTitle.value='编辑用户'
  Object.assign(form,row)
  dialogVisible.value=true

  // ✅ 仅重置部门相关，不丢其他字段
  form.deptIds = []
  form.mainDeptId = null
  // 加载用户已有部门
  try {
    const deptData = await getUserDepts(row.id)
    form.deptIds = deptData.deptIds || []
    form.mainDeptId = deptData.mainDeptId || null
  } catch (e) {
    ElMessage.error('加载用户部门失败')
  }
}

async function handleSubmit(){
  await formRef.value.validate()
  submitting.value=true
  const submitData = { ...form };
  try {
    if(form.id){ await updateUser(submitData); ElMessage.success('更新成功') }
    else { await addUser(submitData); ElMessage.success('新增成功，默认密码：123456') }
    dialogVisible.value=false; loadData()
  } catch(e){ ElMessage.error(e.message||'操作失败') }
  finally { submitting.value=false }
}

function handleDelete(row){
  ElMessageBox.confirm(`确定停用用户"${row.realName||row.username}"吗？`,'提示',{type:'warning'})
    .then(async()=>{
      await deleteUser(row.id); ElMessage.success('已停用'); loadData()
    }).catch(()=>{})
}

onMounted(loadData)
</script>

<style scoped>
.page-container{padding:0}
.toolbar{display:flex;align-items:center;gap:10px;margin-bottom:16px}
</style>