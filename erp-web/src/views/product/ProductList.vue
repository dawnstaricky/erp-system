<template>
  <div class="page-container">
    <div class="toolbar">
      <el-input
        v-model="searchKeyword"
        placeholder="搜索商品名称/SKU编码"
        clearable
        style="width: 260px"
        @keyup.enter="handleSearch"
      />
      <el-button type="primary" @click="handleSearch">搜索</el-button>
      <el-button @click="resetSearch">重置</el-button>
      <div style="flex:1"></div>
      <el-button type="primary" @click="openAddDialog">
        <el-icon><Plus /></el-icon> 新增商品
      </el-button>
    </div>

    <el-table :data="tableData" stripe v-loading="loading" border>
      <el-table-column prop="id" label="ID" width="60" />
      <el-table-column prop="skuCode" label="SKU编码" width="160" />
      <el-table-column prop="productName" label="商品名称" show-overflow-tooltip />
      <el-table-column prop="spec" label="规格" width="120" />
      <el-table-column prop="unit" label="单位" width="80" />
      <el-table-column prop="costPrice" label="成本价" width="100">
        <template #default="{ row }">{{ formatMoney(row.costPrice) }}</template>
      </el-table-column>
      <el-table-column prop="salePrice" label="售价" width="100">
        <template #default="{ row }">{{ formatMoney(row.salePrice) }}</template>
      </el-table-column>
      <el-table-column prop="status" label="状态" width="80">
        <template #default="{ row }">
          <el-tag :type="row.status === 1 ? 'success' : 'danger'">
            {{ row.status === 1 ? '启用' : '停用' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="150" fixed="right">
        <template #default="{ row }">
          <el-button type="primary" link @click="openEditDialog(row)">编辑</el-button>
          <el-button type="danger" link @click="handleDelete(row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <el-pagination
      v-model:current-page="pageNum"
      v-model:page-size="pageSize"
      :total="total"
      :page-sizes="[10, 20, 50]"
      layout="total, sizes, prev, pager, next, jumper"
      style="margin-top: 16px; justify-content: flex-end;"
      @size-change="loadData"
      @current-change="loadData"
    />

    <!-- 新增/编辑弹窗 -->
    <el-dialog v-model="dialogVisible" :title="dialogTitle" width="500px" destroy-on-close>
      <el-form ref="formRef" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="SKU编码" prop="skuCode">
          <el-input v-model="form.skuCode" placeholder="留空自动生成" />
        </el-form-item>
        <el-form-item label="商品名称" prop="productName">
          <el-input v-model="form.productName" />
        </el-form-item>
        <el-form-item label="规格">
          <el-input v-model="form.spec" />
        </el-form-item>
        <el-form-item label="单位">
          <el-input v-model="form.unit" placeholder="台/个/箱" />
        </el-form-item>
        <el-form-item label="成本价">
          <el-input-number v-model="form.costPrice" :precision="2" :min="0" style="width:100%" />
        </el-form-item>
        <el-form-item label="售价">
          <el-input-number v-model="form.salePrice" :precision="2" :min="0" style="width:100%" />
        </el-form-item>
        <el-form-item label="最低库存">
          <el-input-number v-model="form.minStock" :min="0" style="width:100%" />
        </el-form-item>
        <el-form-item label="状态">
          <el-switch v-model="form.status" :active-value="1" :inactive-value="0" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="submitting" @click="handleSubmit">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getProductList, addProduct, updateProduct, deleteProduct } from '@/api/product'

const loading = ref(false)
const tableData = ref([])
const total = ref(0)
const pageNum = ref(1)
const pageSize = ref(10)
const searchKeyword = ref('')

const dialogVisible = ref(false)
const dialogTitle = ref('新增商品')
const submitting = ref(false)
const formRef = ref()
const form = reactive({
  id: null,
  skuCode: '',
  productName: '',
  spec: '',
  unit: '台',
  costPrice: 0,
  salePrice: 0,
  minStock: 0,
  status: 1
})

const rules = {
  productName: [{ required: true, message: '请输入商品名称', trigger: 'blur' }]
}

function formatMoney(val) {
  if (!val) return '¥0.00'
  return '¥' + Number(val).toLocaleString('zh-CN', { minimumFractionDigits: 2 })
}

async function loadData() {
  loading.value = true
  try {
    const data = await getProductList({
      pageNum: pageNum.value,
      pageSize: pageSize.value,
      keyword: searchKeyword.value
    })
    tableData.value = data.list || []
    total.value = data.total || 0
  } catch (e) {} finally {
    loading.value = false
  }
}

function handleSearch() {
  pageNum.value = 1
  loadData()
}

function resetSearch() {
  searchKeyword.value = ''
  pageNum.value = 1
  loadData()
}

function openAddDialog() {
  dialogTitle.value = '新增商品'
  Object.assign(form, {
    id: null, skuCode: '', productName: '', spec: '', unit: '台',
    costPrice: 0, salePrice: 0, minStock: 0, status: 1
  })
  dialogVisible.value = true
}

function openEditDialog(row) {
  dialogTitle.value = '编辑商品'
  Object.assign(form, row)
  dialogVisible.value = true
}

async function handleSubmit() {
  await formRef.value.validate()
  submitting.value = true
  try {
    if (form.id) {
      await updateProduct(form)
      ElMessage.success('更新成功')
    } else {
      await addProduct(form)
      ElMessage.success('新增成功')
    }
    dialogVisible.value = false
    loadData()
  } catch (e) {} finally {
    submitting.value = false
  }
}

function handleDelete(row) {
  ElMessageBox.confirm(`确定删除商品"${row.productName}"吗？`, '提示', {
    type: 'warning'
  }).then(async () => {
    await deleteProduct(row.id)
    ElMessage.success('删除成功')
    loadData()
  }).catch(() => {})
}

onMounted(loadData)
</script>

<style scoped>
.page-container {
  padding: 0;
}
.toolbar {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 16px;
}
</style>