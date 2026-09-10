import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  plugins: [vue()],
  resolve: { alias: { '@': '/src' } },
  server: {
    port: 3000,
    proxy: { '/api': { target: 'http://localhost:8080', changeOrigin: true, rewrite: p=>p.replace(/^\/api/,'') } },
    hmr: { overlay: false } // 关闭错误遮罩，减少开销
  },
  cacheDir: 'node_modules/.vite',
  esbuild: { sourcemap: false } // 关闭sourcemap，减少内存
})