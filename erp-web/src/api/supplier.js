import request from './request'

export function getSupplierList(params) {
  return request.get('/supplier/list', { params })
}

export function addSupplier(data) {
  return request.post('/supplier/add', data)
}

export function updateSupplier(data) {
  return request.put('/supplier/update', data)
}

export function deleteSupplier(id) {
  return request.delete(`/supplier/${id}`)
}