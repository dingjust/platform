<template>
  <div>
    <el-row type="flex">
      <el-col :span="12">
        <el-row class="info-basic-row" type="flex" align="middle" justify="start" :gutter="20">
          <el-col>
            <h5 style="font-weight: bold">订单详情</h5>
          </el-col>
        </el-row>
        <el-row class="info-basic-row" type="flex" align="middle" justify="start" :gutter="20">
          <el-col :span="10">
            <h6>生产单号：{{slotData.code}}</h6>
          </el-col>
          <el-col :span="8">
            <h6>合作方式：{{getEnum('machiningTypes', slotData.machiningType)}}</h6>
          </el-col>
          <el-col :span="6">
            <h6>是否开发票：{{slotData.curNeedVoice ? '是' : '否'}}</h6>
          </el-col>
        </el-row>
        <el-row class="info-basic-row" type="flex" align="middle" justify="start" :gutter="20">
          <el-col :span="10">
            <h6>生产总数：{{slotData.productionTotal}}</h6>
          </el-col>
          <el-col :span="8">
            <h6>生产总价：{{slotData.priceTotal}}</h6>
          </el-col>
        </el-row>
        <el-row class="info-basic-row" type="flex" align="middle" justify="start" :gutter="20">
          <el-col :span="10">
            <h6>送货地址：{{slotData.address}}</h6>
          </el-col>
        </el-row>
      </el-col>
      <el-divider direction="vertical"></el-divider>
      <el-col :span="8">
        <el-row class="info-basic-row" type="flex" align="middle" justify="start" :gutter="20">
          <el-col>
            <h5 style="font-weight: bold">合作商信息</h5>
          </el-col>
        </el-row>
        <el-row class="info-basic-row" type="flex" align="middle" justify="start" :gutter="20">
          <el-col>
            <h6>合作工厂：{{slotData.cooperateFactory}}</h6>
          </el-col>
        </el-row>
        <el-row class="info-basic-row" type="flex" align="middle" justify="start" :gutter="20">
          <el-col :span="12">
            <h6>联系人：{{slotData.contactPerson}}</h6>
          </el-col>
          <el-col :span="12">
            <h6>联系方式：{{slotData.contactPhone}}</h6>
          </el-col>
        </el-row>
        <el-row class="info-basic-row" type="flex" align="middle" justify="start" :gutter="20">
          <el-col>
            <h5 style="font-weight: bold">人员设置</h5>
          </el-col>
        </el-row>
        <el-row class="info-basic-row" type="flex" align="middle" justify="start" :gutter="20">
          <el-col :span="12">
            <h6>品牌跟单员：{{slotData.factoryQC}}</h6>
          </el-col>
          <el-col :span="12">
            <h6>联系方式：{{slotData.factoryQCPhone}}</h6>
          </el-col>
        </el-row>
        <el-row class="info-basic-row" type="flex" align="middle" justify="start" :gutter="20">
          <el-col :span="12">
            <h6>工厂跟单员：{{slotData.brandQC}}</h6>
          </el-col>
          <el-col :span="12">
            <h6>联系方式：{{slotData.brandQCPhone}}</h6>
          </el-col>
        </el-row>
      </el-col>
      <el-divider direction="vertical"></el-divider>
      <el-col :span="4">
        <el-row class="info-basic-row" type="flex" align="middle" justify="space-between" :gutter="20">
          <el-col :span="8">
            <h5 style="font-weight: bold">合同</h5>
          </el-col>
          <el-col :span="12">
            <el-button type="text" style="color: #ffd60c">签署合同</el-button>
          </el-col>
        </el-row>
        <el-row class="info-basic-row" type="flex" justify="center" :gutter="20">
<!--          <el-col :span="16">-->
<!--            <el-row>-->
<!--              <img src="static/img/word.png" class="info-img-word" alt="" :title="slotData.contract.name"/>-->
<!--            </el-row>-->
<!--            <el-row>-->
<!--              <h6 style="padding-left: 30px;">{{slotData.contract.name}}</h6>-->
<!--            </el-row>-->
<!--          </el-col>-->
        </el-row>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  export default {
    name: 'OutboundOrderTopInfo',
    props: ['slotData']
  }
</script>

<style scoped>
  .info-basic-row {
    margin-top: 10px;
    padding-left: 10px;
  }

  .info-img-word {
    width: 100px;
    height: 100px;
    margin-bottom: 5px;
  }

  .el-divider--vertical{
    height: auto;
    margin: 0px;
  }
</style>
