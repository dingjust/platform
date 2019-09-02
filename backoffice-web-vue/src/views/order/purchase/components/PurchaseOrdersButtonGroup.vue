<template>
  <el-row class="purchase-order-row" type="flex" justify="center" align="middle" :gutter="50">
    <el-button class="purchase-order-btn" v-if="isMyself&&isPending" @click="onUniqueCode">唯一码
    </el-button>
    <el-button class="purchase-order-btn" v-if="isBrand" @click="onUniqueCode">收货单</el-button>
    <el-button class="purchase-order-btn" v-if="isBrand" @click="onUniqueCode">创建对账单</el-button>
    <el-button class="purchase-order-btn" @click="onCreateAgain">{{isBrand?'再下一单':'重新创建'}}</el-button>
    <el-button class="purchase-order-btn" v-if="!isMyself&&isPending" @click="onConfirm">接单</el-button>
    <el-button class="purchase-order-btn" v-if="isFactory" @click="onUniqueCode">发货单</el-button>
    <el-button class="purchase-order-btn" v-if="isFactory" @click="onUniqueCode">查看收货单</el-button>
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
        return this.currentUser.companyCode == this.slotData.belongTo.uid;
      },
      isPending: function () {
        return this.slotData.status == 'PENDING_CONFIRM';
      },
    },
    methods: {
      isBrand() {
        return this.currentUser.type == 'BRAND';
      },
      isFactory() {
        return this.currentUser.type == 'FACTORY';
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
      }
    },
    data() {
      return {
        currentUser: this.$store.getters.currentUser
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
    background: red;
    color: #fff;
    width: 200px;
  }

</style>
