import request from './request'

export function createSales(data) {
  return request.post('/sales/create', data)
}

export function stockOut(orderId) {
  return request.post(`/sales/stock-out/${orderId}`)
}

export function batchStockOut(orderIds, operatorId) {
  return request.post(`/sales/batch-stock-out?operatorId=${operatorId}`, orderIds)
}

export function getDraftList(salesmanId) {
  return request.get('/sales/draft-list', { params: { salesmanId } })
}

export function downloadTemplate() {
  return request.get('/sales/import-template', { responseType: 'blob' })
}

export function importSales(file, salesmanId) {
  const formData = new FormData()
  formData.append('file', file)
  return request.post(`/sales/import?salesmanId=${salesmanId}`, formData, {
    headers: { 'Content-Type': 'multipart/form-data' }
  })
}

export function exportSaleOrder(params) {
  return request.get('/sales/export', { params, responseType: 'blob' })
}

export function getSalesOrderList(params) {
  return request.get('/sales/order/list', { params })
}

export function getSalesOrderDetail(id) {
  return request.get(`/sales/detail/${id}`)
}