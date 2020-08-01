<template>
  <div>
    <el-row>
      <el-col :span="6">
        <div class="financial-list-title">
          <h6>{{readOnly ? '发票详情' : '上传发票'}}</h6>
        </div>
      </el-col>
    </el-row>
    <div class="pt-2"></div>
    <el-form ref="form" :model="invoiceData" :inline="true">
      <el-row type="flex" justify="center" align="middle" style="margin-bottom: 10px">
        <el-form-item prop="image" :rules="[{ type: Object, validator: validateImage, trigger: 'change' }]">
          <images-upload-single :formData="invoiceData.image" :disabled="readOnly"
                                @removePicture="removePicture" @getPicture="getPicture" />
        </el-form-item>
      </el-row>
      <el-row type="flex" justify="center" align="middle">
        <el-col :span="16">
          <el-form-item label="发票金额：" prop="amount" 
            :rules="[{required: true, message: '请填写发票金额', trigger: 'blur'}]">
            <el-input v-model="invoiceData.amount" :disabled="readOnly"></el-input>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row type="flex" justify="center" align="middle">
        <el-col :span="16">
          <h6>备注：</h6>
          <el-input v-model="invoiceData.remark" type="textarea" :disabled="readOnly"></el-input>
        </el-col>
      </el-row>
    </el-form>
    <el-row type="flex" justify="center" align="middle" style="margin-top: 20px" :gutter="50" v-if="!readOnly">
      <el-col :span="4">
        <el-button @click="onCancel" class="invoice-btn">取消</el-button>
      </el-col>
      <el-col :span="4">
        <el-button @click="onConfirm" class="invoice-confirm-btn">确认</el-button>
      </el-col>
    </el-row>
  </div> 
</template>

<script>
  import {ImagesUploadSingle} from '@/components/index.js'
  export default {
    name: 'FinancialInvoiceForm',
    props: ['invoiceData'],
    props: {
      invoiceData: {
        type: Object
      },
      readOnly: {
        type: Boolean,
        default: false
      }
    },
    components: {
      ImagesUploadSingle
    },
    computed: {

    },
    methods: {
      getPicture (data) {
        this.invoiceData.image = data;
      },
      removePicture () {
        this.invoiceData.image = {};
      },
      onCancel () {
        this.$emit('onCancel');
      },
      onConfirm () {
        this.$refs.form.validate((valid) => {
          if (valid) {
            this.$emit('onConfirm', this.invoiceData);
          } else {
            this.$message.error('请完善表单信息！');
            return false;
          }
        });
      },
      validateField (name) {
        this.$refs.form.validateField(name);
      },
      validateImage (rule, value, callback) {
        console.log(value);
        if (value.id != null) {
          callback();
        } else {
          callback(new Error('请上传付款凭证'));
        }
      }
    },
    data () {
      return {

      }
    },
    watch: {
      'invoiceData.image': function (nval, oval) {
        console.log(nval);
        this.validateField('image');
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
    border-left: 2px solid #ffd500;
    padding-left: 10px;
  }

  .invoice-btn {
    width: 100px;
    border-radius: 5px;
  }
  .invoice-confirm-btn {
    width: 100px;
    border-radius: 5px;
    color: #606266;
    background-color: #ffd500;
  }
</style>