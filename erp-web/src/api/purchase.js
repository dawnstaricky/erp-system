import request from './request'

export function createPurchase(data) {
  return request.post('/purchase/create', data)
}

export function stockIn(orderId) {
  return request.post(`/purchase/stock-in/${orderId}`)
}

export function batchStockIn(orderIds, operatorId) {
  return request.post(`/purchase/batch-stock-in?operatorId=${operatorId}`, orderIds)
}

export function getDraftList(purchaserId) {
  return request.get('/purchase/draft-list', { params: { purchaserId } })
}

export function downloadTemplate() {
  return request.get('/purchase/import-template', { responseType: 'blob' })
}

export function importPurchase(file, purchaserId) {
  const formData = new FormData()
  formData.append('file', file)
  return request.post(`/purchase/import?purchaserId=${purchaserId}`, formData, {
    headers: { 'Content-Type': 'multipart/form-data' }
  })
}

export function exportPurchase(params) {
  return request.get('/purchase/export', { params, responseType: 'blob' })
}

// 获取采购订单分页列表
export function getPurchaseOrderList(params) {
  return request.get('/purchase/order/list', { params })
}

export function getPurchaseOrderDetail(id) {
  return request.get(`/purchase/detail/${id}`)
}

// ✅ 新增导出方法，对接后端已集成的接口
export function exportPurchaseOrder(params) {
  return request.get('/purchase/export', {
    params,
    responseType: 'blob' // 必须加，用于接收二进制流
  })
}
