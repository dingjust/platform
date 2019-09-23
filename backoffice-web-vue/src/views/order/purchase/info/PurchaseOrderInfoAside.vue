<template>
  <div class="info-aside-body">
    <purchase-order-info-supplier :slotData="slotData" />
    <purchase-order-info-staff :slotData="slotData" class="" />
    <purchase-order-button-group :slotData="slotData"/>
    <purchase-order-info-contract :slotData="slotData" :contracts="contracts"/>
    <purchase-order-info-log :slotData="slotData" />
  </div>
</template>

<script>
  import PurchaseOrderInfoSupplier from './PurchaseOrderInfoSupplier';
  import PurchaseOrderInfoStaff from './PurchaseOrderInfoStaff';
  import PurchaseOrderInfoContract from './PurchaseOrderInfoContract';
  import PurchaseOrderInfoLog from './PurchaseOrderInfoLog';
  import PurchaseOrderButtonGroup from './PurchaseOrderButtonGroup';

  export default {
    name: 'PurchaseOrderInfoAside',
    props: ['slotData','dialogDetailVisible','contracts'],
    components: {
      PurchaseOrderInfoSupplier,
      PurchaseOrderInfoStaff,
      PurchaseOrderInfoContract,
      PurchaseOrderInfoLog,
      PurchaseOrderButtonGroup
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
  .info-aside-body {
    /* height: 500px; */
    width: 100%;
    /* background-color: yellow; */
    padding-left: 10px;
    padding-right: 10px;
    /* border-left: 1px solid rgba(0, 0, 0, 0.09); */
  }

</style>
