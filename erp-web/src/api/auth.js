import request from './request'

export function login(data) {
  return request.post('/login', data)
}

export function getProfile() {
  return request.get('/user/info')
}

export function getUserInfo() {
  return request.get('/user/info')
}