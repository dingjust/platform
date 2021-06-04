<!--
* @Description: 外接/外发 订单 支付设置详情
* @Date 2021/06/02 13:42
* @Author L.G.Y
-->
<template>
  <div class="order-pay-detail">
    <el-row type="flex">
      <el-col :span="9">
        <h6>支付类型：{{formData.payOnline ? '线上支付' : '线下支付'}}</h6>
      </el-col>
    </el-row>
    <template v-if="from === 'SALES_ORDER'">
      <el-row type="flex">
        <el-col :span="9">
          <h6 v-if="formData.payOnline && formData.paymentAccount">付款方式：{{getEnum('PayType', formData.paymentAccount.type)}}</h6>
        </el-col>
        <el-col :span="5">
          <h6 v-if="formData.payOnline && formData.serviceFeePercent">服务费用扣除比列：{{(formData.serviceFeePercent * 100).toFixed(2)}}%</h6>
        </el-col>
      </el-row>
      <el-row type="flex" v-if="formData.payOnline && formData.paymentAccount && formData.paymentAccount.type === 'BANK'">
        <el-col :span="9">
          <h6>姓名：{{formData.paymentAccount.name}}</h6>
        </el-col>
        <el-col :span="7">
          <h6>开户行：{{formData.paymentAccount.serviceProvider}}</h6>
        </el-col>
        <el-col :span="8">
          <h6>卡号：{{formData.paymentAccount.no}}</h6>
        </el-col>
      </el-row>
      <el-row type="flex" v-if="formData.payOnline && formData.paymentAccount && formData.paymentAccount.type === 'WECHAT'">
        <el-col :span="9">
          <h6>姓名：{{formData.paymentAccount.name}}</h6>
        </el-col>
        <el-col :span="7">
          <h6>开户行：{{formData.paymentAccount.serviceProvider}}</h6>
        </el-col>
        <el-col :span="8">
          <h6>卡号：{{formData.paymentAccount.no}}</h6>
        </el-col>
      </el-row>
    </template>
  </div>
</template>

<script>
export default {
  name: 'OrderPayDetail',
  props: ['formData', 'from']
}
</script>

<style scoped>
</style>