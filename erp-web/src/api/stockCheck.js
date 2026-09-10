import request from './request'

export function createCheck(data) {
  return request.post('/stock-check/create', data)
}

export function approveCheck(checkId) {
  return request.post(`/stock-check/approve/${checkId}`)
}

export function getCheckList(params) {
  return request.get('/stock-check/list', { params })
}