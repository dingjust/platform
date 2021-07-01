<!--
* @Description: 支付信息
* @Date 2021/06/08 11:45
* @Author L.G.Y
-->
<template>
  <div>
    <order-pay-detail :formData="formData" :fromOut="fromOut"/>
    <el-table :data="formData.paymentOrders" style="margin-top: 20px">
      <el-table-column label="批次">
        <template slot-scope="scope">
          <span>{{scope.row.batch === 1 ? '定金' : '尾款'}}</span>
        </template>
      </el-table-column>
      <el-table-column label="支付金额">
        <template slot-scope="scope">
          <span>￥{{scope.row.payAmount}}</span>
        </template>
      </el-table-column>
      <el-table-column label="支付方式">
        <template slot-scope="scope">
          <span>{{getEnum('PayMethod', scope.row.payType)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="交易编号" prop="outOrderNo"></el-table-column>
      <el-table-column label="支付时间">
        <template slot-scope="scope">
          <span v-if="scope.row.paySuccessTime">{{scope.row.paySuccessTime | formatDate}}</span>
        </template>
      </el-table-column>
      <el-table-column label="支付状态">
        <template slot-scope="scope">
          <span>{{getEnum('CmtPaymentState', scope.row.state)}}</span>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>

<script>
import OrderPayDetail from '@/views/order/salesProduction/components/OrderPayDetail'

export default {
  name: 'SalesPayment',
  components: { OrderPayDetail },
  props: ['formData', 'fromOut']
}
</script>

<style scoped>

</style>