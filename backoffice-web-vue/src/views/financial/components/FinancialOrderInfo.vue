<template>
  <div>
    <div class="financial-info-box">
      <div class="financial-border-container financial-info-one">
        <el-row type="flex" justify="start" align="middle" class="basic-row">
          <h6>订单基本信息</h6>
        </el-row>
        <el-row type="flex" justify="start" align="middle" class="basic-row">
          <el-col :span="11">
            <h6>合作方式：包工包料</h6>
          </el-col>
          <el-col :span="8">
            <h6>是否开发票：是</h6>
          </el-col>
          <el-col :span="5">
            <h6>税率：15%</h6>
          </el-col>
        </el-row>
        <el-row type="flex" justify="start" align="middle" class="basic-row">
          <el-col :span="11">
            <h6>订单数量：80000</h6>
          </el-col>
          <el-col :span="12">
            <h6>订单总金额(元)：120000</h6>
          </el-col>
        </el-row>
        <el-row type="flex" justify="start" align="middle" class="basic-row">
          <h6>财务方案</h6>
        </el-row>
        <el-row type="flex" justify="start" align="middle" class="basic-row" v-popover:popover>
          <el-col :span="11">
            <h6>定金：有定金</h6>
          </el-col>
          <el-col :span="12">
            <h6>尾款期数：一期尾款</h6>
          </el-col>
          <el-popover ref="popover" placement="top-start" width="500" trigger="hover">
            <pay-plan-info :form="payPlan"></pay-plan-info>
          </el-popover>
        </el-row>
      </div>
      <div style="margin-left: 10px"></div>
      <div class="financial-border-container financial-info-one">
        <el-row type="flex" justify="start" align="middle" class="basic-row">
          <h6>合作商</h6>
        </el-row>
        <el-row type="flex" justify="start" align="middle" class="basic-row">
          <el-col :span="12">
            <h6>联系人：马化腾</h6>
          </el-col>
          <el-col :span="12">
            <h6>联系方式：66666666666</h6>
          </el-col>
        </el-row>
        <el-row type="flex" justify="start" align="middle" class="basic-row">
          <h6>人员设置</h6>
        </el-row>
        <el-row type="flex" justify="start" align="middle" class="basic-row">
          <el-col :span="12">
            <h6>订单创建人：马化腾</h6>
          </el-col>
          <el-col :span="12">
            <h6>生产负责人：马化腾</h6>
          </el-col>
        </el-row>
        <el-row type="flex" justify="start" align="middle" class="basic-row">
          <el-col :span="12">
            <h6>审批负责人：马化腾</h6>
          </el-col>
        </el-row>
      </div>
      <div style="margin-left: 10px"></div>
      <div class="financial-border-container financial-info-two">
        <contract-com :slotData="form" :contracts="[]" :canSign="true"/>
      </div>
    </div>
  </div>
</template>

<script>
  import ContractCom from '../../order/salesProduction/contract/ContractCom'
  import {PayPlanInfo} from '@/components/index.js'
  export default {
    name: 'FinancialOrderInfo',
    props: ['form', 'payPlan'],
    components: {
      PayPlanInfo,
      ContractCom
    },
    computed: {
    },
    methods: {
    },
    data () {
      return {
      }
    },
    created () {
    },
    destroyed () {
      
    }
  }
</script>

<style scoped>
  .basic-row {
    margin-bottom: 5px;
  }

  .financial-info-box {
    display:table;
    margin:0 auto;
    width: 100%;
  }
  
  .financial-info-one {
    width: 40%;
    display: table-cell;
  }

  .financial-info-two {
    width: 20%;
    display: table-cell;
  }

  .financial-border-container{
    border: 2px solid #E5E5E5;
    border-radius: 5px;
    padding: 10px 10px 10px 10px;
  }
</style>