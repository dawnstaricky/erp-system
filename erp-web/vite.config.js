import { defineConfig, loadEnv } from 'vite'
import vue from '@vitejs/plugin-vue'

export default defineConfig(({ mode }) => {
  const env = loadEnv(mode, process.cwd(), '')
  const useProxy = env.VITE_USE_PROXY === 'true'
  return {
    plugins: [vue()],
    resolve: { alias: { '@': '/src' } },
    base: '/',
    server: {
      port: 3000,
      // 仅在本地开发(useProxy=true)时启用 proxy，生产构建不含此配置
      proxy: useProxy
        ? { '/api': { target: 'http://localhost:8080', changeOrigin: true, rewrite: p => p.replace(/^\/api/, '') } }
        : undefined,
      hmr: { overlay: false }
    },
    cacheDir: 'node_modules/.vite',
    esbuild: { sourcemap: false }
  }
})
