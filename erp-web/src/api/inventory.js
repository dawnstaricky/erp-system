import request from './request'

export function getInventoryList(params) {
  return request.get('/inventory/list', { params })
}

export function getLowStock(params) {
  return request.get('/inventory/low-stock', { params })
}

export function exportForCheck(params) {
  return request.get('/inventory/export-for-check', { params, responseType: 'blob' })
}

export function exportFlow(params) {
  return request.get('/inventory/flow-export', { params, responseType: 'blob' })
}

// ✅ 新增预览方法，调用现有导出接口，返回blob流，自动带token
export function previewInventory(params) {
  return request.get('/inventory/export-for-check', {
    params,
    responseType: 'blob'
  })
}