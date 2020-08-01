<template>
  <div class="animated fadeIn dashboard-card">
    <el-row type="flex" justify="space-between" :gutter="80">
      <el-col :span="12">
        <el-row class="dashboard-row">
          <div class="dashboard-title">
            <h6 class="dashboard-title_text">生意</h6>
          </div>
        </el-row>
        <el-row class="dashboard-row" type="flex" justify="space-between" align="middle">
          <div class="dashboard-content">
            <el-row>
              <h6 class="dashboard-content_text">{{data.requirement1}}</h6>
            </el-row>
            <el-row>
              <h6 class="dashboard-content_text2">个需求待我报价</h6>
            </el-row>
          </div>
          <div class="dashboard-content">
            <el-row>
              <h6 class="dashboard-content_text">{{data.requirement2}}</h6>
            </el-row>
            <el-row>
              <h6 class="dashboard-content_text2">份报价待品牌处理</h6>
            </el-row>
          </div>
        </el-row>
        <el-row class="dashboard-row">
          <div class="dashboard-title">
            <h6 class="dashboard-title_text">合同</h6>
          </div>
        </el-row>
        <el-row type="flex" justify="space-between" align="middle">
          <div class="dashboard-content">
            <el-row>
              <h6 class="dashboard-content_text">{{data.agreement1}}</h6>
            </el-row>
            <el-row>
              <h6 class="dashboard-content_text2">份合同待我签署</h6>
            </el-row>
          </div>
          <div class="dashboard-content">
            <el-row>
              <h6 class="dashboard-content_text">{{data.agreement2}}</h6>
            </el-row>
            <el-row>
              <h6 class="dashboard-content_text2">份合同待对方处理</h6>
            </el-row>
          </div>
        </el-row>
      </el-col>
      <el-col :span="12">
        <el-row class="dashboard-row" type="flex" justify="space-between" align="middle">
          <div class="dashboard-title">
            <h6 class="dashboard-title_text">订单</h6>
          </div>
          <i class="el-icon-setting dashboard-setting-btn">设置</i>
        </el-row>
        <el-row class="dashboard-row" type="flex" justify="space-between" align="middle">
          <div class="dashboard-content">
            <el-row>
              <h6 class="dashboard-content_text">{{data.purchase1}}</h6>
            </el-row>
            <el-row>
              <h6 class="dashboard-content_text2">笔订单正在打样</h6>
            </el-row>
          </div>
          <div class="dashboard-content">
            <el-row>
              <h6 class="dashboard-content_text">{{data.purchase2}}</h6>
            </el-row>
            <el-row>
              <h6 class="dashboard-content_text2">笔订单正在生产</h6>
            </el-row>
          </div>
        </el-row>
        <el-row class="dashboard-row">
          <div class="dashboard-title">
            <h6 class="dashboard-title_text">财务</h6>
          </div>
        </el-row>
        <el-row type="flex" justify="space-between" align="middle">
          <div class="dashboard-content">
            <el-row>
              <h6 class="dashboard-content_text">{{data.wallet1}}</h6>
            </el-row>
            <el-row>
              <h6 class="dashboard-content_text2">条提现申请待审批</h6>
            </el-row>
          </div>
          <div class="dashboard-content">
            <el-row>
              <h6 class="dashboard-content_text">{{data.wallet2}}</h6>
            </el-row>
            <el-row>
              <h6 class="dashboard-content_text2">笔用户打账到款</h6>
            </el-row>
          </div>
        </el-row>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  export default {
    name: 'BusinessCard',
    components: {

    },
    computed: {

    },
    methods: {
      async getData() {
        const url = this.apis().reportsTab1();
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.data = result.data;
      }
    },
    data() {
      return {
        data: {
          agreement1: 0,
          agreement2: 0,
          requirement1: 0,
          requirement2: 0,
          purchase1: 0,
          purchase2: 0,
          wallet1: 0,
          wallet2: 0
        }
      };
    },
    created() {
      this.getData();
    }
  };

</script>
<style scoped>
  .dashboard-row {
    margin-bottom: 20px;
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

  .dashboard-content {
    width: 100%;
    /* border-left: 2px solid #FFE373; */
    padding-left: 10px;
    /* height: 14px; */
  }

  .dashboard-content_text {
    font-size: 26px;
    font-weight: bold;
    color: rgba(255, 164, 3, 0.85);
    margin-bottom: 5px !important;
  }

  .dashboard-content_text2 {
    font-size: 12px;
    font-weight: 400;
    color: rgba(153, 153, 153, 1);
    margin-bottom: 0px !important;
  }

  .dashboard-setting-btn {
    font-size: 12px;
    width: 50px;
    color: rgba(153, 153, 153, 1);
  }

  .dashboard-setting-btn:hover {
    cursor: pointer;
  }

</style>
