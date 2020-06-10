<template>
  <div>
    <el-row type="flex">
      <el-col :span="12">
        <el-row class="info-basic-row" type="flex" align="middle" justify="start">
          <el-col>
            <h5 style="font-weight: bold">订单详情</h5>
          </el-col>
        </el-row>
        <el-row class="info-basic-row" type="flex" align="middle" justify="start">
          <el-col :span="9">
            <h6>生产单号：{{slotData.code}}</h6>
          </el-col>
          <el-col :span="7">
            <h6>合作方式：{{getEnum('machiningTypes', slotData.machiningType)}}</h6>
          </el-col>
          <el-col :span="5">
            <h6>是否开票：{{slotData.invoiceNeeded ? '是' : '否'}}</h6>
          </el-col>
          <el-col :span="3" v-if="slotData.invoiceNeeded">
            <h6>税点：{{slotData.invoiceTaxPoint * 100}}%</h6>
          </el-col>
        </el-row>
        <el-row class="info-basic-row" type="flex" align="middle" justify="start">
          <el-col :span="9">
            <h6>生产总数：{{totalQuantity}}</h6>
          </el-col>
          <el-col :span="15">
            <h6>生产总价：{{totalPrice}}元</h6>
          </el-col>
        </el-row>
        <el-row class="info-basic-row" type="flex" align="middle" justify="start">
          <el-col :span="24">
            <h6>送货地址：{{slotData.entries[0].shippingAddress.details}}</h6>
          </el-col>
        </el-row>
      </el-col>
      <el-divider direction="vertical"></el-divider>
      <el-col :span="7">
        <el-row class="info-basic-row" type="flex" align="middle" justify="start">
          <el-col>
            <h5 style="font-weight: bold">合作商信息</h5>
          </el-col>
        </el-row>
        <el-row class="info-basic-row" type="flex" align="middle" justify="start">
          <el-col>
            <h6>合作工厂：{{slotData.cooperator.type == 'ONLINE' ?
              slotData.cooperator.partner.name : slotData.cooperator.name}}</h6>
          </el-col>
        </el-row>
        <el-row class="info-basic-row" type="flex" align="middle" justify="start">
          <el-col :span="12">
            <h6>联系人：{{slotData.cooperator.type == 'ONLINE' ?
              slotData.cooperator.partner.contactPerson : slotData.cooperator.contactPerson}}</h6>
          </el-col>
          <el-col :span="12">
            <h6>联系方式：{{slotData.cooperator.type == 'ONLINE' ?
              slotData.cooperator.partner.contactPhone : slotData.cooperator.contactPhone}}</h6>
          </el-col>
        </el-row>
        <el-row class="info-basic-row" type="flex" align="middle" justify="start">
          <el-col>
            <h5 style="font-weight: bold">人员设置</h5>
          </el-col>
        </el-row>
        <el-row class="info-basic-row" type="flex" align="middle" justify="start">
          <el-col :span="12">
            <h6 class="hide-text" :title="slotData.partyAOperator ? slotData.partyAOperator.name : ''">
              跟单员：{{slotData.partyAOperator ? slotData.partyAOperator.name : ''}}</h6>
          </el-col>
          <el-col :span="12">
            <h6>联系方式：{{slotData.partyAOperator ? slotData.partyAOperator.mobileNumber : ''}}</h6>
          </el-col>
        </el-row>
<!--        <el-row class="info-basic-row" type="flex" align="middle" justify="start">-->
<!--          <el-col :span="12">-->
<!--            <h6 class="hide-text" :title="slotData.partyBOperator ? slotData.partyBOperator.name : ''">-->
<!--              乙方跟单员：{{slotData.partyBOperator ? slotData.partyBOperator.name : ''}}</h6>-->
<!--          </el-col>-->
<!--          <el-col :span="12">-->
<!--            <h6>联系方式：{{slotData.partyBOperator ? slotData.partyBOperator.mobileNumber : ''}}</h6>-->
<!--          </el-col>-->
<!--        </el-row>-->
      </el-col>
      <el-divider direction="vertical"></el-divider>
      <el-col :span="5">
        <el-row class="info-basic-row" type="flex" align="middle" justify="start">
          <contract-com :slotData="slotData" :contracts="contracts" :canSign="canSign"/>
        </el-row>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  import ContractCom from '../../contract/ContractCom';
  export default {
    name: 'OutboundOrderTopInfo',
    components: {ContractCom},
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
      },
      // 已签合同列表
      contracts: function () {
        return this.slotData.agreements ? this.slotData.agreements : [];
      },
      // 判断是否能签署合同
      canSign: function () {

      }
    },
    methods: {
    },
    data () {
      return {
        currentUser: this.$store.getters.currentUser
      }
    },
    created () {
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

  .hide-text {
    overflow: hidden;
    text-overflow:ellipsis;
    white-space: nowrap;
  }
</style>
