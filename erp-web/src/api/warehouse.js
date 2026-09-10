import request from './request'

export function getWarehouseList(params) {
  return request.get('/warehouse/list', { params })
}

export function addWarehouse(data) {
  return request.post('/warehouse/add', data)
}

export function updateWarehouse(data) {
  return request.put('/warehouse/update', data)
}

export function deleteWarehouse(id) {
  return request.delete(`/warehouse/${id}`)
}

export function disableWarehouse(id) { return request.put(`/warehouse/disable/${id}`) }
export function enableWarehouse(id)  { return request.put(`/warehouse/enable/${id}`)  }