import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  plugins: [vue()],
  resolve: { alias: { '@': '/src' } },
  base: '/',
  server: {
    port: 3000,
    hmr: { overlay: false } // 关闭错误遮罩，减少开销
  },
  cacheDir: 'node_modules/.vite',
  esbuild: { sourcemap: false }, // 关闭sourcemap，减少内存
  build: { outDir: 'dist' }
})