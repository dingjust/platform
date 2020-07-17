<template>
  <div>
    <el-row type="flex" justify="start">
      <h6>外发生产工单：{{formData.productionTaskOrder.code}}</h6>
    </el-row>
    <el-row type="flex" justify="start" class="basic-row" v-if="formData.productionTaskOrder.code != ''">
      <el-col :span="3">
        <img width="100px" height="100px"
          :src="formData.product!=null?formData.product.thumbnail.url:'static/img/nopicture.png'">
      </el-col>
      <el-col :span="21">
        <el-row type="flex" style="padding: 10px 0px">
          <el-col :span="8">
            <h6>产品名称：{{formData.product?formData.product.name:''}}</h6>
          </el-col>
          <el-col :span="8">
            <h6>货号：{{formData.product?formData.product.skuID:''}}</h6>
          </el-col>
          <el-col :span="8">
            <h6>合同：</h6>
          </el-col>
        </el-row>
        <el-row type="flex" style="padding-bottom: 10px">
          <el-col :span="8">
            <h6>单价：{{formData.productionTaskOrder.unitPrice}}</h6>
          </el-col>
          <el-col :span="8">
            <h6>数量：{{formData.productionTaskOrder.quantity}}</h6>
          </el-col>
        </el-row>
        <el-row type="flex" style="padding-bottom: 10px">
          <el-col :span="8">
            <h6>加工方式：{{getEnum('cooperationModes',formData.productionTaskOrder.cooperationMode)}}</h6>
          </el-col>
          <el-col :span="8">
            <h6>交货日期：{{formData.productionTaskOrder.deliveryDate|formatDateInday}}</h6>
          </el-col>
        </el-row>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  export default {
    name: 'ReconciliationOrdersDetailHead',
    props: {
      formData: {
        type: Object,
        required: true
      },      
    },    
  }

</script>

<style scoped>
  .sumbit-btn {
    width: 70px;
    background-color: #ffd60c;
  }

</style>
