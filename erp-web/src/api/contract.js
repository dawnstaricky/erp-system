import request from './request'
export function pagePurchaseContracts(params) { return request({ url: '/contract/purchase/list', method: 'get', params }) }
export function generatePurchaseContract(data) { return request({ url: '/contract/purchase/generate', method: 'post', data }) }
export function voidPurchaseContract(id) { return request({ url: '/contract/purchase/void/' + id, method: 'post' }) }
export function downloadPurchaseContract(id) { return request({ url: '/contract/purchase/download/' + id, method: 'get', responseType: 'blob' }) }

export function pageSalesContracts(params) { return request({ url: '/contract/sales/list', method: 'get', params }) }
export function generateSalesContract(data) { return request({ url: '/contract/sales/generate', method: 'post', data }) }
export function voidSalesContract(id) { return request({ url: '/contract/sales/void/' + id, method: 'post' }) }
export function downloadSalesContract(id) { return request({ url: '/contract/sales/download/' + id, method: 'get', responseType: 'blob' }) }
