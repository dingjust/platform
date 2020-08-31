<template>
  <div class="animated fadeIn">
    <el-tabs type="border-card">
      <el-tab-pane label="生产任务" v-if="showTask">
        <production-task-basic-table :data="productionTaskDatas" />
      </el-tab-pane>
      <el-tab-pane label="外发订单" :lazy="true" v-if="showDispatch">
        <dispatch-order-basic-table :codes="dispatchOrders" :taskIds="taskIds" />
      </el-tab-pane>
      <el-tab-pane label="生产工单" :lazy="true" v-if="showProduction">
        <production-order-basic-table :codes="productionOrders" :taskIds="taskIds"
          :outboundOrderIds="outboundOrderIds" />
      </el-tab-pane>
      <el-tab-pane label="采购订单" :lazy="true" v-if="showPurchase">
        <purchase-order-basic-table :data="[]" />
      </el-tab-pane>
      <!-- <el-tab-pane label="财务" :lazy="true">
      </el-tab-pane>
      <el-tab-pane label="利润核算" :lazy="true">

      </el-tab-pane> -->
      <el-tab-pane label="操作日志" :lazy="true">

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
      //相关订单对应任务id
      taskIds: {
        type: Array
      },
      //外发订单id
      outboundOrderIds: {
        type: Array
      },
      //是否需要生产任务
      showTask: {
        type: Boolean,
        default: true
      },
      //生产任务-数据
      productionTaskDatas: {
        type: Array,
      },
      //是否需要外发订单
      showDispatch: {
        type: Boolean,
        default: true
      },
      //外发订单-单号
      dispatchOrders: {
        type: Array,
      },
      //是否需要生产订单
      showProduction: {
        type: Boolean,
        default: true
      },
      //生产工单-单号
      productionOrders: {
        type: Array,
      },
      //是否需要采购订单
      showPurchase: {
        type: Boolean,
        default: true
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
