<template>
  <div class="info-main-body">
    <purchase-order-info-detail :slotData="slotData" />
    <purchase-progress :slotData="slotData" />
    <purchase-order-info-payment-finance :slotData="slotData" v-if="isBrand() && slotData.payPlan!= null"/>
    <purchase-order-info-receipt-finance :slotData="slotData" v-if="isFactory() && slotData.payPlan!= null"/>
    <purchase-order-info-remarks :slotData="slotData" />
  </div>
</template>

<script>
  import PurchaseOrderInfoDetail from './PurchaseOrderInfoDetail';
  import PurchaseOrderInfoPaymentFinance from './PurchaseOrderInfoPaymentFinance';
  import PurchaseOrderInfoReceiptFinance from './PurchaseOrderInfoReceiptFinance';
  import PurchaseOrderInfoRemarks from './PurchaseOrderInfoRemarks';
  import PurchaseProgress from './PurchaseProgress';

  export default {
    name: 'PurchaseOrderInfoMain',
    props: ['slotData'],
    components: {
      PurchaseOrderInfoDetail,
      PurchaseOrderInfoPaymentFinance,
      PurchaseOrderInfoReceiptFinance,
      PurchaseOrderInfoRemarks,
      PurchaseProgress
    },
    mixins: [],
    computed: {

    },
    methods: {},
    data() {
      return {}
    },
    created() {}
  }

</script>
<style>
  .info-main-body {
    /* height: 500px; */
    width: 100%;
    /* background-color: green; */
    border-right: 1px solid rgba(0, 0, 0, 0.09);
    padding-right: 20px;
  }

  .info-title {
    width: 100%;
    border-left: 2px solid #FFD60C;
    padding-left: 10px;
    height: 14px;
  }

  .info-title_text {
    font-size: 12px;
    font-weight: 500;
    color: rgba(0, 0, 0, 1);
    opacity: 0.85;
  }

  .info-title-row {
    margin-bottom: 20px;
  }

</style>
