import request from './request'

// 提交报销单（支持文件上传）
export function submitExpense(formData) {
  return request.post('/expense/submit', formData)
}

export function approveExpense(formId, params) {
  return request.post(`/expense/approve/${formId}`, null, { params })
}

export function getMyExpense() {
  return request.get('/expense/my')
}

export function getPendingExpense() {
  return request.get('/expense/pending')
}

export function getExpenseDetail(formId) {
  return request.get(`/expense/${formId}`)
}

// ✅ 新增：上传附件方法
export function uploadExpenseAttachments(formId, formData) {
  return request.post(`/expense/upload-attachments/${formId}`, formData, {
    headers: { 'Content-Type': 'multipart/form-data' }
  })
}

// ✅ 新增：预览附件方法（用request发请求，自动带token，解决401问题）
export function previewExpenseAttachment(url) {
  return request.get('/expense/preview-attachment', {
    params: { url },
    responseType: 'blob' // 返回二进制流，用于预览
  })
}