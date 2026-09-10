import request from './request'

export function getCustomerList(params) {
  return request.get('/customer/list', { params })
}

export function addCustomer(data) {
  return request.post('/customer/add', data)
}

export function updateCustomer(data) {
  return request.put('/customer/update', data)
}

export function deleteCustomer(id) {
  return request.delete(`/customer/${id}`)
}