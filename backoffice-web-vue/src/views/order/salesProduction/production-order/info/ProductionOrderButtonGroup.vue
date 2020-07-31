<template>
  <div>
    <el-row class="purchase-order-row" type="flex" justify="center" align="middle" :gutter="50">
      <el-button class="purchase-order-btn" v-if="receBtn" @click="onCreateReceive">收货
      </el-button>
      <el-button class="purchase-order-btn" v-if="reconBtn" @click="onCreateReconciliation">对账单</el-button>
      <el-button class="purchase-order-btn" v-if="delivBtn" @click="onDeliverViewsOpen">发货</el-button>
      <el-button class="purchase-order-btn" v-if="receViewBtn" @click="onCreateReceive" :disabled="!hasDeliveryOrders">
        {{hasDeliveryOrders?'查看收货单':'对方尚未创建收货单'}}</el-button>
      <el-button class="purchase-order-btn" :disabled="!hasReconciliationOrders" v-if="isCompleted"
        @click="onCreateReconciliation">
        {{hasReconciliationOrders?'查看对账单':'对方尚未创建对账单'}}</el-button>
    </el-row>
    <el-dialog :visible.sync="receiveFormVisible" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <receive-order-form :slotData="slotData" @afterCreate="onAfterCreate" />
    </el-dialog>
    <el-dialog :visible.sync="deliverViewsVisible" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <deliver-order-views :slotData="slotData" @createNewDeliver="onCreateNewDeliver" />
    </el-dialog>
    <el-dialog :visible.sync="deliverFormVisible" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <deliver-order-form :slotData="slotData" @afterCreate="onAfterCreate" />
    </el-dialog>
    <el-dialog :visible.sync="reconciliatioFormVisible" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <purchase-order-info-reconciliation :slotData="slotData" @afterCreate="onAfterCreate"/>
    </el-dialog>
  </div>
</template>

<script>
  import ReceiveOrderForm from '../form/ReceiveOrderForm';
  import DeliverOrderForm from '../form/DeliverOrderForm';
  import DeliverOrderViews from './DeliverOrderViews';

  import PurchaseOrderDeliverViews from './PurchaseOrderDeliverViews';
  import PurchaseOrderInfoReconciliation from './PurchaseOrderInfoReconciliation';
  import PurchaseOrderInfoDeliver from './PurchaseOrderInfoDeliver';

  export default {
    name: 'ProductionOrderButtonGroup',
    props: ['slotData'],
    components: {
      ReceiveOrderForm,
      DeliverOrderForm,
      DeliverOrderViews,

      PurchaseOrderDeliverViews,
      PurchaseOrderInfoReconciliation,
      PurchaseOrderInfoDeliver
    },
    computed: {
      // 收货
      receBtn: function () {
        if (!this.isPending && !this.isCompleted) {
          return true;
        } else {
          return false;
        }
      },
      //对账
      reconBtn: function () {
        if (this.isCompleted) {
          return true;
        } else {
          return false;
        }
      },
      //发货
      delivBtn: function () {
        if (this.isProduction || this.isWaitForOutOfStore) {
          return true;
        } else {
          return false;
        }
      },
      //查看收货
      receViewBtn: function () {
        if (this.isOutStore) {
          return true;
        } else {
          return false;
        }
      },
      isMyself: function () {
        if (this.slotData.creator != null) {
          return this.slotData.creator.uid == this.$store.getters.currentUser.companyCode;
        } else {
          return false;
        }
      },
      judgeType: function () {
        let flag;
        if (this.slotData.creator != null) {
          flag = this.slotData.creator.uid == this.$store.getters.currentUser.companyCode;
        } else {
          flag = false;
        }
        return flag;
      },
      isProduction: function () {
        return this.slotData.status == 'IN_PRODUCTION';
      },
      isWaitForOutOfStore: function () {
        return this.slotData.status == 'WAIT_FOR_OUT_OF_STORE';
      },
      isPending: function () {
        return this.slotData.status == 'PENDING_CONFIRM';
      },
      isOutStore: function () {
        return this.slotData.status == 'OUT_OF_STORE';
      },
      isCompleted: function () {
        return this.slotData.status == 'COMPLETED';
      },
      isOffline: function () {
        return this.slotData.cooperator.type == 'OFFLINE'
      },
      hasReconciliationOrders: function () {
        return this.slotData.reconciliationOrders != null && this.slotData.reconciliationOrders.length != 0
      },
      hasShippingOrders: function () {
        return this.slotData.shippingOrders != null && this.slotData.shippingOrders.length != 0
      },
      hasDeliveryOrders: function () {
        return this.slotData.deliveryOrders != null && this.slotData.deliveryOrders.length != 0
      }
    },
    methods: {
      isBrand() {
        return this.$store.getters.currentUser.type == 'BRAND';
      },
      isFactory() {
        return this.$store.getters.currentUser.type == 'FACTORY';
      },
      onUniqueCode() {
        this.$emit('onUniqueCode');
      },
      onCancel() {
        // if (this.isMyself) {
        //   this.$emit('onCancel');
        // } else {
        this.$emit('onRefuse');
        // }
      },
      onConfirm() {
        this.$emit('onConfirm');
      },
      onCreateAgain() {
        this.$emit('onCreateAgain');
      },
      onCreateReceive() {
        // this.$emit('onCreateReceive');
        this.receiveFormVisible = true;
      },
      onDeliverViewsOpen() {
        // this.$emit('onDeliverViewsOpen');
        this.deliverFormVisible = true;
      },
      onCreateReconciliation() {
        this.reconciliatioFormVisible=true;
        // this.$emit('onReconciliation');
      },
      onUpdate() {
        this.$emit('onUpdate');
      },
      onAfterCreate() {
        this.receiveFormVisible = false;
        this.deliverFormVisible = false;
        this.reconciliatioFormVisible=false;
        this.$emit('callback');
      },
      onCreateNewDeliver() {
        this.deliverViewsVisible = false;
        this.deliverFormVisible = true;
      },
    },
    data() {
      return {
        purchaseOrderCancelVisible: false,
        receiveFormVisible: false,
        deliverViewsVisible: false,
        reconciliatioFormVisible: false,
        deliverFormVisible: false,
      };
    },
    created() {}
  };

</script>
<style>
  .purchase-order-btn {
    background: #FFD60C;
    color: rgba(0, 0, 0, 0.85);
    width: 200px;
  }

  .purchase-order-btn2 {
    /* background: red;
    color: #fff; */
    width: 200px;
  }

</style>
