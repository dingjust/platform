<!--
* @Description: 支付信息
* @Date 2021/06/08 11:45
* @Author L.G.Y
-->
<template>
  <div>
    <order-pay-detail :formData="formData" :fromOut="fromOut" />
    <el-row justify="center">
      <el-button @click="addPayOrder" type="success">添加支付单</el-button>
    </el-row>
    <el-table :data="paymentOrders" style="margin-top: 20px">
      <el-table-column label="批次">
        <template slot-scope="scope">
          <span>{{batchName(scope.$index)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="支付金额">
        <template slot-scope="scope">
          <span>￥{{scope.row.totalAmount ? scope.row.totalAmount : scope.row.payAmount}}</span>
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
    <el-dialog :visible.sync="paymentOrdersShow" width="30%"  append-to-body
      :close-on-click-modal="false">
      <payment-order-form />
    </el-dialog>
  </div>
</template>

<script>
  import OrderPayDetail from '@/views/order/salesProduction/components/OrderPayDetail'
  import PaymentOrderForm from '@/views/order/salesProduction/form/PaymentOrderForm'

  export default {
    name: 'SalesPayment',
    components: {
      OrderPayDetail,
      PaymentOrderForm
    },
    props: ['formData', 'fromOut'],
    computed: {
      paymentOrders: function () {
        return this.formData.paymentOrders.reverse()
      }
    },
    data() {
      return {
        paymentOrdersShow: false
      };
    },
    methods: {
      batchName(index) {
        const {
          payPlan
        } = this.formData
        if (index === 0) {
          return payPlan.isHaveDeposit ? '定金' : '1期尾款'
        } else {
          return payPlan.isHaveDeposit ? (index + '期尾款') : ((index + 1) + '期尾款')
        }
      },
      addPayOrder() {
        this.paymentOrdersShow=true;
      }
    }
  }

</script>

<style scoped>

</style>
