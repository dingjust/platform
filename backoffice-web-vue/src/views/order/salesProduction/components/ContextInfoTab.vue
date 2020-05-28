<template>
  <div class="animated fadeIn">
    <el-tabs type="border-card">
      <el-tab-pane label="外发订单">
        <dispatch-order-basic-table :data="[]"/>
      </el-tab-pane>
      <el-tab-pane label="采购订单">
        <purchase-order-basic-table :data="[]"/>
      </el-tab-pane>
      <el-tab-pane label="利润核算">

      </el-tab-pane>
      <el-tab-pane label="操作日志">

      </el-tab-pane>
    </el-tabs>

  </div>
</template>

<script>
  import DispatchOrderBasicTable from './DispatchOrderBasicTable';
  import PurchaseOrderBasicTable from './PurchaseOrderBasicTable';

  export default {
    name: 'ContextInfoTab',
    props: {
      //外发订单
      dispatchOrders: {
        type: Array,
      },
      //采购订单
      purchaseOrders: {
        type: Array,
      },
      //利润核算
      profitOrders: {
        type: Array,
      },
      //操作日志
      logs: {
        type: Array
      }
    },
    components: {
      DispatchOrderBasicTable,
      PurchaseOrderBasicTable
    },
    computed: {

    },
    methods: {

    },
    data() {
      return {

      }
    },
    mounted() {},
    created() {

    }
  }

</script>

<style scoped>

</style>
