<template>
  <div class="payment-form-container">
    <el-row type="flex" justify="space-between">
      <el-col :span="4">
        <div class="financial-list-title">
          <h6>付款内容</h6>
        </div>
      </el-col>
    </el-row>
    <div class="pt-2"></div>
    <el-form ref="form" :model="formData" :inline="true" :rules="rules" :hide-required-asterisk="true">
      <el-row type="flex" justify="center" align="top">
        <el-col :span="20">
          <el-form-item>
            <template slot="label">
              <span>付款方式<span style="color: #F56C6C"> *</span></span>
            </template>
            <el-radio-group v-model="formData.paymentMethod">
              <template v-for="item in PaymentMethod">
                <el-radio :label="item.code" :key="item.code" style="margin-bottom: 0px">{{item.name}}</el-radio>
              </template>
            </el-radio-group>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row type="flex" justify="center" align="top">
        <el-col :span="20">
          <el-form-item prop="payTime">
            <template slot="label">
              <span>付款时间<span style="color: #F56C6C"> *</span></span>
            </template>
            <el-date-picker v-model="formData.payTime" type="date" placeholder="选择日期" value-format="timestamp"/>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row type="flex" justify="center" align="top">
        <el-col :span="20">
          <el-form-item prop="paymentVouchers" :rules="[{ type: Array, validator: validatePaymentVouchers, trigger: 'blur' }]">
            <template slot="label">
              <span>付款凭证<span style="color: #F56C6C"> *</span></span>
            </template>
            <images-upload :slotData="formData.paymentVouchers" />
          </el-form-item>
        </el-col>
      </el-row>
    </el-form>
    <el-row type="flex" justify="center" align="middle">
      <el-button class="create-btn" @click="onConfirm">提交</el-button>
    </el-row>
  </div>
</template>

<script>
  import {ImagesUpload} from '@/components/index.js'
  export default {
    name: 'PaymentForm',
    props: ['id'],
    components: {
      ImagesUpload
    },
    computed: {
    },
    methods: {
      onConfirm () {
        this.$refs.form.validate((valid) => {
          if (valid) {
            this._onConfirm();
          } else {
            this.$message.error('请完善表单信息！');
            return false;
          }
        });
      },
      async _onConfirm () {
        const url = this.apis().appendPaymentRecord(this.id);
        const result = await this.$http.post(url, this.formData);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        this.$message.success('付款成功');
      },
      validateField (name) {
        this.$refs.form.validateField(name);
      },
      validatePaymentVouchers (rule, value, callback) {
        if (value.length <= 0) {
          callback(new Error('请上传付款凭证'));
        } else {
          callback();
        }
      }
    },
    data () {
      return {
        rules: {
          payTime: [{required: true, message: '请选择付款时间', trigger: 'blur'}]
        },
        PaymentMethod: this.$store.state.EnumsModule.PaymentMethod,
        formData: {
          paymentMethod: 'E_BANK',
          payTime: '',
          paymentVouchers: []
        }
      }
    },
    watch: {
      'formData.paymentVouchers': function (nval, oval) {
        this.validateField('paymentVouchers');
      }
    }
  }
</script>

<style scoped>
  .create-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    width: 120px;
    height: 40px;
    border-radius: 10px;
  }

  .financial-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .payment-form-container >>> .el-upload--picture-card {
    width: 100px;
    height: 100px;
    line-height: 100px;
  }

  .payment-form-container >>> .el-upload-list--picture-card .el-upload-list__item {
    width: 100px;
    height: 100px;
  }
</style>