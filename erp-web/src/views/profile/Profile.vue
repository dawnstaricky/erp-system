<template>
  <div class="profile-container">
    <el-row :gutter="20">
      <!-- 个人信息 -->
      <el-col :span="12">
        <el-card shadow="hover">
          <template #header><span>个人信息</span></template>
          <el-form ref="profileFormRef" :model="profileForm" :rules="profileRules" label-width="100px">
            <el-form-item label="登录账号"><el-input v-model="profileForm.username" disabled /></el-form-item>
            <el-form-item label="真实姓名">
              <el-input v-model="profileForm.realName" disabled hint="由管理员维护" />
            </el-form-item>
            <el-form-item label="部门ID">
              <el-input v-model="profileForm.deptId" disabled hint="由管理员维护" />
            </el-form-item>
            <el-form-item label="手机号" prop="phone"><el-input v-model="profileForm.phone" /></el-form-item>
            <el-form-item label="邮箱" prop="email"><el-input v-model="profileForm.email" /></el-form-item>
            <el-form-item label="头像URL"><el-input v-model="profileForm.avatar" placeholder="粘贴头像图片地址" /></el-form-item>
            <el-form-item label="岗位">
              <el-tag :type="roleType(profileForm.role)">{{ roleText(profileForm.role) }}</el-tag>
            </el-form-item>
            <el-form-item>
              <el-button type="primary" :loading="profileSubmitting" @click="handleUpdateProfile">保存</el-button>
            </el-form-item>
          </el-form>
        </el-card>
      </el-col>

      <!-- 修改密码 -->
      <el-col :span="12">
        <el-card shadow="hover">
          <template #header><span>修改密码</span></template>
          <el-form ref="pwdFormRef" :model="pwdForm" :rules="pwdRules" label-width="100px">
            <el-form-item label="旧密码" prop="oldPassword">
              <el-input v-model="pwdForm.oldPassword" type="password" show-password />
            </el-form-item>
            <el-form-item label="新密码" prop="newPassword">
              <el-input v-model="pwdForm.newPassword" type="password" show-password />
            </el-form-item>
            <el-form-item label="确认新密码" prop="confirmPassword">
              <el-input v-model="pwdForm.confirmPassword" type="password" show-password />
            </el-form-item>
            <el-form-item>
              <el-button type="primary" :loading="pwdSubmitting" @click="handleChangePassword">修改密码</el-button>
            </el-form-item>
          </el-form>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { changePassword, updateProfile } from '@/api/user'
import { getProfile } from '@/api/auth' // 你已有的获取当前用户信息接口

const profileFormRef = ref()
const pwdFormRef = ref()
const profileSubmitting = ref(false)
const pwdSubmitting = ref(false)

const profileForm = reactive({ id:null, username:'', realName:'', deptId:null, phone:'', email:'', avatar:'', role:'' })
const pwdForm = reactive({ oldPassword:'', newPassword:'', confirmPassword:'' })

const profileRules = {
  phone: [{ pattern:/^1[3-9]\d{9}$/, message:'手机号格式不正确', trigger:'blur' }],
  email: [{ type:'email', message:'邮箱格式不正确', trigger:'blur' }]
}
const pwdRules = {
  oldPassword: [{ required:true, message:'请输入旧密码', trigger:'blur' }],
  newPassword: [{ required:true, message:'请输入新密码', trigger:'blur' },{ min:6,max:20,message:'密码长度6-20位',trigger:'blur' }],
  confirmPassword: [
    { required:true, message:'请确认新密码', trigger:'blur' },
    { validator:(r,v,cb)=> v!==pwdForm.newPassword ? cb(new Error('两次密码不一致')) : cb(), trigger:'blur' }
  ]
}

function roleType(r){ return {admin:'danger',manager:'warning',staff:'primary',finance:'success'}[r]||'info' }
function roleText(r){ return {admin:'管理员',gm:'总经理',manager:'经理',staff:'员工',finance:'财务'}[r]||'未知' }

async function loadProfile(){
  try {
    const data = await getProfile() // 返回 User 对象（无密码）
    Object.assign(profileForm, data)
  } catch(e){ ElMessage.error('加载个人信息失败') }
}

async function handleUpdateProfile(){
  await profileFormRef.value.validate()
  profileSubmitting.value=true
  try {
    // 只传允许改的字段
    await updateProfile({ phone:profileForm.phone, email:profileForm.email, avatar:profileForm.avatar })
    ElMessage.success('个人信息更新成功')
  } catch(e){ ElMessage.error(e.message||'更新失败') }
  finally { profileSubmitting.value=false }
}

async function handleChangePassword(){
  await pwdFormRef.value.validate()
  pwdSubmitting.value=true
  try {
    await changePassword({ oldPassword:pwdForm.oldPassword, newPassword:pwdForm.newPassword })
    ElMessage.success('密码修改成功，请重新登录')
    setTimeout(()=>{ localStorage.removeItem('token'); window.location.href='/login' },1500)
  } catch(e){ ElMessage.error(e.message||'修改失败') }
  finally { pwdSubmitting.value=false }
}

onMounted(loadProfile)
</script>

<style scoped>
.profile-container{padding:0}
</style>