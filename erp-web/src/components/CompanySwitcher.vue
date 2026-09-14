<template>
  <div v-if="companies.length" class="company-switcher">
    <el-select v-model="currentId" placeholder="选择公司" size="default" style="width:170px" @change="onChange">
      <el-option v-if="isAdmin" label="管理后台（无公司）" :value="0" />
      <el-option v-for="c in companies" :key="c.companyId" :label="c.companyName" :value="c.companyId" />
    </el-select>
    <span v-if="!hasCompany" class="tip">（未分配公司，请联系管理员）</span>
  </div>
</template>
<script setup>
import { ref, computed, watch, onMounted } from 'vue'
import { useUserStore } from '@/stores/user'
import { useRouter, useRoute } from 'vue-router'
const userStore = useUserStore()
const router = useRouter(), route = useRoute()
const companies = ref([])
const currentId = ref(null)
const isAdmin = computed(() => (userStore.userInfo?.roles || []).includes('ADMIN'))
const hasCompany = computed(() => isAdmin.value || (companies.value.length > 0 && currentId.value > 0))
function load() {
  companies.value = userStore.userInfo?.companies || []
  const saved = userStore.userInfo?.currentCompanyId
  if (isAdmin.value) {
    currentId.value = saved && saved > 0 ? saved : null
  } else if (companies.value.length) {
    currentId.value = saved || companies.value[0].companyId
    userStore.setCurrentCompany(currentId.value)
  } else {
    currentId.value = null
  }
}
function onChange(val) {
  userStore.setCurrentCompany(val && val > 0 ? val : 0)
  // 切换公司刷新当前业务页（管理页不刷新）
  if (route.meta?.roles && !isAdmin.value) router.replace({ path: route.path, query: { _t: Date.now() } })
}
onMounted(load)
watch(() => userStore.userInfo, load)
</script>
<style scoped>
.company-switcher { display:inline-flex; align-items:center; margin-right:16px; }
.tip { color:#e6a23c; font-size:12px; margin-left:8px; }
</style>
