<template>
  <div class="animated fadeIn dashboard-card">
    <el-dialog :visible.sync="uniquecodeFormVisible" width="30%" class="uniquecode-dialog" append-to-body>
      <uniquecode-import-form />
    </el-dialog>
    <el-row type="flex" align="middle" justify="start">
      <el-col :span="4">
        <div class="dashboard-title">
          <h6 class="dashboard-title_text">工具直通车：</h6>
        </div>
      </el-col>
      <el-button class="dashboard-toolbar-btn" size="mini" @click="jumpToOrderPurchase">创建线下订单</el-button>
      <el-button class="dashboard-toolbar-btn" size="mini" @click="uniquecodeFormVisible=!uniquecodeFormVisible">唯一码导入
      </el-button>
      <el-button class="dashboard-toolbar-btn" size="mini">公司认证</el-button>
      <el-button class="dashboard-toolbar-btn" size="mini" @click="jumpToTemplate">电子合同模板</el-button>
    </el-row>
  </div>
</template>

<script>
  import UniquecodeImportForm from '@/components/custom/UniquecodeImportForm';

  export default {
    name: 'ToolbarCard',
    components: {
      UniquecodeImportForm
    },
    computed: {

    },
    methods: {
      onSetting() {

      },
      jumpToTemplate() {
        this.$router.push("template");
      },
      jumpToOrderPurchase() {
        this.$router.push("orderPurchase");
      }
    },
    data() {
      return {
        uniquecodeFormVisible: false
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

  .uniquecode-dialog .el-dialog {
    border-radius: 10px !important;
  }

  .uniquecode-dialog-header {
    padding: 0px !important;
  }

  .uniquecode-dialog .el-dialog__header {
    padding: 0px !important;
  }
</style>
