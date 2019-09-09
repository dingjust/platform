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
          <h6 class="finance-form-text1" v-if="isFactory()">剩余未收/本期总额</h6>
          <h6 class="finance-form-text3">￥{{payPlanItem.remainingUnReceiptAmount,2 | floatFormat}}/￥{{slotData.totalPrice * payPlanItem.payPercent,2 | floatFormat}}</h6>
        </el-row>
      </el-col>
    </el-row>
    <el-row type="flex" align="middle">
      <el-col :span="8">
        <el-row type="flex" align="middle">
          <h6 class="finance-form-text1">收款类型</h6>
          <div style="margin-left: 20px">
            <el-radio-group v-model="form.paymentType" size="mini" fill="#FFD60C">
              <el-radio-button v-for="item in receiptTypes"
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
          <el-col :span="8">
            <h6 class="finance-form-text1" >本次收款金额</h6>
          </el-col>
          <el-col :span="16">
            <el-input class="finance-form" v-model="form.amount" type="number" :min="0" ></el-input>
          </el-col>
        </el-row>
      </el-col>
    </el-row>
    <el-row type="flex" align="middle" style="margin-bottom:5px;">
      <el-col :span="4"><h6 class="finance-form-text1" >本次收款凭证</h6></el-col>

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
        <el-button class="finance-form-btn" @click="createReceiptOrder" >确认</el-button>
      </el-col>
    </el-row>
    <el-row>
      <purchase-order-info-receipt :slot-data="slotData" :receiptOrders="receiptOrders" @refreshItem="refreshItem"
                                   @refreshData="refreshData()"/>
    </el-row>
  </div>
</template>

<script>
  import PurchaseOrderInfoReceipt from './PurchaseOrderInfoReceipt';

  export default {
    name: 'PurchaseOrderFinanceReceiptForm',
    components: {
      PurchaseOrderInfoReceipt
    },
    props: ['slotData', 'payPlanItem', 'form', 'receiptOrders'],
    mixins: [],
    computed: {
      headers: function () {
        return {
          Authorization: this.$store.getters.token
        }
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
      async createReceiptOrder () {
        if (this.form.paymentType === '') {
          this.$message.error('请选择收款类型');
          return;
        }

        if (this.form.amount === '') {
          this.$message.error('金额必填');
          return;
        }

        if (this.payPlanItem.remainingUnReceiptAmount < parseFloat(this.form.amount)) {
          this.$confirm('收款金额将超出剩余未收金额', '是否确认创建收款单', {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            type: 'warning'
          }).then(() => {
            this.commit();
          });
        } else {
          this.commit();
        }
      },
      async commit () {
        if (this.form.payCertificate === '') {
          this.form.payCertificate = null;
        }
        const result = await this.$http.post(this.apis().createReceiptOrder(this.payPlanItem.id), this.form);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
        }
        this.$emit('clearFormData');
        this.$emit('refreshItem');
      },
      async refreshItem () {
        this.$emit('refreshItem');
      },
      async refreshData () {
        this.$emit('refreshData');
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
