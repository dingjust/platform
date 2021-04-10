<template>
  <div class="detail-container">
    <el-row>
      <h6>质检要求说明：</h6>
    </el-row>
    <el-row style="margin-left: 28px">
      <h6>{{detail.explain ? detail.explain : '无'}}</h6>
    </el-row>
    <el-row>
      <h6>其他备注：</h6>
    </el-row>
    <el-row style="margin-left: 28px">
      <h6>{{detail.remarks ? detail.remarks : '无'}}</h6>
    </el-row>
  </div>
</template>

<script>
export default {
  name: 'ProfitLossDetailRemarks',
  props: ['detail']
}
</script>

<style scoped>
  .detail-container {
    margin: 0px 0px 10px 20px;
    font-size: 14px;
    color: #606266;
  }
</style>