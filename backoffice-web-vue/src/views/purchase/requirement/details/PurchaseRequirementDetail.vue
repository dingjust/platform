<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row type="flex" justify="space-between">
        <el-col :span="6">
          <div class="purchase-list-title">
            <h6>采购需求详情</h6>
          </div>
        </el-col>
        <el-col :span="6">
          <h6>状态/标签：{{'未审核'}}</h6>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <el-row type="flex" justify="start" class="basic-row">
        <el-col :span="6">
          <h6>任务单号：{{'09877121111111'}}</h6>
        </el-col>
        <el-col :span="6">
          <h6>关联订单：{{'CO10201200010'}}</h6>
        </el-col>
        <el-col :span="6">
          <h6>关联款号：{{'CO10201200010'}}</h6>
        </el-col>
        <el-col :span="6">
          <h6>创建时间：{{1630375172000 | timestampToTime}}</h6>
        </el-col>
      </el-row>
      <el-row type="flex" justify="start" class="basic-row">
        <el-col :span="6">
          <h6>是否含税：{{'否'}}</h6>
        </el-col>
        <el-col :span="6">
          <h6>品质要求：{{'一等品'}}</h6>
        </el-col>
        <el-col :span="6">
          <h6>采购员：{{'CO10201200010'}}</h6>
        </el-col>
      </el-row>
      <el-row type="flex" justify="start" class="basic-row">
        <h6>收货地址：{{'广东省广州市海珠区云顶同创汇707'}}</h6>
      </el-row>
      <purchase-requirement-table :formData="formData"/>
    </el-card>
  </div>
</template>

<script>
import PurchaseRequirementTable from '../components/PurchaseRequirementTable'

export default {
  name: 'PurchaseRequirementDetail',
  components: {
    PurchaseRequirementTable
  },
  data () {
    return {
      formData: {
        
      }
    }
  }  
}
</script>

<style scoped>
  .purchase-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .basic-row {
    margin: 0px 0px 10px 20px;
  }
</style>