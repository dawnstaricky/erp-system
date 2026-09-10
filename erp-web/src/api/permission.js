import request from './request'

// 获取权限列表
export function getPermissionList(params) {
  return request.get('/permission/list', { params })  
}

// 新增：获取全部权限（不分页），专给角色分配用
export function getAllPermissions() {
  return request.get('/permission/list', { params: { pageNum: 1, pageSize: 9999 } })
}

// 新增权限
export function addPermission(data) {
  return request.post('/permission/add', data)
}

// 更新权限
export function updatePermission(data) {
  return request.put('/permission/update', data)
}

// 删除权限
export function deletePermission(id) {
  return request.delete(`/permission/${id}`)
}

// 获取角色权限
export function getRolePermissions(roleId) {
  return request.get(`/permission/role/${roleId}`)
}

// 分配角色权限
export function assignRolePermissions(roleId, permissionIds) {
  return request.post('/permission/assign', {
    roleId,
    permissionIds
  })
}