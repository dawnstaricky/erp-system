window.addEventListener('error', (e) => console.log('[GLOBAL-ERROR]', e.error))
window.addEventListener('unhandledrejection', (e) => console.log('[PROMISE-ERROR]', e.reason))
import { createApp } from 'vue'
import { createPinia } from 'pinia'
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
import * as ElementPlusIconsVue from '@element-plus/icons-vue'
import App from './App.vue'
import router from './router'
import roleDirective from './directives/role'

const app = createApp(App)

for (const [key, component] of Object.entries(ElementPlusIconsVue)) {
  app.component(key, component)
}


app.directive('role', roleDirective)

app.use(createPinia())
app.use(router)
app.use(ElementPlus, { size: 'default' })
app.mount('#app')