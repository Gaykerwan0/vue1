
<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { Search, Refresh } from '@element-plus/icons-vue'
import OperationSalesAPI, { ReplenishForm, SalesStatisticsItem, SalesStatisticsQuery } from '@/api/operation/sales-api'

const form = reactive<SalesStatisticsQuery>({
  productId: undefined,
  stationId: undefined,
  startDate: '',
  endDate: ''
})

const salesData = ref<SalesStatisticsItem[]>([])
const productList = ref<OptionType[]>([])
const stationList = ref<OptionType[]>([])
const loading = ref(false)

const replenishDialogVisible = ref(false)
const replenishSubmitting = ref(false)
const replenishForm = reactive<ReplenishForm>({
  repositoryId: 0,
  quantity: 1
})
const replenishTarget = reactive({
  productName: '',
  stationName: ''
})

// 获取商品列表
const fetchProductList = async () => {
  const res = await OperationSalesAPI.getProducts()
  productList.value = res || []
}

// 获取站点列表
const fetchStationList = async () => {
  const res = await OperationSalesAPI.getStations()
  stationList.value = res || []
}

// 查询销售统计数据
const querySalesData = async () => {
  loading.value = true
  try {
    const res = await OperationSalesAPI.getStatistics({
      ...form,
      startDate: form.startDate || undefined,
      endDate: form.endDate || undefined
    })
    salesData.value = res || []
  } finally {
    loading.value = false
  }
}

// 重置表单
const resetForm = () => {
  form.productId = undefined
  form.stationId = undefined
  form.startDate = ''
  form.endDate = ''
  querySalesData()
}

const openReplenishDialog = (row: SalesStatisticsItem) => {
  if (!row.repositoryId) return
  replenishForm.repositoryId = row.repositoryId
  replenishForm.quantity = 1
  replenishTarget.productName = row.productName || ''
  replenishTarget.stationName = row.stationName || ''
  replenishDialogVisible.value = true
}

const submitReplenish = async () => {
  if (!replenishForm.quantity || replenishForm.quantity <= 0) {
    ElMessage.warning('请输入正确的补货数量')
    return
  }
  replenishSubmitting.value = true
  try {
    await OperationSalesAPI.replenish(replenishForm)
    ElMessage.success('补货成功')
    replenishDialogVisible.value = false
    await querySalesData()
  } finally {
    replenishSubmitting.value = false
  }
}

// 初始化数据
onMounted(async () => {
  await Promise.all([fetchProductList(), fetchStationList()])
  await querySalesData()
})
</script>

<template>
  <div class="sales-statistics">
    <el-card shadow="never" class="mb-4">
      <template #header>
        <span>筛选条件</span>
      </template>
      <el-form :model="form" label-width="80px" inline>
        <el-row :gutter="20">
          <el-col :span="6">
            <el-form-item label="商品">
              <el-select v-model="form.productId" placeholder="请选择商品" clearable style="width: 100%">
                <el-option
                  v-for="item in productList"
                  :key="item.value"
                  :label="item.label"
                  :value="item.value"
                />
              </el-select>
            </el-form-item>
          </el-col>

          <el-col :span="6">
            <el-form-item label="站点">
              <el-select v-model="form.stationId" placeholder="请选择站点" clearable style="width: 100%">
                <el-option
                  v-for="item in stationList"
                  :key="item.value"
                  :label="item.label"
                  :value="item.value"
                />
              </el-select>
            </el-form-item>
          </el-col>

          <el-col :span="10">
            <el-form-item label="日期区间">
              <el-date-picker
                v-model="form.startDate"
                type="date"
                placeholder="开始日期"
                value-format="YYYY-MM-DD"
                style="width: 45%"
              />
              <span style="margin: 0 10px">至</span>
              <el-date-picker
                v-model="form.endDate"
                type="date"
                placeholder="结束日期"
                value-format="YYYY-MM-DD"
                style="width: 45%"
              />
            </el-form-item>
          </el-col>
        </el-row>

        <el-row>
          <el-col :span="24" style="text-align: right">
            <el-button type="primary" :icon="Search" @click="querySalesData">查询</el-button>
            <el-button :icon="Refresh" @click="resetForm">重置</el-button>
          </el-col>
        </el-row>
      </el-form>
    </el-card>

    <el-card shadow="never">
      <template #header>
        <span>销售统计结果</span>
      </template>

      <el-table :data="salesData" border stripe v-loading="loading">
        <el-table-column prop="productName" label="商品名称" align="center" />
        <el-table-column prop="stationName" label="站点名称" align="center" />
        <el-table-column prop="orderCount" label="订单数量" align="center" />
        <el-table-column prop="totalAmount" label="销售金额(元)" align="center" />
        <el-table-column prop="commissionAmount" label="提成金额(元)" align="center" />
        <el-table-column prop="dateRange" label="统计时间范围" align="center" />
        <el-table-column prop="currentQuantity" label="库存数量" align="center" />
        <el-table-column label="操作" width="120" align="center">
          <template #default="{ row }">
            <el-button type="primary" link @click="openReplenishDialog(row)">补货</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <el-dialog v-model="replenishDialogVisible" title="库存补货" width="400px" destroy-on-close>
      <el-form label-width="90px">
        <el-form-item label="商品">
          <span>{{ replenishTarget.productName || '-' }}</span>
        </el-form-item>
        <el-form-item label="站点">
          <span>{{ replenishTarget.stationName || '-' }}</span>
        </el-form-item>
        <el-form-item label="补货数量">
          <el-input-number
            v-model="replenishForm.quantity"
            :min="1"
            :controls="false"
            style="width: 100%"
            placeholder="请输入补货数量"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="replenishDialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="replenishSubmitting" @click="submitReplenish">确认</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<style scoped lang="scss">
.sales-statistics {
  padding: 20px;

  .mb-4 {
    margin-bottom: 16px;
  }

  :deep(.el-card__header) {
    font-weight: bold;
  }
}
</style>

