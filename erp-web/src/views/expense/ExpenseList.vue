<template>
  <div class="page-container">
    <el-tabs v-model="activeTab">
      <el-tab-pane label="我的报销单" name="my">
        <div class="toolbar">
          <el-button type="primary" @click="dialogVisible = true">
            <el-icon><Plus /></el-icon> 提交报销
          </el-button>
        </div>
        <el-table :data="myList" stripe v-loading="loading" border>
          <el-table-column prop="formNo" label="单号" width="180" />
          <el-table-column prop="totalAmount" label="金额" width="120">
            <template #default="{ row }">{{ formatMoney(row.totalAmount) }}</template>
          </el-table-column>
          <el-table-column prop="reason" label="事由" show-overflow-tooltip />
          <el-table-column prop="status" label="状态" width="100">
            <template #default="{ row }">
              <el-tag :type="statusType(row.status)">{{ statusText(row.status) }}</el-tag>
            </template>
          </el-table-column>
          <el-table-column label="操作" width="80">
            <template #default="{ row }">
              <el-button link @click="showDetail(row)">详情</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-tab-pane>

      <el-tab-pane label="待我审批" name="pending">
        <el-table :data="pendingList" stripe v-loading="loading" border>
          <el-table-column prop="formNo" label="单号" width="180" />
          <el-table-column prop="totalAmount" label="金额" width="120">
            <template #default="{ row }">{{ formatMoney(row.totalAmount) }}</template>
          </el-table-column>
          <el-table-column prop="reason" label="事由" show-overflow-tooltip />
          <el-table-column label="操作" width="160">
            <template #default="{ row }">
              <el-button type="primary" link @click="showDetail(row)">查看</el-button>
              <el-button v-role="['ADMIN', 'FINANCE', 'DEPT_MANAGER', 'GM']" type="success" size="small" @click="handleApprove(row, 1)">同意</el-button>
              <el-button v-role="['ADMIN', 'FINANCE', 'DEPT_MANAGER', 'GM']" type="danger" size="small" @click="handleApprove(row, 0)">驳回</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-tab-pane>
    </el-tabs>

    <!-- 提交报销弹窗 -->
    <el-dialog v-model="dialogVisible" title="提交报销单" width="600px" destroy-on-close>
      <el-form ref="formRef" :model="form" label-width="100px">
        <el-form-item label="申请日期">
          <el-date-picker v-model="form.applyDate" type="date" value-format="YYYY-MM-DD" style="width:100%" />
        </el-form-item>
        <el-form-item label="事由">
          <el-input v-model="form.reason" type="textarea" :rows="2" />
        </el-form-item>

        <!-- 新增：多文件上传（支持发票） -->
        <el-form-item label="发票附件">
          <el-upload
            v-model:file-list="fileList"
            multiple
            accept=".pdf,.jpg,.jpeg,.png"
            :limit="5"
            :on-exceed="() => ElMessage.warning('最多上传5个附件')"
            :auto-upload="false"
            :show-file-list="true"
          >
            <el-button type="primary">选择发票文件</el-button>
            <template #tip>
              <div class="el-upload__tip">支持PDF/JPG/PNG，最多5个，单个≤10MB</div>
            </template>
          </el-upload>
        </el-form-item>

        <el-divider>费用明细</el-divider>
        <div v-for="(item, idx) in form.items" :key="idx" class="item-row">
          <el-select v-model="item.expenseTypeId" placeholder="类型" style="width:120px">
            <el-option :value="1" label="差旅" />
            <el-option :value="2" label="住宿" />
            <el-option :value="3" label="餐饮" />
            <el-option :value="4" label="交通" />
            <el-option :value="5" label="办公" />
          </el-select>
          <el-date-picker v-model="item.expenseDate" type="date" value-format="YYYY-MM-DD" style="width:150px" />
          <el-input-number v-model="item.amount" :precision="2" :min="0" style="width:150px" placeholder="金额" />
          <el-button type="danger" circle @click="form.items.splice(idx, 1)" v-if="form.items.length > 1">
            <el-icon><Delete /></el-icon>
          </el-button>
        </div>
        <el-button @click="form.items.push({ expenseTypeId: null, expenseDate: '', amount: 0 })">
          <el-icon><Plus /></el-icon> 添加明细
        </el-button>
        <div class="total-row">合计：{{ formatMoney(totalAmount) }}</div>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="submitting" @click="handleSubmit">提交</el-button>
      </template>
    </el-dialog>

    <!-- 详情弹窗 -->
    <el-dialog v-model="detailVisible" title="报销单详情" width="600px">
      <div v-if="detail">
        <p><strong>单号：</strong>{{ detail.form?.formNo }}</p>
        <p><strong>金额：</strong>{{ formatMoney(detail.form?.totalAmount) }}</p>
        <p><strong>事由：</strong>{{ detail.form?.reason }}</p>

        <!-- ✅ 新增：报销明细（你要求的） -->
        <el-divider content-position="left">费用明细</el-divider>
        <el-table :data="detail.items" stripe border size="small">
          <el-table-column label="费用类型">
            <template #default="{ row }">
              {{ {1:'差旅',2:'住宿',3:'餐饮',4:'交通',5:'办公'}[row.expenseTypeId] }}
            </template>
          </el-table-column>
          <el-table-column prop="expenseDate" label="费用日期" width="120" />
          <el-table-column prop="amount" label="金额" width="120">
            <template #default="{ row }">{{ formatMoney(row.amount) }}</template>
          </el-table-column>
          <el-table-column prop="remark" label="备注" show-overflow-tooltip />
        </el-table>

        <!-- ✅ 新增：多附件预览列表（解决只取第一个的问题） -->
        <el-divider />
        <h4>发票附件</h4>
        <div v-if="detail.form?.attachmentUrls?.length" class="attachment-list">
          <div v-for="(url, index) in detail.form.attachmentUrls" :key="index" class="attachment-item">
            <el-button type="primary" link @click="previewAttachment(url)">
              附件{{ index + 1 }}：{{ url.substring(url.lastIndexOf('/') + 1) }}
            </el-button>
          </div>
        </div>
        <div v-else class="no-attachment">无附件</div>

        <el-divider />
        <h4>审批记录</h4>
        <el-timeline>
          <el-timeline-item v-for="r in detail.records" :key="r.id">
            {{ r.approveTime }} - 
            <el-tag :type="r.approveResult === 1 ? 'success' : 'danger'">
              {{ r.approveResult === 1 ? '同意' : '驳回' }}
            </el-tag>
            - {{ r.approveComment || '无备注' }}
          </el-timeline-item>
        </el-timeline>
      </div>

      <!-- ✅ 新增：附件预览弹窗（解决401问题，用request自动带token） -->
      <el-dialog v-model="previewVisible" title="发票预览" width="80%" append-to-body>
        <div v-if="previewUrl">
          <iframe :src="previewUrl" style="width:100%;height:600px;border:none"></iframe>
        </div>
        <div v-else class="no-preview">预览失败</div>
        <template #footer>
          <el-button @click="previewVisible = false">关闭</el-button>
          <el-button type="primary" @click="handlePrint">打印</el-button>
        </template>
      </el-dialog>

    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { submitExpense, approveExpense, getMyExpense, getPendingExpense, getExpenseDetail,uploadExpenseAttachments,previewExpenseAttachment } from '@/api/expense'
import { useUserStore } from '@/stores/user'

const activeTab = ref('my')
const loading = ref(false)
const myList = ref([])
const pendingList = ref([])
const dialogVisible = ref(false)
const detailVisible = ref(false)
const detail = ref(null)
const submitting = ref(false)
const fileList = ref([]) // 上传的文件列表

// ✅ 新增：附件相关变量
const attachmentFiles = ref([]) // 上传的附件文件列表
const previewVisible = ref(false) // 预览弹窗显示状态
const previewUrl = ref('') // 预览的URL

const form = reactive({
  applicantId: 7,
  deptId: 4,
  applyDate: new Date().toISOString().slice(0, 10),
  reason: '',
  items: [{ expenseTypeId: 1, expenseDate: new Date().toISOString().slice(0, 10), amount: 0 }]
})

const totalAmount = computed(() => {
  return form.items.reduce((sum, i) => sum + (i.amount || 0), 0)
})

function formatMoney(val) {
  if (!val) return '¥0.00'
  return '¥' + Number(val).toLocaleString('zh-CN', { minimumFractionDigits: 2 })
}

function statusType(s) {
  return { 0: 'info', 1: 'warning', 2: 'success', 3: 'danger', 4: 'primary' }[s] || 'info'
}

function statusText(s) {
  return { 0: '草稿', 1: '审批中', 2: '已通过', 3: '已驳回', 4: '已付款' }[s] || '未知'
}

async function loadMy() {
  try { myList.value = await getMyExpense() } catch (e) {}
}

async function loadPending() {
  try { 
    const userStore = useUserStore()
    //const currentUserId = localStorage.getItem('userId')
    const currentUserId = userStore.userinfo?.userId || 0
    console.log('loadPending currentUserId:', userStore.userinfo?.userId )
    pendingList.value = await getPendingExpense() 
  } catch (e) {ElMessage.error(e.response?.data?.msg || '获取失败')}
}

// 提交报销单（同时传JSON和文件，解决404问题）
const handleSubmit = async () => {
  submitting.value = true
  try {
    const formData = new FormData()
    
    formData.append('form', new Blob([JSON.stringify({
      applyDate: form.applyDate,
      reason: form.reason,
      totalAmount: totalAmount.value   // 只传这三个必填
    })], { type: 'application/json' }))

    formData.append('items', new Blob([JSON.stringify(form.items)], { type: 'application/json' }))
    fileList.value.forEach(file => {
      formData.append('files', file.raw)
    })

    await submitExpense(formData)
    ElMessage.success('提交成功')
    dialogVisible.value = false
    fileList.value = []
    loadMy()
  } catch (e) {
    console.error('提交失败详情:', e.response?.data || e.message)
    ElMessage.error(e.response?.data?.msg || '提交失败')
  } finally {
    submitting.value = false
  }
}

function handleApprove(row, result) {
  const comment = result === 1 ? '同意' : '驳回'
  approveExpense(row.id, { approveResult: result, comment })
    .then(() => { ElMessage.success('操作成功'); loadPending() })
    .catch(() => {})
}

async function showDetail(row) {
  try {
    detail.value = await getExpenseDetail(row.id)
    // 将逗号分隔的URL转为数组，方便预览
    if (detail.value.form?.attachmentUrls) {
      detail.value.form.attachmentUrls = detail.value.form.attachmentUrls.split(',')
    }
    detailVisible.value = true
  } catch (e) {}
}

// ✅ 新增：预览附件（用request发请求，自动带token，解决401问题）
async function previewAttachment(url) {
  previewVisible.value = true
  try {
    const blob = await previewExpenseAttachment(url)
    previewUrl.value = URL.createObjectURL(blob)
  } catch (e) {
    ElMessage.error(e.message || '预览失败')
    previewVisible.value = false
  }
}

// ✅ 新增：打印附件
function handlePrint() {
  const iframe = document.querySelector('iframe')
  if (iframe) iframe.contentWindow.print()
}

onMounted(() => { loadMy(); loadPending() })
</script>

<style scoped>
.page-container { padding: 0; }
.toolbar { margin-bottom: 16px; }
.item-row { display: flex; gap: 10px; margin-bottom: 10px; align-items: center; }
.total-row { margin-top: 12px; font-size: 16px; font-weight: bold; text-align: right; }
</style>