<template>
  <div class="detail-container">
    <div>
      <h6>盈亏分析单号：{{detail.code}}</h6>
    </div>
    <div v-if="showOrderCode">
      <h6>关联外接订单：
        <el-button type="text" @click="openOrder(detail.salesProductionOrder.id)" class="code-btn">{{detail.salesProductionOrder.code}}</el-button>
      </h6>
    </div>
    <div>
      <h6>创建时间：{{detail.creationtime | timestampToTime}}</h6>
    </div>
    <div v-if="detail.status === 'CANCELLED'">
      <h6 style="color: #F56C6C">订单已取消</h6>
    </div>
    <el-dialog :visible.sync="orderVisible" width="80%" append-to-body :close-on-click-modal="false">
      <sales-order-detail v-if="orderVisible" :id="orderId"/>
    </el-dialog>
  </div>
</template>

<script>
import SalesOrderDetail from '@/views/order/salesProduction/details/SalesOrderDetail.vue';
export default {
  name: 'ProfitLossDetailTop',
  props: ['detail'],
  components: { SalesOrderDetail },
  computed: {
    showOrderCode: function () {
      return this.detail.salesProductionOrder && this.$route.name !== '外接订单';
    }
  },
  data () {
    return {
      orderVisible: false,
      orderId: ''
    }
  },
  methods: {
    openOrder (id) {
      this.orderId = id;
      this.orderVisible = true;
    }
  }
}
</script>

<style scoped>
  .detail-container {
    margin: 0px 0px 10px 20px;
    display: flex;
    justify-content: space-between;
    flex-wrap: wrap;
    font-size: 14px;
    color: #606266;
  }

  .code-btn {
    font-size: 14px;
    padding: 0px;
  }
</style>