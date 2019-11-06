<template>
  <el-card>
    <el-row type="flex" justify="space-between" align="middle">
      <el-col :span="4">
        <div class="grid-head">
          <h6>生产订单</h6>
        </div>
      </el-col>
      <el-col :span="4">
        <div class="purchase-grid-content">
          <h5>历史订单 6</h5>
        </div>
      </el-col>
      <el-col :span="4">
        <div class="purchase-grid-content">
          <h5>生产总款数 6</h5>
        </div>
      </el-col>
      <el-col :span="4">
        <div class="purchase-grid-content">
          <h5>生产总收入 6</h5>
        </div>
      </el-col>
      <el-col :span="4">
        <div class="purchase-grid-content">
          <h5>准交率 51</h5>
        </div>
      </el-col>
         <el-col :span="4">
        <div class="purchase-grid-content">
          <h5>平均生产时间内 51h</h5>
        </div>
      </el-col>
    </el-row>
  </el-card>
</template>

<script>
  export default {
    name: "PurchaseOrdersReport",
    components: {},
    computed: {},
    methods: {},
    data() {
      return {};
    },
    created() {}
  };

</script>
<style scoped>
  .purchase-grid-content {
    text-align: center;
    border-left: 2px solid rgba(0, 0, 0, 0.09);
  }

  .grid-head {
    text-align: start;
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .grid-tail {
    text-align: end;
    color: orange;
  }

  /deep/ .el-card__body {
    padding: 10px;
  }

</style>
