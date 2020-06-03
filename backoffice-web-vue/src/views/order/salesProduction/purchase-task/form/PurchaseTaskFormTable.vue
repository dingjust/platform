<template>
  <div class="purchase-task-form">
    <div class="over-tabs">
      <el-row type="flex">
        <el-button class="material-btn" @click="appendMaterial">添加物料</el-button>
      </el-row>
    </div>
    <el-tabs type="border-card">
      <el-tab-pane label="采购明细">
        <purchase-details-table :form-data="formData.purchaseDetails"/>
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script>
  import PurchaseDetailsTable from '../table/PurchaseDetailsTable';
  export default {
    name: 'PurchaseTaskFormTable',
    components: {PurchaseDetailsTable},
    props: ['formData'],
    methods: {
      appendMaterial () {
        this.$emit('appendMaterial');
      }
    }
  }
</script>

<style scoped>
  .purchase-task-form {
    margin-left: 10px;
    margin-top: 20px;
  }

  .over-tabs {
    position: absolute;
    z-index: 100;
    right: 30px;
    margin-top: 2px;
  }

  .material-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    width: 90px;
    height: 35px;
  }
</style>
