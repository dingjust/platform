<template>
  <div class="info-aside-body">
    <purchase-order-info-supplier :slotData="slotData.supplier" />
    <purchase-order-info-staff :slotData="{}" class="" />
    <purchase-order-info-contract :slotData="{}" />
    <purchase-order-info-log :slotData="{}" />
  </div>
</template>

<script>
  import PurchaseOrderInfoSupplier from './PurchaseOrderInfoSupplier';
  import PurchaseOrderInfoStaff from './PurchaseOrderInfoStaff';
  import PurchaseOrderInfoContract from './PurchaseOrderInfoContract';
  import PurchaseOrderInfoLog from './PurchaseOrderInfoLog';

  export default {
    name: 'PurchaseOrderInfoAside',
    props: ['slotData'],
    components: {
      PurchaseOrderInfoSupplier,
      PurchaseOrderInfoStaff,
      PurchaseOrderInfoContract,
      PurchaseOrderInfoLog
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
