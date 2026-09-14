import request from './request'
export function listCompanies() { return request({ url: '/sys/company/all', method: 'get' }) }
export function pageCompanies(params) { return request({ url: '/sys/company/page', method: 'get', params }) }
export function getCompany(id) { return request({ url: '/sys/company/' + id, method: 'get' }) }
export function addCompany(data) { return request({ url: '/sys/company', method: 'post', data }) }
export function updateCompany(data) { return request({ url: '/sys/company', method: 'put', data }) }
export function deleteCompany(id) { return request({ url: '/sys/company/' + id, method: 'delete' }) }
export function getUserCompanies(userId) { return request({ url: '/sys/user-company/' + userId, method: 'get' }) }
export function assignCompanies(userId, list) { return request({ url: '/sys/user-company/assign?userId=' + userId, method: 'post', data: list }) }
