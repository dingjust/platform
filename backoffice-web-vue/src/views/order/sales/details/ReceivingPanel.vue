<template>
  <div class="sale-details-b1_body">
    <el-dialog :visible.sync="formShow" width="60%" class="purchase-dialog" :close-on-click-modal="false">
      <return-form @onSubmit="onReturnSubmit" />
    </el-dialog>
    <el-row type="flex" align="top">
      <h6>
        订单当前状态：
        <span style="font-weight: bold;">卖家已发货，等待买家确认</span>
      </h6>
    </el-row>
    <el-row type="flex" align="bottom">
      <el-col :span="2" :offset="3">
        <h6 class="sales-details-info">物流信息：</h6>
      </el-col>
    </el-row>
    <el-row type="flex">
      <el-col :span="20" :offset="5">
        <h6>顺丰速运 运单号：<el-button type="text"><span style="color:blue">SF4654654651231132</span></el-button>
        </h6>
      </el-col>
    </el-row>
    <el-row type="flex">
      <el-col :span="20" :offset="5">
        <span style="color:red;font-size:12px;">点击运单号查看物流</span>
      </el-col>
    </el-row>
    <el-row type="flex" justify="end">
      <el-col :span="3">
        <el-button class="sales-order-btn" style="background:white" @click="onReturn">申请退货</el-button>
      </el-col>
      <el-col :span="3">
        <el-button class="sales-order-btn" @click="onSure">确认收货</el-button>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  import ReturnForm from "../form/ReturnForm";

  export default {
    name: "ReceivingPanel",
    components: {
      ReturnForm
    },
    computed: {},
    methods: {
      onSure(){

      },
      onReturn() {
        this.formShow = true;
      },
      onReturnSubmit() {
        //Todo APi
        this.formShow = false;
      }
    },
    data() {
      return {
        formShow: false
      }
    },
    created() {

    },
    mounted() {}
  };

</script>
<style>
</style>
