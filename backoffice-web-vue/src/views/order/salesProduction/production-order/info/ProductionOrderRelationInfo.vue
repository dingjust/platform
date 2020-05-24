<template>
  <div class="po-relation-box">
    <el-tabs type="border-card">
<!--      <el-tab-pane label="采购订单">采购订单</el-tab-pane>-->
      <el-tab-pane label="财务">
        <el-row v-if="isBrand()">
          <production-order-payment-info :slotData="slotData"/>
        </el-row>
        <el-row v-if="isFactory()">
          <production-order-receipt-info :slotData="slotData"/>
        </el-row>
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script>
  import ProductionOrderReceiptInfo from './ProductionOrderReceiptInfo';
  import ProductionOrderPaymentInfo from './ProductionOrderPaymentInfo';
  export default {
    name: 'ProductionOrderRelationInfo',
    props: ['slotData'],
    components: {ProductionOrderPaymentInfo, ProductionOrderReceiptInfo}
  }
</script>

<style scoped>
  .po-relation-box {
    margin-top: 30px;
  }
</style>
