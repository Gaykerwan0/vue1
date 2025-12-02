<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import type { Goods, Order } from '@/types/shopping'
import { useUserStore } from '@/stores/user'
import { getGoodsList, createOrder } from '@/api/shopping'

const userStore = useUserStore()

// 商品列表
const goodsList = ref<Goods[]>([])
// 加载状态
const loading = ref(false)
// 用户余额
const userBalance = ref(0)

// 获取商品列表
const fetchGoodsList = async () => {
  loading.value = true
  try {
    const res = await getGoodsList()
    goodsList.value = res.data
  } catch (error) {
    ElMessage.error('获取商品列表失败')
  } finally {
    loading.value = false
  }
}

// 购买商品
const handlePurchase = async (goods: Goods) => {
  // 检查用户余额
  if (userStore.userInfo.balance < goods.price) {
    ElMessage.warning('余额不足，无法购买')
    return
  }

  // 确认购买
  ElMessageBox.confirm(
    `确定要购买 ${goods.name} 吗？价格：¥${goods.price}`,
    '确认购买',
    {
      confirmButtonText: '确认',
      cancelButtonText: '取消',
      type: 'warning'
    }
  ).then(async () => {
    try {
      // 创建订单
      const orderData: Order = {
        goodsId: goods.id,
        userId: userStore.userInfo.id,
        quantity: 1,
        totalAmount: goods.price,
        status: 'completed'
      }

      await createOrder(orderData)

      // 更新用户余额
      userStore.userInfo.balance -= goods.price

      ElMessage.success('购买成功')

      // 刷新商品列表
      await fetchGoodsList()
    } catch (error) {
      ElMessage.error('购买失败')
    }
  }).catch(() => {
    // 取消购买
  })
}

onMounted(() => {
  userBalance.value = userStore.userInfo.balance
  fetchGoodsList()
})
</script>

<template>
  <div class="shopping-container">
    <h2>商品选购</h2>

    <el-card class="balance-card">
      <div class="balance-info">
        <span>账户余额：</span>
        <span class="balance-amount">¥{{ userStore.userInfo.balance }}</span>
      </div>
    </el-card>

    <el-divider />

    <div v-loading="loading">
      <el-row :gutter="20">
        <el-col
          v-for="goods in goodsList"
          :key="goods.id"
          :span="6"
        >
          <el-card
            class="goods-card"
            shadow="hover"
          >
            <div class="goods-content">
              <h4>{{ goods.name }}</h4>
              <p class="goods-description">{{ goods.description }}</p>
              <div class="goods-price">¥{{ goods.price }}</div>
              <div class="goods-stock">库存：{{ goods.stock }}件</div>
              <el-button
                type="primary"
                :disabled="goods.stock <= 0 || userStore.userInfo.balance < goods.price"
                @click="handlePurchase(goods)"
              >
                {{ goods.stock > 0 ? '立即购买' : '已售罄' }}
              </el-button>
            </div>
          </el-card>
        </el-col>
      </el-row>

      <div v-if="goodsList.length === 0 && !loading" class="no-goods">
        <el-empty description="暂无商品" />
      </div>
    </div>
  </div>
</template>

<style scoped lang="scss">
.shopping-container {
  padding: 20px;

  .balance-card {
    margin-bottom: 20px;

    .balance-info {
      display: flex;
      align-items: center;
      justify-content: space-between;

      .balance-amount {
        font-size: 18px;
        font-weight: bold;
        color: #ff6b00;
      }
    }
  }

  .goods-card {
    margin-bottom: 20px;

    .goods-content {
      text-align: center;

      h4 {
        margin: 0 0 10px 0;
        font-size: 16px;
      }

      .goods-description {
        height: 40px;
        overflow: hidden;
        color: #666;
        margin: 0 0 10px 0;
      }

      .goods-price {
        font-size: 18px;
        color: #ff6b00;
        font-weight: bold;
        margin: 10px 0;
      }

      .goods-stock {
        color: #999;
        margin-bottom: 15px;
      }
    }
  }

  .no-goods {
    margin-top: 50px;
  }
}
</style>
