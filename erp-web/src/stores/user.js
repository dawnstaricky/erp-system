import { defineStore } from 'pinia'
import { ref } from 'vue'
import { getToken, setToken, removeToken, setUserInfo, removeUserInfo } from '@/utils/auth'

export const useUserStore = defineStore('user', () => {
  const token = ref(getToken() || '')
  const userInfo = ref(null)

  function setLoginData(data) {
    token.value = data.token
    setToken(data.token)

    // 构造完整的用户信息对象，包含role
    const userInfoData = {
      userId: data.userId,
      username: data.username,
      realName: data.realName,
      // 优先使用后端返回的 roles 数组，如果没有则用单个 role 包装成数组
      roles: data.roles || (data.role ? [data.role] : []),
      role: data.role // 保留单个 role 用于兼容旧逻辑
    }
    userInfo.value = userInfoData
    setUserInfo(userInfoData) // 持久化到localStorage
  }

  function logout() {
    token.value = ''
    userInfo.value = null
    removeToken()
    removeUserInfo()
  }

  // 新增：获取用户信息的方法（供路由守卫调用）
  async function getUserInfo() {
    if (!token.value) return null
    
    try {
      // 这里假设有一个获取用户信息的API，如果没有，可以直接从localStorage恢复
      const storedUserInfo = JSON.parse(localStorage.getItem('userInfo') || '{}')
      if (storedUserInfo.userId) {
        userInfo.value = storedUserInfo
        return storedUserInfo
      }
      return null
    } catch (error) {
      console.error('获取用户信息失败:', error)
      return null
    }
  }

  return { token, userInfo, setLoginData, logout }
})