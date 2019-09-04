<template>
  <el-row class="purchase-order-row" type="flex" justify="center" align="middle" :gutter="50">
    <el-button class="purchase-order-btn" v-if="isMyself&&isPending" @click="onUniqueCode">唯一码
    </el-button>
    <el-button class="purchase-order-btn" v-if="isBrand()&&!isPending" @click="onCreateReceive">收货单</el-button>
    <el-button class="purchase-order-btn" v-if="isBrand()&&isCompleted" @click="onCreateReconciliation">对账单</el-button>
    <!-- <el-button class="purchase-order-btn" v-if="slotData.status=='COMPLETED'" @click="onCreateAgain">
      {{isBrand()?'再下一单':'重新创建'}}</el-button> -->
    <el-button class="purchase-order-btn" v-if="!isMyself&&isPending" @click="onConfirm">接单</el-button>
    <el-button class="purchase-order-btn" v-if="isFactory()&&!isPending" @click="onDeliverViewsOpen">发货单</el-button>
    <el-button class="purchase-order-btn" v-if="isFactory()&&isOutStore" @click="onCreateReceive"
      :disabled="!hasDeliveryOrders">
      {{hasDeliveryOrders?'查看收货单':'对方尚未创建收货单'}}</el-button>
    <el-button class="purchase-order-btn" :disabled="!hasReconciliationOrders" v-if="isFactory()&&isCompleted"
      @click="onCreateReconciliation">
      {{hasReconciliationOrders?'查看对账单':'对方尚未创建对账单'}}</el-button>
    <el-button class="purchase-order-btn2" @click="
    onCancel" v-if="isPending">{{isMyself?'取消订单':'拒单'}}
    </el-button>
  </el-row>
</template>

<script>
  export default {
    name: "PurchaseOrdersButtonGroup",
    props: ['slotData'],
    components: {},
    computed: {
      isMyself: function () {
        return this.$store.getters.currentUser.companyCode == this.slotData.belongTo.uid;
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
        this.$emit('onCancel');
      },
      onConfirm() {
        this.$emit('onConfirm');
      },
      onCreateAgain() {
        this.$emit('onCreateAgain');
      },
      onCreateReceive() {
        this.$emit('onCreateReceive');
      },
      onDeliverViewsOpen() {
        this.$emit('onDeliverViewsOpen');
      },
      onCreateReconciliation() {
        this.$emit('onReconciliation');
      }
    },
    data() {
      return {};
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
    background: red;
    color: #fff;
    width: 200px;
  }

</style>
