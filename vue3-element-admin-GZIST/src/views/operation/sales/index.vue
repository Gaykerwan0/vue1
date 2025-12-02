
<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { ElCard, ElRow, ElCol, ElForm, ElFormItem, ElSelect, ElOption, ElDatePicker, ElButton, ElTable, ElTableColumn, ElDivider } from 'element-plus'
import { Search, Refresh } from '@element-plus/icons-vue'

// 类型定义
interface SalesStatistics {
  productId?: number
  stationId?: number
  startDate?: string
  endDate?: string
}

interface SalesData {
  productName: string
  stationName: string
  orderCount: number
  totalAmount: number
  commissionAmount: number
  dateRange: string
}

// 数据初始化
const form = reactive<SalesStatistics>({
  productId: undefined,
  stationId: undefined,
  startDate: '',
  endDate: ''
})

const salesData = ref<SalesData[]>([])
const productList = ref<{id: number, name: string}[]>([])
const stationList = ref<{id: number, name: string}[]>([])

// 获取商品列表
const fetchProductList = () => {
  // TODO: 调用API获取商品列表
  productList.value = [
    { id: 1, name: '商品A' },
    { id: 2, name: '商品B' },
    { id: 3, name: '商品C' }
  ]
}

// 获取站点列表
const fetchStationList = () => {
  // TODO: 调用API获取站点列表（根据用户权限）
  stationList.value = [
    { id: 1, name: '站点A' },
    { id: 2, name: '站点B' },
    { id: 3, name: '站点C' }
  ]
}

// 查询销售统计数据
const querySalesData = () => {
  // TODO: 调用API查询销售统计数据
  salesData.value = [
    {
      productName: '商品A',
      stationName: '站点A',
      orderCount: 10,
      totalAmount: 1000,
      commissionAmount: 100,
      dateRange: '2024-01-01 至 2024-01-31'
    },
    {
      productName: '商品B',
      stationName: '站点B',
      orderCount: 5,
      totalAmount: 500,
      commissionAmount: 50,
      dateRange: '2024-01-01 至 2024-01-31'
    }
  ]
}

// 重置表单
const resetForm = () => {
  form.productId = undefined
  form.stationId = undefined
  form.startDate = ''
  form.endDate = ''
}

// 初始化数据
onMounted(() => {
  fetchProductList()
  fetchStationList()
  querySalesData()
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
                  :key="item.id"
                  :label="item.name"
                  :value="item.id"
                />
              </el-select>
            </el-form-item>
          </el-col>

          <el-col :span="6">
            <el-form-item label="站点">
              <el-select v-model="form.stationId" placeholder="请选择站点" clearable style="width: 100%">
                <el-option
                  v-for="item in stationList"
                  :key="item.id"
                  :label="item.name"
                  :value="item.id"
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

      <el-table :data="salesData" border stripe>
        <el-table-column prop="productName" label="商品名称" align="center" />
        <el-table-column prop="stationName" label="站点名称" align="center" />
        <el-table-column prop="orderCount" label="订单数量" align="center" />
        <el-table-column prop="totalAmount" label="销售金额(元)" align="center" />
        <el-table-column prop="commissionAmount" label="提成金额(元)" align="center" />
        <el-table-column prop="dateRange" label="统计时间范围" align="center" />
      </el-table>
    </el-card>
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

