<template>
  <div class="animated fadeIn content payment-request-container">
    <el-card>
      <div class="financial-plan-triangle_box">
        <div class="financial-plan-triangle" :style="getTriangleColor">
          <h6 class="financial-plan-triangle_text">已审核</h6>
        </div>
      </div>
      <el-row type="flex" justify="space-between">
        <el-col :span="4">
          <div class="financial-list-title">
            <h6>付款申请单</h6>
          </div>
        </el-col>
        <el-col :span="6">
          <h6 style="color: #F56C6C">申请金额超过未付款金额</h6>
        </el-col>
        <el-col :span="4">
          <h6>状态：待付款</h6>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <el-row type="flex" justify="center">
        <el-col :span="22">
          <el-row type="flex" justify="start" align="middle" style="margin-bottom: 15px">
            <el-col :span="8">
              <h6>申请单号：1230000000</h6>
            </el-col>
            <el-col :span="8">
              <h6>订单号：1230000000</h6>
            </el-col>
            <el-col :span="8">
              <h6>合同号：1230000000</h6>
            </el-col>
          </el-row>
          <el-row type="flex" justify="start" align="middle" style="margin-bottom: 15px">
            <el-col :span="8">
              <h6>申请部门：销售一部</h6>
            </el-col>
            <el-col :span="8">
              <h6>申请人：旷小勇</h6>
            </el-col>
            <el-col :span="8">
              <h6>付款内容：货款</h6>
            </el-col>
          </el-row>
          <el-row type="flex" justify="start" align="middle" style="margin-bottom: 15px">
            <el-col :span="8">
              <h6>收款对象：宁波衣加衣供应链管理有限公司</h6>
            </el-col>
            <el-col :span="8">
              <h6>申请金额：20000元</h6>
            </el-col>
            <el-col :span="8">
              <h6>金额大写：叁万元整</h6>
            </el-col>
          </el-row>
          <el-row type="flex" justify="start" align="middle" style="margin-bottom: 15px">
            <el-col :span="8">
              <h6>收款人：宁波衣加衣供应链管理有限公司</h6>
            </el-col>
            <el-col :span="8">
              <h6>收款账号：0987654321234567890</h6>
            </el-col>
            <el-col :span="8">
              <h6>开户行：中国农业银行股份有限公司宁波江东支行</h6>
            </el-col>
          </el-row>
          <el-row type="flex" justify="start" align="middle" style="margin-bottom: 15px">
            <el-col :span="8">
              <h6>审批人：旷小勇 旷小勇</h6>
            </el-col>
          </el-row>
          <el-row type="flex" justify="start" align="middle" style="margin-bottom: 15px">
            <el-col :span="8">
              <h6>备注：</h6>
              <h6 style="margin-left: 20px">备注旷小勇 旷小勇</h6>
            </el-col>
          </el-row>
          <el-row type="flex" justify="start" align="middle" style="margin-top: 20px">
            <el-col :span="8">
              <h6>上传凭证</h6>
              <el-row style="margin-left: 20px">
                <images-upload :slotData="formData.media"></images-upload>
              </el-row>
            </el-col>
          </el-row>
        </el-col>
      </el-row>
      <el-row type="flex" justify="center" align="middle" style="margin-top: 20px">
        <el-button class="create-btn" @click="onConfirm">去付款</el-button>
      </el-row>
    </el-card>
  </div>
</template>

<script>
  import {PersonnelSelection, ImagesUpload} from '@/components/index.js'
  export default {
    name: 'PaymentRequestDetail',
    props: ['id'],
    components: {
      PersonnelSelection,
      ImagesUpload
    },
    computed: { 
      getTriangleColor: function () {
        switch (this.formData.auditState) {
          case 'AUDITING':
            return 'border-right: 70px solid #114EE8;';
          case 'PASSED':
            return 'border-right: 70px solid #4DE811;';
          case 'AUDITED_FAILED':
            return 'border-right: 70px solid #D91A17;';
          case 'NONE':
            return 'border-right: 70px solid #BBBBBB;';
          default:
            return 'border-right: 70px solid #BBBBBB;';
        }
      }
    },
    methods: {
      onConfirm () {

      }
    },
    data () {
      return {
        formData: {
          approvers: [{}],
          media: []
        }
      }
    },
    created () {
    },
    destroyed () {
      
    }
  }
</script>

<style scoped>
  .financial-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .payment-request-input {
    width: 194px;
  }

  .payment-request-container >>> .el-upload--picture-card {
    width: 100px;
    height: 100px;
    line-height: 100px;
  }

  .payment-request-container >>> .el-upload-list--picture-card .el-upload-list__item {
    width: 100px;
    height: 100px;
  }

  .create-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    width: 120px;
    height: 40px;
    border-radius: 10px;
  }

  .financial-plan-triangle_box {
    margin-top: 1px;
    position: absolute;
    right: 0;
    top: 0;
  }

  .financial-plan-triangle {
    width: 0;
    height: 0;
    border-right: 70px solid white;
    border-bottom: 70px solid transparent;
    z-index: 0;
  }

  .financial-plan-triangle_text {
    width: 80px;
    padding-top: 10px;
    padding-left: 37px;
    transform: rotateZ(45deg);
    color: white;
    font-size: 12px;
  }
</style>