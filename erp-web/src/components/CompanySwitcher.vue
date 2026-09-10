<template>
  <el-select
    v-model="currentCompanyId"
    placeholder="请选择公司"
    style="width: 200px; margin-right: 12px"
    @change="handleChange"
  >
    <el-option
      v-for="item in companies"
      :key="item.companyId"
      :label="item.companyName"
      :value="item.companyId"
    />
  </el-select>
</template>

<script setup>
import { computed } from 'vue'
import { useUserStore } from '@/stores/user'

const userStore = useUserStore()

const companies = computed(() => userStore.companies)
const currentCompanyId = computed({
  get: () => userStore.currentCompany?.companyId || null,
  set: (val) => val
})

function handleChange(val) {
  userStore.switchCompany(val)
  // 切换公司后刷新当前页面数据
  window.location.reload()
}
</script>
