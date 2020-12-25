<template>
  <div class="animated fadeIn dashboard-card">
    <el-row type="flex" class="dashboard-row" justify="space-between">
      <div class="dashboard-title">
        <h6 class="dashboard-title_text">本月入账</h6>
      </div>
      <i class="el-icon-s-fold dashboard-icon-btn"></i>
    </el-row>
    <el-row type="flex" justify="center">
      <h6 class="dashboard-entry-income">￥0</h6>
    </el-row>
    <el-row type="flex" justify="center" :gutter="80">
      <el-col :span="12">
        <h6 class="dashboard-entry-income2" style="text-align: right;">已入账：￥0.00</h6>
      </el-col>
      <el-col :span="12">
        <h6 class="dashboard-entry-income2">未到账：￥0.00</h6>
      </el-col>
    </el-row>
    <el-row type="flex" justify="space-around" style="margin-top:30px;">
      <el-col :span="8" class="col-container">
        <h6 class="dashboard-entry-num">0</h6>
        <h6 class="dashboard-entry-income2"> 今日访客</h6>
      </el-col>
      <el-col :span="8" class="col-container">
        <h6 class="dashboard-entry-num">0</h6>
        <h6 class="dashboard-entry-income2">上架产品</h6>
      </el-col>
      <el-col :span="8" class="col-container">
        <h6 class="dashboard-entry-num">0</h6>
        <h6 class="dashboard-entry-income2">本月接单</h6>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  export default {
    name: 'AccountEntryCard',
    components: {

    },
    computed: {

    },
    methods: {
      onSetting() {

      }
    },
    data() {
      return {

      };
    },
    created() {}
  };

</script>
<style>
  .dashboard-row {
    margin-bottom: 10px;
  }

  .dashboard-title {
    width: 100%;
    border-left: 2px solid #FFD60C;
    padding-left: 10px;
    height: 14px;
  }

  .dashboard-title2 {
    width: 100%;
    padding-left: 12px;
    height: 14px;
  }

  .dashboard-title_text {
    font-size: 12px;
    font-weight: bold;
    color: rgba(0, 0, 0, 0.85);
  }

  .dashboard-icon-btn {
    font-size: 18px;
    color: #333333;
  }

  .dashboard-entry-income {
    font-weight: 500;
    color: rgba(255, 164, 3, 1);
    font-size: 36px;
    text-align: center;
  }

  .dashboard-entry-income2 {
    font-weight: 500;
    color: rgba(153, 153, 153, 1);
    font-size: 12px;
  }

  .dashboard-entry-num {
    font-weight: 500;
    color: rgba(255, 164, 3, 1);
    font-size: 30px;
    text-align: center;
  }

  .col-container {
    display: flex;
    flex-direction: column;
    align-items: center;
  }
</style>
