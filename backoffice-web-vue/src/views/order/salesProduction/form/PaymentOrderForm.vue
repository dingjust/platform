<template>
  <div class="payment-form-body">
    <el-row class="payment-form-title-row">
      <div class="payment-form-title">
        <h6 class="payment-form-title_text">添加支付单</h6>
      </div>
    </el-row>
    <el-form ref="form" :model="form" :inline="true">
      <el-form-item label="交易编号" prop="outOrderNo" :rules="[{ required: true, message: '请填写交易编号', trigger: 'blur' }]">
        <el-input v-model="form.outOrderNo"></el-input>
      </el-form-item>
      <el-button type="text" @click="generateCode">没有编号点我</el-button>
      <el-form-item label="支付金额" prop="payAmount" :rules="[{ required: true, message: '请填写支付金额', trigger: 'blur' }]">
        <el-input v-model="form.payAmount"></el-input>
      </el-form-item>
      <el-form-item label="支付方式" prop="payType" :rules="[{ required: true, message: '请填写支付金额', trigger: 'blur' }]">
        <el-select v-model="form.payType">
          <el-option v-for="item in PayMethod" :key="item.code" :label="item.name" :value="item.code"></el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="支付时间" prop="paySuccessTime"
        :rules="[{ required: true, message: '请填写支付时间', trigger: 'blur' }]">
        <el-date-picker v-model="form.paySuccessTime" type="datetime" value-format="timestamp"></el-date-picker>
      </el-form-item>
      <el-row>
        <el-form-item label="备注" prop="remark">
          <el-input v-model="form.remark" type="textarea" style="width:300px" :placeholder="placeholder"></el-input>
        </el-form-item>
      </el-row>
    </el-form>
    <el-row type="flex" justify="end">
      <el-button type="default" @click="onCancel">取消</el-button>
      <el-button type="primary" @click="onSure">确认导入</el-button>
    </el-row>
  </div>
</template>

<script>
  import {
    formatDate
  } from '@/common/js/filters';

  export default {
    name: "PaymentOrderForm",
    props: ['formData', 'handleForm'],
    computed: {
      placeholder: function () {
        if (this.form.payType == 'E_BANK') {
          return '姓名、银行信息...';
        } else {
          return '请输入相关备注';
        }
      }
    },
    methods: {
      onSure() {
        this.$refs.form.validate(valid => {
          if (valid) {
            this.$confirm('是否提交数据?', '提示', {
              confirmButtonText: '是',
              cancelButtonText: '否',
              type: 'warning'
            }).then(() => {
              this._onSure()
            });
          } else {
            this.$message.error('请先完善表单')
          }
        })
      },
      async _onSure() {
        const form = this.form
        form.originCode = form.originCode ? form.originCode : this.formData.code

        this.$emit('onSure', form)
      },
      onCancel() {
        this.$emit('closeDialog')
      },
      generateCode() {
        if (this.form.paySuccessTime == null || this.form.paySuccessTime == '') {
          this.$message.error('请先设置支付时间');
          return
        }else{
          this.form.outOrderNo='PMO'+this.formData.code+'-'+formatDate(new Date(this.form.paySuccessTime), 'yyyyMMddhhmmss');
        }
      }
    },
    data() {
      return {
        form: {
          outOrderNo: '',
          payAmount: '',
          originCode: '',
          payType: 'WECHAT_PAY_QRCODE',
          paySuccessTime: new Date().getTime(),
          remark: ''
        },
        PayMethod: this.$store.state.EnumsModule.PayMethod
      };
    },
    created() {
      if (this.handleForm) {
        this.form = this.handleForm
      }
    }
  };

</script>

<style scoped>
  .payment-form-body {
    width: 100%;
  }

  .payment-form-title {
    width: 100%;
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
    height: 14px;
  }

  .payment-form-title_text {
    font-size: 12px;
    font-weight: 500;
    color: rgba(0, 0, 0, 1);
    opacity: 0.65;
  }

  .payment-form-title-row {
    margin-bottom: 20px;
  }

  .payment-form-order {
    background-color: rgba(0, 0, 0, 0.02);
    padding-top: 10px;
    padding-bottom: 10px;
    padding-left: 10px;
    padding-right: 10px;
    margin-top: 20px;
  }

  .payment-form-text {
    font-size: 12px;
    color: rgba(51, 48, 48, 0.65);
  }

  .payment-form-btn {
    background: #ffd60c;
    color: rgba(0, 0, 0, 0.85);
    width: 200px;
    margin-top: 20px;
  }

  .submit-btn {
    background-color: #FFD60C;
    border-color: #FFD60C;
    width: 150px;
    margin-top: 20px;
  }

  .form-table {
    width: 100%;
    margin-top: 20px;
  }

</style>
