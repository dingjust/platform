<template>
  <div class="sale-details-b1_body">
    <el-dialog :visible.sync="formShow" width="75%"
      class="purchase-dialog" :close-on-click-modal="false">
      <delivery-form @onSubmit="onDeliverySubmit"  />
    </el-dialog>
    <el-row type="flex" align="top">
      <h6>
        订单当前状态：
        <span style="color:#ffac76;font-weight: bold;">买家已付款，等待卖家发货</span>
      </h6>
    </el-row>
    <el-row type="flex" align="bottom">
      <el-col :span="2" :offset="3">
        <h6 class="sales-details-info">您可以</h6>
      </el-col>
      <el-col :span="3">
        <el-button class="sales-order-btn" @click="onDelivery">去发货</el-button>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  import DeliveryForm from "../form/DeliveryForm";

  export default {
    name: "DeliveryPanel",
    components: {
      DeliveryForm
    },
    computed: {},
    methods: {
        onDelivery() {
          this.formShow=true;
        },
        onDeliverySubmit(){
          //Todo APi
          this.formShow=false;
        }
    },
    data() {
      return {
        formShow:false
      }
    },
    created() {

    },
    mounted() {}
  };

</script>
<style>
</style>
