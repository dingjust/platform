<template>
  <div class="animated fadeIn dashboard-card">
    <el-row type="flex" class="dashboard-row" justify="space-between">
      <div class="dashboard-title">
        <h6 class="dashboard-title_text">{{slotData.title}}</h6>
      </div>
      <i class="el-icon-s-fold dashboard-icon-btn"></i>
    </el-row>
    <div style="display: flex;justify-content: space-between;">
      <div>
        <el-row>
          <h6 class="dashboard-income-money">￥{{slotData.income}}</h6>
        </el-row>
        <el-row type="flex" style="margin-top:5px;white-space: nowrap;" align="middle">
          <h6 class="dashboard-income-text">月同比 {{slotData.comparison}}</h6>
          <i class="el-icon-caret-top dashboard-icon-caret"></i>
        </el-row>
      </div>
      <div>
        <el-row>
          <h6 class="dashboard-income-text">以收入：￥{{slotData.incomed}}</h6>
        </el-row>
        <el-row>
          <h6 class="dashboard-income-text">打样订单数：{{slotData.proofingOrders}}</h6>
        </el-row>
        <el-row>
          <h6 class="dashboard-income-text">生产订单数：{{slotData.purchaseOrders}}</h6>
        </el-row>
      </div>
    </div>
  </div>
</template>

<script>
  export default {
    name: 'MonthIncomeCard',
    props: ['slotData'],
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

  .dashboard-income-money {
    font-weight: 500;
    color: rgba(255, 164, 3, 1);
    font-size: 24px;
  }

  .dashboard-icon-caret {
    color: rgba(17, 209, 62, 1);
    font-size: 18px;
    margin-bottom: 10px;
  }

  .dashboard-income-text {
    font-weight: 400;
    color: rgba(0, 0, 0, 0.7);
    font-size: 12px;
  }

</style>
