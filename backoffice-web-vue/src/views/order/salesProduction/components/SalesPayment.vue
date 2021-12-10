<!--
* @Description: 支付信息
* @Date 2021/06/08 11:45
* @Author L.G.Y
-->
<template>
  <div>
    <order-pay-detail :formData="formData" :fromOut="fromOut" />
    <el-row type="flex" justify="end" v-if="isTenant">
      <el-button @click="addPayOrder" type="primary">添加支付单</el-button>
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
      <el-table-column label="支付类型">
        <template slot-scope="scope">
          <span>{{scope.row.orderType === 'offline' ? '线下支付' : '线上支付'}}</span>
        </template>
      </el-table-column>
      <el-table-column label="备注" prop="remark">
      </el-table-column>
      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-button v-if="scope.row.orderType === 'offline'" type="text" @click="onModify(scope.row)">修改</el-button>
          <el-button v-if="scope.row.orderType === 'offline'" type="text" @click="onDelete(scope.row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    <el-dialog :visible.sync="paymentOrdersShow" width="30%" append-to-body :close-on-click-modal="false">
      <payment-order-form v-if="paymentOrdersShow" :formData="formData" :handleForm="handleForm" @onSure="onSure"
        @closeDialog="paymentOrdersShow=false" />
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
        paymentOrdersShow: false,
        handleForm: null
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
        this.handleForm = null
        this.paymentOrdersShow = true;
      },
      callback() {
        this.$emit('callback')
      },
      async onSure(form) {
        const url = this.apis().appendPaymentOrder()
        const result = await this.$http.post(url, form)

        if (result.code === 1) {
          this.$message.success('操作成功')
          this.$emit('callback')
          this.paymentOrdersShow = false
        } else if (result.code === 0) {
          this.$message.error(result.msg)
        } else {
          this.$message.error('操作失败')
        }
      },
      onModify(row) {
        this.handleForm = row
        this.paymentOrdersShow = true
      },
      onDelete(row) {
        this.$confirm('是否删除此交易订单?', '提示', {
          confirmButtonText: '是',
          cancelButtonText: '否',
          type: 'warning'
        }).then(() => {
          const form = row

          form.originCode = form.originCode + '_' + form.id

          this.onSure(form)
        });
      }
    }
  }

</script>

<style scoped>

</style>
