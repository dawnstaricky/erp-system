import { defineStore } from 'pinia'
import { ref } from 'vue'
import { getToken, setToken, removeToken, setUserInfo, removeUserInfo } from '@/utils/auth'

export const useUserStore = defineStore('user', () => {
  const token = ref(getToken() || '')
  const userInfo = ref(null)
  const currentCompanyId = ref(null)   // 多公司：当前选中公司ID（管理员可为空）

  function setLoginData(data) {
    token.value = data.token
    setToken(data.token)
    const userInfoData = {
      userId: data.userId,
      username: data.username,
      realName: data.realName,
      roles: data.roles || (data.role ? [data.role] : []),
      role: data.role,
      companies: data.companies || []   // 多公司：可访问的公司列表 [{companyId,companyName,roleId,roleCode}]
    }
    userInfo.value = userInfoData
    setUserInfo(userInfoData)
    // 默认选中第一家（管理员不自动选）
    if (userInfoData.companies.length && !(userInfoData.roles||[]).includes('ADMIN')) {
      currentCompanyId.value = userInfoData.companies[0].companyId
    }
  }

  function setCurrentCompany(id) {
    currentCompanyId.value = id
    if (userInfo.value) {
      userInfo.value.currentCompanyId = id
      setUserInfo(userInfo.value)
    }
  }

  function logout() {
    token.value = ''
    userInfo.value = null
    currentCompanyId.value = null
    removeToken()
    removeUserInfo()
  }

  async function getUserInfo() {
    if (!token.value) return null
    try {
      const stored = JSON.parse(localStorage.getItem('userInfo') || '{}')
      if (stored.userId) { userInfo.value = stored; currentCompanyId.value = stored.currentCompanyId || null; return stored }
      return null
    } catch (e) { return null }
  }

  return { token, userInfo, currentCompanyId, setLoginData, setCurrentCompany, logout, getUserInfo }
})
