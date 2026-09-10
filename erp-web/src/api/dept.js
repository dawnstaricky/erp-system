import request from './request'

export function getDeptList() {
  return request.get('/dept/list')
}

export function addDept(data) {
  return request.post('/dept/add', data)
}

export function updateDept(data) {
  return request.post('/dept/update', data)
}

// 正常用户列表（后端需要提供，查状态为1的用户）
export function getNormalUserList() {
  return request.get('/user/normal-list')
}