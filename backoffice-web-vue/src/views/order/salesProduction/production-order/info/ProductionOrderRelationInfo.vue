<template>
  <div class="po-relation-box">
    <el-tabs type="border-card">
      <el-tab-pane label="采购订单">
        <purchase-order-basic-table :data="[]" />
      </el-tab-pane>
      <el-tab-pane label="财务">
        <el-row v-if="isBrand()">
          <purchase-order-info-payment-finance :slotData="slotData" v-if="isBrand() && slotData.payPlan!= null" />
        </el-row>
        <el-row v-if="isFactory()">
          <purchase-order-info-receipt-finance :slotData="slotData" v-if="isFactory() && slotData.payPlan!= null" />
        </el-row>
      </el-tab-pane>
      <el-tab-pane label="利润核算">
      </el-tab-pane>
      <el-tab-pane label="操作日志">
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script>
  import PurchaseOrderInfoPaymentFinance from '@/views/order/purchase/info/PurchaseOrderInfoPaymentFinance';
  import PurchaseOrderInfoReceiptFinance from '@/views/order/purchase/info/PurchaseOrderInfoReceiptFinance';
  import PurchaseOrderBasicTable from '../../components/context-order-tab/PurchaseOrderBasicTable';

  export default {
    name: 'ProductionOrderRelationInfo',
    props: ['slotData'],
    components: {
      PurchaseOrderInfoPaymentFinance,
      PurchaseOrderInfoReceiptFinance,
      PurchaseOrderBasicTable
    }
  }

</script>

<style scoped>
  .po-relation-box {
    margin-top: 30px;
  }

</style>
