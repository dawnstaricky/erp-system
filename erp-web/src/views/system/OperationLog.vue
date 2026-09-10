<template>
  <div class="page-container">
    <div class="toolbar">
      <el-input v-model="searchForm.keyword" placeholder="用户名/模块/操作" clearable style="width:200px" @keyup.enter="loadData" />
      <el-select v-model="searchForm.module" placeholder="模块" clearable style="width:150px;margin:0 10px">
        <el-option label="用户管理" value="用户管理" />
        <el-option label="角色管理" value="角色管理" />
        <el-option label="权限管理" value="权限管理" />
        <el-option label="采购管理" value="采购管理" />
        <el-option label="销售管理" value="销售管理" />
        <el-option label="报销管理" value="报销管理" />
      </el-select>
      <el-select v-model="searchForm.status" placeholder="状态" clearable style="width:120px">
        <el-option label="成功" :value="1" />
        <el-option label="失败" :value="0" />
      </el-select>
      <el-date-picker
        v-model="dateRange"
        type="daterange"
        range-separator="至"
        start-placeholder="开始日期"
        end-placeholder="结束日期"
        value-format="YYYY-MM-DD"
        style="margin:0 10px"
      />
      <el-button type="primary" @click="loadData">搜索</el-button>
      <el-button @click="resetSearch">重置</el-button>
    </div>

    <el-table :data="tableData" stripe v-loading="loading" border height="calc(100vh - 280px)">
      <el-table-column prop="id" label="ID" width="80" fixed="left" />
      <el-table-column prop="username" label="操作用户" width="120" />
      <el-table-column prop="module" label="模块" width="120" />
      <el-table-column prop="action" label="操作动作" width="180" show-overflow-tooltip />
      <el-table-column prop="method" label="请求方法" width="220" show-overflow-tooltip />
      <el-table-column prop="params" label="请求参数" min-width="250" show-overflow-tooltip />
      <el-table-column prop="ipAddress" label="IP地址" width="140" />
      <el-table-column prop="status" label="状态" width="80" fixed="right">
        <template #default="{row}">
          <el-tag :type="row.status === 1 ? 'success' : 'danger'" size="small">
            {{ row.status === 1 ? '成功' : '失败' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="errorMsg" label="错误信息" min-width="200" show-overflow-tooltip />
      <el-table-column prop="operationTime" label="操作时间" width="180" fixed="right" />
    </el-table>

    <el-pagination
      v-model:current-page="pageNum"
      v-model:page-size="pageSize"
      :total="total"
      :page-sizes="[10, 20, 50, 100]"
      layout="total, sizes, prev, pager, next, jumper"
      style="margin-top:16px;justify-content:flex-end"
      @size-change="loadData"
      @current-change="loadData"
    />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getOperationLogList } from '@/api/system'

const loading = ref(false)
const tableData = ref([])
const total = ref(0)
const pageNum = ref(1)
const pageSize = ref(20)
const dateRange = ref([])

const searchForm = ref({
  keyword: '',
  module: '',
  status: '',
  startDate: '',
  endDate: ''
})

const loadData = async () => {
  loading.value = true
  try {
    if (dateRange.value?.length === 2) {
      searchForm.value.startDate = dateRange.value[0]
      searchForm.value.endDate = dateRange.value[1]
    } else {
      searchForm.value.startDate = ''
      searchForm.value.endDate = ''
    }
    const res = await getOperationLogList({
      pageNum: pageNum.value,
      pageSize: pageSize.value,
      keyword: searchForm.value.keyword,
      module: searchForm.value.module,
      startDate: searchForm.value.startDate,
      endDate: searchForm.value.endDate
    })
    tableData.value = res.list || []
    total.value = res.total || 0
  } catch (e) {
    ElMessage.error(e.message || '加载失败')
  } finally {
    loading.value = false
  }
}

const resetSearch = () => {
  searchForm.value = { keyword: '', module: '', status: '', startDate: '', endDate: '' }
  dateRange.value = []
  pageNum.value = 1
  loadData()
}

onMounted(() => {
  loadData()
})
</script>

<style scoped>
.page-container { padding: 20px; background: #fff; height: 100%; box-sizing: border-box; }
.toolbar { display: flex; align-items: center; margin-bottom: 16px; flex-wrap: wrap; gap: 8px; }
</style>