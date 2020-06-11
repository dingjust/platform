<template>
  <div class="animated fadeIn">
    <el-row type="flex" class="basic-form-row">
      <h5 style="fontWeight: bold;">外发要求</h5>
    </el-row>
    <el-row type="flex" class="basic-form-row" :gutter="10">
      <!-- <el-col :span="8">
        <h6>外发目标价格:&#12288;￥{{form.price}}</h6>
      </el-col> -->
      <el-col :span="8">
        <h6>外发交期:&#12288;{{form.time | timestampToTime}}</h6>
      </el-col>
      <el-col :span="8">
        <h6>工厂规模:&#12288;{{getEnum('populationScales', form.populationScales)}}</h6>
      </el-col>
    </el-row>
    <el-row type="flex" class="basic-form-row" :gutter="10">
      <el-col :span="8">
        <h6>合作方式:&#12288;{{getEnum('cooperationModes', form.type)}}</h6>
      </el-col>
      <el-col :span="8">
        <h6>是否开发票:&#12288;{{form.fapiao}}</h6>
      </el-col>
      <el-col :span="8">
        <h6>入仓方式:&#12288;{{form.warehouse}}</h6>
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
    <el-row type="flex" class="basic-form-row">
      <el-col>
        <h6>指定工厂:&#12288;{{form.assignFactory}}</h6>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  export default {
    name: 'InvoiceDetailsForm',
    data () {
      return {
        form: {
          price: '123',
          time: 1588581316000,
          populationScales: 'N02',
          assignFactory: '宁波衣加衣供应链有限公司',
          type: 'LABOR_AND_MATERIAL',
          warehouse: '入客户仓',
          fapiao: '不开发票',
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
