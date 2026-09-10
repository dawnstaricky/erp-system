import request from './request'

//export function getRoleList() {
//  return request.get('/role/list')
//}
// ✅ 支持传入分页/搜索参数，无参数时调用原有逻辑，返回所有角色
export function getRoleList(params) {
  // params可选，不传时等价于原来的无参数调用
  return request.get('/role/list', { params })
}

export function addRole(data) {
  return request.post('/role/add', data)
}

export function updateRole(data) {
  return request.put('/role/update', data)
}

export function deleteRole(id) {
  return request.delete(`/role/${id}`)
}

export function assignUserRoles(userId, roleIds) {
  return request.post(`/user/assign-roles?userId=${userId}`, roleIds)
}