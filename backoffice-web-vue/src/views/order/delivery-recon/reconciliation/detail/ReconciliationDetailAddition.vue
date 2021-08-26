<!--
* @Description: 出货对账单 附加项/备注 详情部分
* @Date 2021/03/08 14:44
* @Author L.G.Y
-->
<template>
  <div>
    <el-row type="flex" style="margin-top: 10px;">
      <h6 class="title-text">附加项</h6>
    </el-row>
    <el-table :data="order.additionalCharges">
      <el-table-column label="名称" prop="remarks"></el-table-column>
      <el-table-column label="金额" prop="amount"></el-table-column>
    </el-table>
    <el-row type="flex" justify="end" style="margin-top: 10px">
      <h6 style="font-size: 20px;">应付金额：</h6>
      <h6 style="font-size: 20px;">{{order.amountPayableTotal}}</h6>
    </el-row>
    <el-row type="flex" style="margin-top: 10px">
      <h6 class="title-text">备注：</h6>
    </el-row>
    <el-row type="flex" style="margin: 10px 0 0 23px;">
      <h6 class="title-text">{{order.remarks}}</h6>
      <!-- <el-input type="textarea" :rows="3" placeholder="请输入内容" v-model="order.remarks" /> -->
    </el-row>
  </div>  
</template>

<script>
export default {
  name: 'ReconciliationDetailAddition',
  props: ['order']
}
</script>

<style scoped>
  .title-text {
    font-size: 14px;
    color: #606266;
    margin: 0px;
  }
</style>