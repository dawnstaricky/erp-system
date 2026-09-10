import axios from 'axios'
import { ElMessage } from 'element-plus'
import { useUserStore } from '@/stores/user'

const request = axios.create({
  baseURL: '/api',
  timeout: 30000
})

// 请求拦截：自动加 Token + 当前公司
request.interceptors.request.use(config => {
  const token = localStorage.getItem('token')
  if (token) config.headers.Authorization = \`Bearer \${token}\`
  // 多公司：把当前选中公司放进请求头
  const company = localStorage.getItem('currentCompany')
  if (company) config.headers['X-Company-Id'] = company
  return config
})

// 响应拦截：统一处理错误
request.interceptors.response.use(
  response => {
    const data = response.data
    if (response.config.responseType === 'blob') return data
    if (data.code === 200) return data.data
    ElMessage.error(data.msg || '请求失败')
    return Promise.reject(new Error(data.msg))
  },
  error => {
    if (error.response) {
      if (error.response.config?.responseType === 'blob') {
        const reader = new FileReader()
        reader.onload = () => ElMessage.error(JSON.parse(reader.result).msg || '请求失败')
        reader.readAsText(error.response.data)
      } else {
        switch (error.response.status) {
          case 401:
            ElMessage.error('登录已过期，请重新登录')
            localStorage.removeItem('token')
            window.location.href = '/login'
            break
          case 403: ElMessage.error('没有权限'); break
          case 404: ElMessage.error('请求资源不存在'); break
          default: ElMessage.error(error.response.data?.msg || '服务器错误')
        }
      }
    } else {
      ElMessage.error('网络错误，请检查连接')
    }
    return Promise.reject(error)
  }
)

export default request
