import { ref } from 'vue'

export function useTable(fetchFn, searchDefault = {}) {
  const loading = ref(false)
  const tableData = ref([])
  const total = ref(0)
  const pageNum = ref(1)
  const pageSize = ref(10)
  // ✅ 搜索参数，默认值为传入的searchDefault
  const searchForm = ref({ ...searchDefault })

  const loadData = async () => {
    loading.value = true
    try {
      const params = {
        pageNum: pageNum.value,
        pageSize: pageSize.value,
        ...searchForm.value
      }
      const res = await fetchFn(params)
      tableData.value = res.list || []
      total.value = res.total || 0
    } catch (e) {
      console.error('加载列表失败:', e)
    } finally {
      loading.value = false
    }
  }

  const resetSearch = () => {
    searchForm.value = { ...searchDefault }
    pageNum.value = 1
    loadData()
  }

  return { loading, tableData, total, pageNum, pageSize, searchForm, loadData, resetSearch }
}