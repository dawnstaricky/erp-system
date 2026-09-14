import request from './request'
export function pageReceipts(params) { return request({ url: '/sales/receipt/list', method: 'get', params }) }
export function createReceipt(data) { return request({ url: '/sales/receipt/create', method: 'post', data }) }
