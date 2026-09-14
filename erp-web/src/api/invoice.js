import request from './request'
export function pageInvoices(params) { return request({ url: '/sales/invoice/list', method: 'get', params }) }
export function createInvoice(data) { return request({ url: '/sales/invoice/create', method: 'post', data }) }
export function voidInvoice(id) { return request({ url: '/sales/invoice/void/' + id, method: 'post' }) }
