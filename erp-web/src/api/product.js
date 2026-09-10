import request from './request'

export function getProductList(params) {
  return request.get('/product/list', { params })
}

export function addProduct(data) {
  return request.post('/product/add', data)
}

export function updateProduct(data) {
  return request.put('/product/update', data)
}

export function deleteProduct(id) {
  return request.delete(`/product/${id}`)
}