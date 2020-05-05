<template>
  <div class="animated fadeIn" style="margin-bottom: 34px">
    <el-row type="flex" class="basic-form-row">
      <h5 style="fontWeight: bold;">接单内容</h5>
    </el-row>
    <el-row type="flex" class="basic-form-row">
      <el-col :span="8">
        <h6>接单价格:&#12288;￥{{form.price}}</h6>
      </el-col>
      <el-col :span="8">
        <h6>交货日期:&#12288;{{form.time | timestampToTime}}</h6>
      </el-col>
    </el-row>
    <el-row type="flex" class="basic-form-row">
      <el-col :span="8">
        <h6>合作方式:&#12288;{{getEnum('cooperationModes', form.type)}}</h6>
      </el-col>
      <el-col :span="8">
        <h6>是否开发票:&#12288;{{form.fapiao}}</h6>
      </el-col>
    </el-row>
    <el-row type="flex" class="basic-form-row">
      <el-col :span="8">
        <h6>联系人:&#12288;{{form.contactPerson}}</h6>
      </el-col>
      <el-col :span="8">
        <h6>联系方式:&#12288;{{form.contactPhone}}</h6>
      </el-col>
    </el-row>
    <el-row type="flex" class="basic-form-row">
      <el-col>
        <h6>收货地址:&#12288;{{form.address}}</h6>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  export default {
    name: 'ReceivingDetailsForm',
    data () {
      return {
        form: {
          price: '123',
          time: 1588581316000,
          type: 'LABOR_AND_MATERIAL',
          fapiao: '不开发票',
          populationScales: 'N02',
          contactPerson: '一加一',
          contactPhone: '13888888888',
          address: '广东省广州市海珠区云顶同创汇1233112313707'
        }
      }
    }
  }
</script>

<style scoped>
  .basic-form-row {
    padding-left: 10px;
    margin-bottom: 5px;
  }
</style>
