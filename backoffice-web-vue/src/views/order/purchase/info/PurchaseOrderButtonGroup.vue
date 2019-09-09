<template>
  <div class="info-detail-staff-body">
    <el-dialog :visible.sync="deliverViewsVisible" width="80%" class="purchase-dialog" append-to-body>
      <purchase-order-deliver-views :slotData="slotData" @createNewDeliver="onCreateNewDeliver" />
    </el-dialog>
    <el-dialog :visible.sync="receiveFormVisible" width="80%" class="purchase-dialog" append-to-body>
      <purchase-order-info-receive :slotData="slotData" @afterCreate="onAfterCreate" />
    </el-dialog>
    <el-dialog :visible.sync="deliverFormVisible" width="80%" class="purchase-dialog" append-to-body>
      <purchase-order-info-deliver :slotData="slotData" @afterCreate="onAfterCreate" />
    </el-dialog>
    <el-dialog :visible.sync="reconciliatioFormVisible" width="80%" class="purchase-dialog" append-to-body>
      <purchase-order-info-reconciliation :slotData="slotData" />
    </el-dialog>
    <el-row type="flex" justify="space-between" align="middle" class="info-title-row">
      <div class="info-title">
        <h6 class="info-title_text">查看单据</h6>
      </div>
    </el-row>
    <el-row type="flex" justify="space-around">
      <el-button type="text" class="info-detail-logistics_info-btn1"
        :disabled="slotData.shippingOrders==null||slotData.shippingOrders.length==0"
        @click="deliverViewsVisible=!deliverViewsVisible">查看发货单</el-button>
      <el-button type="text" class="info-detail-logistics_info-btn1"
        :disabled="slotData.deliveryOrders==null||slotData.deliveryOrders.length==0"
        @click="receiveFormVisible=!receiveFormVisible">查看收货单</el-button>
      <el-button type="text" class="info-detail-logistics_info-btn1"
        :disabled="slotData.reconciliationOrders==null||slotData.reconciliationOrders.length==0"
        @click="reconciliatioFormVisible=!reconciliatioFormVisible">查看对账单</el-button>
    </el-row>
  </div>
</template>

<script>
  import PurchaseOrderInfoReceive from './PurchaseOrderInfoReceive';
  import PurchaseOrderDeliverViews from './PurchaseOrderDeliverViews';
  import PurchaseOrderInfoDeliver from './PurchaseOrderInfoDeliver';
  import PurchaseOrderInfoReconciliation from './PurchaseOrderInfoReconciliation';

  export default {
    name: 'PurchaseOrderButtonGroup',
    props: ['slotData'],
    components: {
      PurchaseOrderInfoReceive,
      PurchaseOrderDeliverViews,
      PurchaseOrderInfoDeliver,
      PurchaseOrderInfoReconciliation
    },
    mixins: [],
    computed: {

    },
    methods: {
      onAfterCreate() {
        this.receiveFormVisible = false;
        this.deliverFormVisible = false;
      },
      onCreateNewDeliver() {
        this.deliverViewsVisible = false;
        this.deliverFormVisible = true;
      }
    },
    data() {
      return {
        deliverFormVisible: false,
        deliverViewsVisible: false,
        receiveFormVisible: false,
        reconciliatioFormVisible: false,
      }
    },
    created() {}
  }

</script>
<style>
  .info-detail-staff-body {
    width: 100%;
    margin-top: 20px;
  }

  .info-row {
    margin-top: 5px;
  }

  .info-template-name {
    text-align: center;
    font-size: 12px;
  }

  .info-img-word {
    width: 50px;
    height: 50px;
    margin-bottom: 5px;
  }

  .purchase-dialog .el-dialog__header {
    padding: 0px !important;
  }

  .info-detail-logistics_info-btn1 {
    width: 70px;
    height: 25px;
    background: #FFD60C;
    font-weight: 400;
    color: rgba(0, 0, 0, 0.85);
    font-size: 10px;
    border-radius: 0px;
    border: 0px solid #FFD60C;
  }

</style>
