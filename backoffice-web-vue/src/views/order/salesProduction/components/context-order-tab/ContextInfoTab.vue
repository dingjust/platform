<template>
  <div class="animated fadeIn">
    <el-tabs type="border-card">
      <el-tab-pane label="生产任务">
        <production-task-basic-table :data="productionTaskDatas" />
      </el-tab-pane>
      <el-tab-pane label="外发订单" :lazy="true">
        <dispatch-order-basic-table :codes="dispatchOrders" />
      </el-tab-pane>
      <el-tab-pane label="生产工单" :lazy="true">
        <production-order-basic-table :codes="productionOrders" />
      </el-tab-pane>
      <el-tab-pane label="采购订单">
        <purchase-order-basic-table :data="[]" />
      </el-tab-pane>
      <el-tab-pane label="财务">
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
  import ProductionOrderBasicTable from './ProductionOrderBasicTable';
  import ProductionTaskBasicTable from './ProductionTaskBasicTable';

  export default {
    name: 'ContextInfoTab',
    props: {
      //生产任务-数据
      productionTaskDatas: {
        type: Array,
      },
      //外发订单-单号
      dispatchOrders: {
        type: Array,
      },
      //生产工单-单号
      productionOrders: {
        type: Array,
      },
      //采购订单-单号
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
      PurchaseOrderBasicTable,
      ProductionOrderBasicTable,
      ProductionTaskBasicTable
    },
    computed: {

    },
    methods: {

    },
    data() {
      return {
        dispatchOrdersDatas: null,
        productionOrdersDatas: null,
        purchaseOrdersDatas: null
      }
    },
    mounted() {},
    created() {

    }
  }

</script>

<style scoped>

</style>
