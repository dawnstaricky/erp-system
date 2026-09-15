import { defineConfig, loadEnv } from 'vite'
import vue from '@vitejs/plugin-vue'
import path from 'path'

export default defineConfig(({ mode }) => {
  // 加载环境变量
  const env = loadEnv(mode, process.cwd(), '')
  
  return {
    plugins: [vue()],
    resolve: {
      alias: { '@': '/src' }
    },
    base: '/',
    server: {
      port: 3000,
      // 只有当 .env.development 中 VITE_USE_PROXY=true 时才开启代理
      proxy: env.VITE_USE_PROXY === 'true' ? {
        '/api': {
          target: 'http://localhost:8080',
          changeOrigin: true,
          rewrite: (path) => path.replace(/^\/api/, ''),
          secure: false
        }
      } : undefined
    },
    cacheDir: 'node_modules/.vite',
    esbuild: { sourcemap: false },
    build: { outDir: 'dist' }
  }
})