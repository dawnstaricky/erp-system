export function getToken() {
  return localStorage.getItem('token')
}

export function setToken(token) {
  localStorage.setItem('token', token)
}

export function removeToken() {
  localStorage.removeItem('token')
}

export function getUserInfo() {
  const user = localStorage.getItem('userInfo')
  return user ? JSON.parse(user) : null
}

export function setUserInfo(user) {
  localStorage.setItem('userInfo', JSON.stringify(user))
}

export function removeUserInfo() {
  localStorage.removeItem('userInfo')
}
