import request from './request'
export function pageArchives(params) { return request({ url: '/archive/list', method: 'get', params }) }
export function refreshArchive(companyId, orderId) { return request({ url: '/archive/refresh/' + orderId + '?companyId=' + companyId, method: 'post' }) }
