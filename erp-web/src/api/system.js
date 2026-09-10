import request from './request'
// 获取操作日志列表（调用你已有的/operation-log/list接口）
export function getOperationLogList(params) {
  return request.get('/operation-log/list', { params })
}