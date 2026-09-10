import request from './request'

// 管理员
export function addUser(data) {
  return request.post('/admin/user/add', data)
}
export function updateUser(data) {
  return request.put('/admin/user/update', data)
}
export function getUserList(params) {
  return request.get('/admin/user/list', { params })
}
export function deleteUser(userId) {
  return request.delete(`/admin/user/${userId}`)
}

// 当前用户
export function changePassword(params) {
  return request.post('/user/change-password', null, { params })
}
export function updateProfile(data) {
  return request.put('/user/profile', data)
}
export function getUserDepts(userId) {
  return request.get(`/user/depts/${userId}`)
}
export function getUserRoles(userId) {
  return request.get(`/user/${userId}/roles`)
}

export function getUserRoleIds(userId) {
  return request.get(`/user/${userId}/roleIds`)
}