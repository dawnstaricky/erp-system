import { useUserStore } from '@/stores/user'

export default {
  mounted(el, binding) {
    const userStore = useUserStore()
    const userRole = userStore.userInfo?.role
    const allowedRoles = binding.value

    if (!allowedRoles.includes(userRole)) {
      el.parentNode?.removeChild(el)
    }
  }
}