<template>
  <div class="no-company">
    <el-result icon="warning" title="您还未分配公司">
      <template #sub-title>
        <p>请联系管理员为您分配公司及角色权限。</p>
      </template>
    </el-result>
  </div>
</template>

<style scoped>
.no-company { display: flex; align-items: center; justify-content: center; height: 100vh; }
</style>
