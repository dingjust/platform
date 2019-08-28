<template>
  <div class="animated fadeIn dashboard-card">
    <el-row type="flex" align="middle" justify="start">
      <el-col :span="4">
      <div class="dashboard-title">
        <h6 class="dashboard-title_text">工具直通车：</h6>
      </div>
      </el-col>
      <el-button class="dashboard-toolbar-btn" size="mini">创建线下订单</el-button>
      <el-button class="dashboard-toolbar-btn" size="mini">唯一码导入</el-button>
      <el-button class="dashboard-toolbar-btn" size="mini">公司认证</el-button>
      <el-button class="dashboard-toolbar-btn" size="mini">电子合同模板</el-button>
    </el-row>
  </div>
</template>

<script>
  export default {
    name: 'ToolbarCard',
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

  .dashboard-toolbar-btn {
    border: 0.5px solid rgba(255, 164, 3, 1);
    color: rgba(255, 164, 3, 1);
    /* height: ; */
    font-size: 10px;
  }

</style>
