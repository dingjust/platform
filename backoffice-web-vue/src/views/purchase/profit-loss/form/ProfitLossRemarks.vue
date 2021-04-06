<!--
* @Description: 盈亏分析表单备注模块
* @Date 2021/03/23 10:25
* @Author L.G.Y
-->
<template>
  <div>
    <el-row>
      <h6 class="row-title">质检要求说明：</h6>
    </el-row>
    <el-row>
      <el-input type="textarea" :rows="3" placeholder="请输入内容" v-model="formData.explain" />
    </el-row>
    <el-row style="margin-top: 20px">
      <h6 class="row-title">其他备注：</h6>
    </el-row>
    <el-row>
      <el-input type="textarea" :rows="3" placeholder="请输入内容" v-model="formData.remarks" />
    </el-row>
  </div>
</template>

<script>
export default {
  name: 'ProfitLossRemarks',
  props: ['formData']
}
</script>

<style scoped>
  .row-title {
    font-size: 14px;
    color: #606266;
  }
</style>