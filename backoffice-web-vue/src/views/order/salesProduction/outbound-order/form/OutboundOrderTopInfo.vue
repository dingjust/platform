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
            <h6>是否开发票：{{slotData.invoiceNeeded ? '是' : '否'}}</h6>
          </el-col>
        </el-row>
        <el-row class="info-basic-row" type="flex" align="middle" justify="start" :gutter="20">
          <el-col :span="10">
            <h6>生产总数：{{totalQuantity}}</h6>
          </el-col>
          <el-col :span="14">
            <h6>生产总价：{{totalPrice}}</h6>
          </el-col>
        </el-row>
        <el-row class="info-basic-row" type="flex" align="middle" justify="start" :gutter="20">
          <el-col :span="24">
            <h6>送货地址：{{slotData.entries[0].shippingAddress.details}}</h6>
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
            <h6>合作工厂：{{slotData.cooperator.type == 'ONLINE' ?
              slotData.cooperator.partner.name : slotData.cooperator.name}}</h6>
          </el-col>
        </el-row>
        <el-row class="info-basic-row" type="flex" align="middle" justify="start" :gutter="20">
          <el-col :span="12">
<!--            <h6>联系人：{{slotData.cooperator.contactPerson}}</h6>-->
            <h6>合作工厂：{{slotData.cooperator.type == 'ONLINE' ?
              slotData.cooperator.partner.contactPerson : slotData.cooperator.contactPerson}}</h6>
          </el-col>
          <el-col :span="12">
<!--            <h6>联系方式：{{slotData.cooperator.contactPhone}}</h6>-->
            <h6>合作工厂：{{slotData.cooperator.type == 'ONLINE' ?
              slotData.cooperator.partner.contactPhone : slotData.cooperator.contactPhone}}</h6>
          </el-col>
        </el-row>
        <el-row class="info-basic-row" type="flex" align="middle" justify="start" :gutter="20">
          <el-col>
            <h5 style="font-weight: bold">人员设置</h5>
          </el-col>
        </el-row>
        <el-row class="info-basic-row" type="flex" align="middle" justify="start" :gutter="20">
          <el-col :span="12">
            <h6>甲方跟单员：{{slotData.partyAOperator ? slotData.partyAOperator.name : ''}}</h6>
          </el-col>
          <el-col :span="12">
            <h6>联系方式：{{slotData.partyAOperator ? slotData.partyAOperator.mobileNumber : ''}}</h6>
          </el-col>
        </el-row>
        <el-row class="info-basic-row" type="flex" align="middle" justify="start" :gutter="20">
          <el-col :span="12">
            <h6>乙方跟单员：{{slotData.partyBOperator ? slotData.partyBOperator.name : ''}}</h6>
          </el-col>
          <el-col :span="12">
            <h6>联系方式：{{slotData.partyBOperator ? slotData.partyBOperator.mobileNumber : ''}}</h6>
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
    props: ['slotData'],
    computed: {
      totalQuantity: function () {
        let count = 0
        this.slotData.entries.forEach(item => {
          count += item.totalQuantity;
        })
        return count;
      },
      totalPrice: function () {
        let count = 0
        this.slotData.entries.forEach(item => {
          count += item.totalPrice;
        })
        return count;
      }
    },
    methods: {
      initOperator () {
        const type = this.currentUser.type;
        if (type == 'FACTORY') {
          if (this.currentUser.companyCode == this.slotData.partyACompany.uid) {
            this.operator.factory = this.slotData.partyACompany.name;
          }
        } else {

        }
      }
    },
    data () {
      return {
        currentUser: this.$store.getters.currentUser,
        operator: {}
      }
    },
    created () {
      this.initOperator();
    }
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
