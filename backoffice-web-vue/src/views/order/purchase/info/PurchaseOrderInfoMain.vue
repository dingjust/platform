<template>
  <div class="info-main-body">
    <purchase-order-info-detail :slotData="slotData" />
    <purchase-order-info-finance :slotData="slotData" />
    <purchase-order-info-remarks :slotData="slotData" />
  </div>
</template>

<script>
  import PurchaseOrderInfoDetail from './PurchaseOrderInfoDetail';
  import PurchaseOrderInfoFinance from './PurchaseOrderInfoFinance';
  import PurchaseOrderInfoRemarks from './PurchaseOrderInfoRemarks';

  export default {
    name: 'PurchaseOrderInfoMain',
    props: ['slotData'],
    components: {
      PurchaseOrderInfoDetail,
      PurchaseOrderInfoFinance,
      PurchaseOrderInfoRemarks
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
