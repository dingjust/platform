<template>
  <div class="finance-form-body">
    <el-row class="info-title-row">
      <div class="info-title">
        <h6 class="info-title_text">账务记录</h6>
      </div>
    </el-row>
    <el-row type="flex">
      <el-col :span="8">
        <el-row type="flex">
          <h6 class="finance-form-text1">当前账期</h6>
          <h6 class="finance-form-text2">{{payPlanItem.moneyType | enumTranslate('PayMoneyType')}}</h6>
        </el-row>
      </el-col>
      <el-col :span="16">
        <el-row type="flex">
          <h6 class="finance-form-text1" v-if="isBrand()">剩余未付/本期总额</h6>
          <h6 class="finance-form-text3">￥{{payPlanItem.remainingUnpaidAmount,2 | floatFormat}}/￥{{slotData.totalPrice * payPlanItem.payPercent,2 | floatFormat}}</h6>
        </el-row>
      </el-col>
    </el-row>
    <el-row type="flex" align="middle">
      <el-col :span="8">
        <el-row type="flex" align="middle">
          <h6 class="finance-form-text1">类型</h6>
          <div style="margin-left: 20px">
            <el-radio-group v-model="form.paymentType" size="mini" fill="#FFD60C">
              <el-radio-button v-for="item in paymentTypes"
                               :label="item.code"
                               :key="item.code"
                               :value="item.code">
                {{item.name}}
              </el-radio-button>
            </el-radio-group>
          </div>
        </el-row>
      </el-col>
      <el-col :span="8">
        <el-row type="flex" align="middle">
          <el-col :span="8" v-if="isBrand()">
            <h6 class="finance-form-text1" >本次付款金额</h6>
          </el-col>
          <el-col :span="16">
            <el-input class="finance-form" v-model="form.amount" type="number"></el-input>
          </el-col>
        </el-row>
      </el-col>
    </el-row>
    <el-row type="flex" align="middle" style="margin-bottom:5px;">
      <el-col :span="4"><h6 class="finance-form-text1" >本次付款凭证</h6></el-col>

      <el-link class="finance-form-link" v-if="form.payCertificate!=''" :href="form.payCertificate.url" target="_blank">
        {{form.payCertificate.name}}</el-link>
        <el-upload name="file" :action="mediaUploadUrl" :data="uploadFormData" :show-file-list="false"
                   :before-upload="onBeforeUpload" :on-success="onSuccess" :headers="headers">
          <el-button type="text" size="mini">点击上传</el-button>
        </el-upload>
    </el-row>
    <el-row type="flex" align="middle" :gutter="20">
      <el-col :span="16">
        <el-row type="flex" align="middle">
          <el-col :span="2">
            <h6 class="finance-form-text1">备注</h6>
          </el-col>
          <el-col :span="22">
            <el-input class="finance-form" v-model="form.remarks"></el-input>
          </el-col>
        </el-row>
      </el-col>
      <el-col :span="8">
        <el-button class="finance-form-btn" @click="createPaymentOrder" >确认</el-button>
      </el-col>
    </el-row>
    <el-row >
      <purchase-order-info-payment :slot-data="slotData" :payPlanItem="payPlanItem" @refreshData="refreshData" :paymentOrders="paymentOrders"/>
    </el-row>
  </div>
</template>

<script>
  import PurchaseOrderInfoPayment from './PurchaseOrderInfoPayment';

  export default {
    name: 'PurchaseOrderFinancePaymentForm',
    components: {
      PurchaseOrderInfoPayment
    },
    props: ['slotData', 'payPlanItem', 'form'],
    mixins: [],
    computed: {
      headers: function () {
        return {
          Authorization: this.$store.getters.token
        }
      },
      paymentOrders: function () {
        let result = [];
        for (var payPlanItem of this.slotData.payPlan.payPlanItems) {
          for (var payment of payPlanItem.paymentOrders) {
            result.push(payment);
          }
        }

        if (result.length > 0) {
          result[result.length - 1].deletable = true;
        }

        return result;
      }
    },
    methods: {
      onBeforeUpload (file) {
        if (file.size > 1024 * 1024 * 10) {
          this.$message.error('上传的文件不允许超过10M');
          return false;
        }

        return true;
      },
      onSuccess (response) {
        this.form.payCertificate = response;
      },
      handlePreview (file) {
        this.dialogImageUrl = file.url;
        this.dialogVisible = true;
      },
      async createPaymentOrder () {
        if (this.form.paymentType === '') {
          this.$message.error('类型必填');
          return;
        }

        if (this.form.payCertificate === '') {
          this.form.payCertificate = null;
        }
        const result = await this.$http.post(this.apis().createPaymentOrder(this.payPlanItem.id), this.form);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
        }
        this.$emit('close');
      },
      async refreshData () {
        const url = this.apis().getPurchaseOrder(this.slotData.code);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$emit('refreshItem');
      }
    },
    data () {
      return {
        paymentTypes: this.$store.state.EnumsModule.PaymentType,
        receiptTypes: this.$store.state.EnumsModule.ReceiptType,
        uploadFormData: {
          fileFormat: 'DefaultFileFormat',
          conversionGroup: 'DefaultProductConversionGroup'
        }
      }
    },
    created () {

    },
    mounted () {}

  }
</script>
<style>
  .finance-form-body {
    width: 100%;
  }

  .finance-form-row {
    margin-bottom: 20px;
  }

  .finance-form-text1 {
    font-size: 10px;
    font-weight: 400;
    color: rgba(0, 0, 0, 0.85);
  }

  .finance-form-text2 {
    font-size: 10px;
    font-weight: 400;
    color: rgba(0, 0, 0, 0.45);
    margin-left: 20px;
  }

  .finance-form-text3 {
    font-size: 10px;
    font-weight: 500;
    color: rgba(255, 51, 51, 0.65);
    margin-left: 20px;
  }

  .finance-form .el-input__inner {
    height: 24px;
    line-height: 24px;
    margin-bottom: 5px;
  }

  .finance-form-text2 {
    font-size: 10px;
    font-weight: 400;
    color: rgba(0, 0, 0, 0.45);
    /* margin-left: 20px; */
  }

  .finance-form-link {
    font-size: 10px;
    font-weight: 400;
    color: rgba(0, 0, 0, 0.45);
    /* margin-left: 20px; */
  }

  .finance-form-btn {
    /* width: 50px; */
    height: 20px;
    background: #FFD60C;
    font-weight: 400;
    color: rgba(0, 0, 0, 0.85);
    font-size: 10px;
    border-radius: 5px;
    text-align: center;
    border: 0px solid #FFD60C;
    padding-bottom: 16px;
    margin-bottom: 6px;
  }

  .finance-form-table {
    font-size: 10px;
  }

</style>
