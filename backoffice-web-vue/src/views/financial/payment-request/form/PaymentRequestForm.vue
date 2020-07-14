<template>
  <div class="animated fadeIn content payment-request-container">
    <el-card>
      <el-row>
        <el-col :span="4">
          <div class="financial-list-title">
            <h6>创建付款申请单</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <el-form :inline="true" :model="formData" label-position="right" label-width="100px">
        <el-row type="flex" justify="start" align="top" style="padding-left: 10px">
          <el-col :span="7">
            <el-form-item label="付款申请单号">
              <el-input placeholder="系统自动生成" :disabled="true" class="payment-request-input"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="9">
            <el-form-item label="订单号">
              <el-input class="payment-request-input"></el-input>
              <el-button>选择</el-button>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="合同号">
              <el-input class="payment-request-input"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row type="flex" justify="start" align="top" style="padding-left: 10px">
          <el-col :span="7">
            <el-form-item label="申请部门">
              <el-input class="payment-request-input"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="9">
            <el-form-item label="申请人">
              <el-input :disabled="true" class="payment-request-input"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="付款内容">
              <el-input class="payment-request-input"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row type="flex" justify="start" align="top" style="padding-left: 10px">
          <el-col :span="7">
            <el-form-item label="收款对象">
              <el-input :disabled="true" class="payment-request-input"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="9">
            <el-form-item label="申请金额" style="margin-bottom: 0px">
              <el-input class="payment-request-input">
                <span slot="suffix">元</span>
              </el-input>
              <h6 style="color: #909399">可申请金额3000元</h6>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="金额大写">
              <el-input :disabled="true" class="payment-request-input"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row type="flex" justify="start" align="top" style="padding-left: 10px">
          <el-col :span="7">
            <el-form-item label="收款人">
              <el-input class="payment-request-input"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="9">
            <el-form-item label="收款账号">
              <el-input class="payment-request-input"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="开户行">
              <el-input class="payment-request-input"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row type="flex" justify="start" align="top" style="padding-left: 10px">
          <template v-for="(item, index) in formData.approvers">
            <el-col :span="8" :key="index">
              <el-form-item label="审批人">
                <personnel-selection :vPerson.sync="item"/>
              </el-form-item>
            </el-col>
          </template>
          <el-col :span="2">
            <el-button @click="addApprover" v-if="formData.approvers.length < 2">+ 添加审核员</el-button>
          </el-col>
        </el-row>
        <el-row type="flex" justify="start" align="top" style="padding-left: 10px">
          <el-col :span="21">
            <el-form-item label="备注" style="margin-bottom: 0px"></el-form-item>
            <el-input type="textarea" style="margin-left: 100px;"></el-input>
          </el-col>
        </el-row>
        <el-row type="flex" justify="start" align="middle" style="margin-top: 20px;padding-left: 10px">
          <el-col :span="8">
            <el-form-item label="上传凭证">
              <images-upload :slotData="formData.media"></images-upload>
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <el-row type="flex" justify="center" align="middle">
        <el-button class="create-btn" @click="onConfirm">提交</el-button>
      </el-row>
    </el-card>
  </div>
</template>

<script>
  import {PersonnelSelection, ImagesUpload} from '@/components/index.js'
  export default {
    name: 'PaymentRequestForm',
    props: {

    },
    components: {
      PersonnelSelection,
      ImagesUpload
    },
    computed: {

    },
    methods: {
      addApprover () {
        this.formData.approvers.push({});
      },
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
</style>