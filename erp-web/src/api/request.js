import axios from 'axios'
import { ElMessage } from 'element-plus'
import { useUserStore } from '@/stores/user'

const request = axios.create({
  baseURL: '/api',
  timeout: 30000
})

// 请求拦截：自动加Token
request.interceptors.request.use(config => {
  const token = localStorage.getItem('token')
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }

  const companyId = localStorage.getItem('currentCompanyId')
  if (companyId) {
    config.headers['Company-Id'] = companyId
  }

  return config
})

// 响应拦截：统一处理错误
request.interceptors.response.use(
  response => {
    const data = response.data
    // 如果是blob类型（导出/预览），直接返回
    // blob类型处理
    if (response.config.responseType === 'blob') {
      console.log('[拦截器] Blob响应, size:', data.size, 'type:', data.type)
      console.log('[拦截器] Blob Content-Type:', response.headers['content-type'])
      return data
    }
    if (data.code === 200) {
      return data.data
    } else {
      ElMessage.error(data.msg || '请求失败')
      return Promise.reject(new Error(data.msg))
    }
  },
  error => {
    console.error('[拦截器] 请求错误:', error.config?.url, error.response?.status)
    if (error.response) {
      // 处理blob类型的错误响应
      if (error.response?.config?.responseType === 'blob') {
        const reader = new FileReader()
        reader.onload = () => {
          const msg = JSON.parse(reader.result).msg
          ElMessage.error(msg || '请求失败')
        }
        reader.readAsText(error.response.data)
      } else {
        switch (error.response.status) {
          case 401:
            if (error.config.url.includes('/login')) {
              ElMessage.error(msg)
              window.location.href = '/login' 
            } else {
                ElMessage.error('登录已过期，请重新登录')
                localStorage.removeItem('token')
                window.location.href = '/login' //稳妥
            }
              break
          case 403:
            ElMessage.error('没有权限')
            break
          case 404:
            ElMessage.error('请求资源不存在')
            break
          default:
            ElMessage.error(error.response.data?.msg || '服务器错误')
        }
      }
    } else {
      ElMessage.error('网络错误，请检查连接')
    }
    return Promise.reject(error)
  }
)

export default request