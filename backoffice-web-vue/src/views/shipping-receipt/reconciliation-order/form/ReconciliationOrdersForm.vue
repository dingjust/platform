<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="4">
          <div class="title">
            <h6>创建对账单</h6>
          </div>
        </el-col>
      </el-row>
      <el-form :inline="true">
        <!-- <reconciliation-orders-form-head/></reconciliation-orders-form-head> -->
      </el-form>
    </el-card>
  </div>
</template>

<script>
  export default {
    name: 'ReconciliationOrdersForm'
  }
</script>

<style scoped>
  .title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }
</style>