<template>
  <div class="purchase-task-form">
    <el-tabs type="border-card">
      <el-tab-pane label="采购明细">
        <purchase-details-table :form-data="formData.purchaseDetails"/>
      </el-tab-pane>
      <el-tab-pane label="采购进度">
        <purchase-progress-table :form-data="formData.purchaseDetails"/>
      </el-tab-pane>
      <el-tab-pane label="财务详情">
        <purchase-pay-plan-table :form-data="formData.purchaseDetails"/>
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script>
  import PurchaseDetailsTable from '../table/PurchaseDetailsTable';
  import PurchaseProgressTable from '../table/PurchaseProgressTable';
  import PurchasePayPlanTable from '../table/PurchasePayPlanTable';
  export default {
    name: 'PurchaseTaskDetailTable',
    components: {PurchasePayPlanTable, PurchaseProgressTable, PurchaseDetailsTable},
    props: ['formData'],
    methods: {
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
