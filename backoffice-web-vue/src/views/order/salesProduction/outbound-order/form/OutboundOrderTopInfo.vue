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
            <h6>合作方式：{{getEnum('machiningTypes', slotData.cooperationMode)}}</h6>
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
            <h6>生产总数：{{slotData.totalQuantity}}</h6>
          </el-col>
          <el-col :span="15">
            <h6>生产总价：{{totalAmount}}元</h6>
          </el-col>
        </el-row>
        <el-row class="info-basic-row" type="flex" align="middle" justify="start">
          <el-col :span="24">
            <h6>送货地址：{{slotData.taskOrderEntries[0].shippingAddress.details}}</h6>
          </el-col>
        </el-row>
        <el-row class="info-basic-row" type="flex" align="middle" justify="start">
          <el-col :span="24">
            <h6>财务</h6>
          </el-col>
        </el-row>
        <el-row class="info-basic-row" type="flex" align="middle" justify="start" v-popover:popover>
          <el-col :span="9">
            <h6>有无定金：{{slotData.payPlan.isHaveDeposit ? '有定金' : '无定金'}}</h6>
          </el-col>
          <el-col :span="9">
            <h6>尾款期数：{{payPlanType[slotData.payPlan.payPlanType]}}</h6>
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
            <h6>合作工厂：{{slotData.targetCooperator.type == 'ONLINE' ?
              slotData.targetCooperator.partner.name : slotData.targetCooperator.name}}</h6>
          </el-col>
        </el-row>
        <el-row class="info-basic-row" type="flex" align="middle" justify="start">
          <el-col :span="12">
            <h6>联系人：{{slotData.targetCooperator.type == 'ONLINE' ?
              slotData.targetCooperator.partner.contactPerson : slotData.targetCooperator.contactPerson}}</h6>
          </el-col>
          <el-col :span="12">
            <h6>联系方式：{{slotData.targetCooperator.type == 'ONLINE' ?
              slotData.targetCooperator.partner.contactPhone : slotData.targetCooperator.contactPhone}}</h6>
          </el-col>
        </el-row>
        <el-row class="info-basic-row" type="flex" align="middle" justify="start">
          <el-col>
            <h5 style="font-weight: bold">人员设置</h5>
          </el-col>
        </el-row>
        <el-row class="info-basic-row" type="flex" align="middle" justify="start">
          <el-col :span="12">
            <h6 class="hide-text" :title="slotData.merchandiser ? slotData.merchandiser.name : ''">
              跟单员：{{slotData.merchandiser ? slotData.merchandiser.name : ''}}</h6>
          </el-col>
          <el-col :span="12">
            <h6>联系方式：{{slotData.merchandiser ? slotData.merchandiser.mobileNumber : ''}}</h6>
          </el-col>
        </el-row>
      </el-col>
      <el-divider direction="vertical"></el-divider>
      <el-col :span="5">
        <el-row class="info-basic-row" type="flex" align="middle" justify="start">
          <contract-com :slotData="slotData" :contracts="contracts" :canSign="canSign" />
        </el-row>
      </el-col>
    </el-row>
    <el-popover ref="popover" placement="top-start" width="500" trigger="hover">
      <pay-plan-info :form="payPlan"></pay-plan-info>
    </el-popover>
  </div>
</template>

<script>
  import ContractCom from '../../contract/ContractCom';
  import {PayPlanInfo} from '@/components/'

  export default {
    name: 'OutboundOrderTopInfo',
    components: {
      ContractCom,
      PayPlanInfo
    },
    props: ['slotData', 'payPlan'],
    computed: {
      totalAmount: function () {
        let totalAmount = 0;
        this.slotData.taskOrderEntries.forEach(item => {
          totalAmount += (item.unitPrice * item.quantity);
        })
        return totalAmount;
      },
      // 已签合同列表
      contracts: function () {
        return this.slotData.agreements ? this.slotData.agreements : [];
      },
      // 判断是否能签署合同
      canSign: function () {
        // 未签合同 && 账号为merchandiser && 审核状态为 PASSED
        return this.slotData.agreements &&
          this.slotData.agreements.length <= 0 &&
          this.$store.getters.currentUser.uid == this.slotData.merchandiser.uid &&
          this.slotData.sendAuditState == 'PASSED' &&
          this.slotData.acceptState == 'ACCEPTED';
      }
    },
    methods: {},
    data() {
      return {
        currentUser: this.$store.getters.currentUser,
        payPlanType: {
          'PHASEONE': '一期尾款',
          'PHASETWO': '二期尾款',
          'MONTHLY_SETTLEMENT': '月结'
        }
      }
    },
    created() {}
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

  .el-divider--vertical {
    height: auto;
    margin: 0px;
  }

  .hide-text {
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }

</style>
