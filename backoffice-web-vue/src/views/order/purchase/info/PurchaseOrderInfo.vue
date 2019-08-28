<template>
  <div>
    <el-row>
      <el-col :span="16">
        <purchase-order-info-main :slotData="slotData" />
      </el-col>
      <el-col :span="8">
        <purchase-order-info-aside :slotData="slotData" />
      </el-col>
    </el-row>
  </div>
</template>

<script>
  import PurchaseOrderInfoMain from './PurchaseOrderInfoMain';
  import PurchaseOrderInfoAside from './PurchaseOrderInfoAside';

  export default {
    name: 'PurchaseOrderInfo',
    props: ['slotData'],
    components: {
      PurchaseOrderInfoMain,
      PurchaseOrderInfoAside
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
</style>
