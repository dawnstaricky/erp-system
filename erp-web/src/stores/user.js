import { defineStore } from 'pinia'
import { login, logout, getUserInfo } from '@/api/user'
import { getToken, setToken, removeToken } from '@/utils/auth'

export const useUserStore = defineStore('user', {
  state: () => ({
    token: getToken(),
    userInfo: null,
    roles: [],          // 当前公司下的角色 code
    permissions: [],    // 当前公司下的权限标识
    companies: [],      // 可进入的公司列表 [{companyId, companyName, isMain, roleCodes}]
    currentCompany: null // 当前选中的公司 {companyId, companyName}
  }),

  actions: {
    setToken(token) {
      this.token = token
      setToken(token)
    },

    // 登录：返回中包含 companies
    async login(form) {
      const data = await login(form)
      this.setToken(data.token)
      return data
    },

    // 拉取用户信息 + 可进入的公司列表
    async fetchUserInfo() {
      const data = await getUserInfo()
      this.userInfo = data.userInfo || data
      this.roles = data.roles || []
      this.permissions = data.permissions || []
      this.companies = data.companies || []   // 后端新增字段
      // 若已有选中公司且仍在可选列表中，保留；否则取第一个/置空
      const saved = localStorage.getItem('currentCompany')
      const match = saved ? this.companies.find(c => String(c.companyId) === saved) : null
      this.currentCompany = match || this.companies[0] || null
      if (this.currentCompany) {
        localStorage.setItem('currentCompany', String(this.currentCompany.companyId))
      }
      return data
    },

    // 切换公司：更新角色/权限并持久化
    async switchCompany(companyId) {
      const comp = this.companies.find(c => String(c.companyId) === String(companyId))
      if (!comp) return
      this.currentCompany = comp
      localStorage.setItem('currentCompany', String(comp.companyId))
      // 重新拉取该公司下的用户信息（角色/权限会随之变化）
      await this.fetchUserInfo()
    },

    async logout() {
      try { await logout() } catch (e) {}
      this.reset()
    },

    reset() {
      removeToken()
      this.token = ''
      this.userInfo = null
      this.roles = []
      this.permissions = []
      this.companies = []
      this.currentCompany = null
      localStorage.removeItem('currentCompany')
    }
  }
})
