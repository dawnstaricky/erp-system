import request from './request'

export function getDashboard() {
  return request.get('/report/dashboard')
}

export function getSalesDaily(params) {
  return request.get('/report/sales-daily', { params })
}

export function getSalesMonthly(params) {
  return request.get('/report/sales-monthly', { params })
}

export function getProductRank(params) {
  return request.get('/report/product-rank', { params })
}

export function getCustomerRank(params) {
  return request.get('/report/customer-rank', { params })
}

export function getInventoryAnalysis(params) {
  return request.get('/report/inventory-analysis', { params })
}

export function exportSalesDaily(params) {
  return request.get('/report/export/sales-daily', { params, responseType: 'blob' })
}

export function exportProductRank(params) {
  return request.get('/report/export/product-rank', { params, responseType: 'blob' })
}

export function exportInventoryAnalysis(params) {
  return request.get('/report/export/inventory-analysis', { params, responseType: 'blob' })
}