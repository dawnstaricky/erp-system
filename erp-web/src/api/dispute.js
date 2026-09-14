import request from './request'
export function pageDisputes(params) { return request({ url: '/dispute/list', method: 'get', params }) }
export function createDispute(data) { return request({ url: '/dispute/create', method: 'post', data }) }
export function handleDispute(id, params) { return request({ url: '/dispute/handle/' + id, method: 'post', params }) }
