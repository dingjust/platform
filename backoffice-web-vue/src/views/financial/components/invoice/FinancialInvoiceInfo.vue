<template>
  <div class="invoice-container">
    <el-row type="flex" justify="start" align="middle">
      <h6>上传发票</h6>
    </el-row>
    <el-row type="flex" justify="start" align="top">
      <el-col :span="23" :offset="1">
        <images-upload :slotData="formData.invoice" :disabled="true" :custom="true" @onUpload="onUpload"/>
      </el-col>
    </el-row>
    <el-dialog :visible.sync="invoiceFormVisible" class="purchase-dialog" width="60%" append-to-body :close-on-click-modal="false">
      <financial-invoice-form v-if="invoiceFormVisible" @onCancel="onCancel" @onConfirm="onConfirm"/>
    </el-dialog>
  </div>
</template>

<script>
  import FinancialInvoiceForm from './FinancialInvoiceForm'
  import {ImagesUpload} from '@/components/index.js'

  export default {
    name: 'FinancialInvoiceInfo',
    props: ['formData'],
    components: {
      FinancialInvoiceForm,
      ImagesUpload
    },
    computed: {

    },
    methods: {
      onCancel () {
        this.invoiceFormVisible = false;
      },
      onConfirm (data) {
        this.$emit('uploadInvoice', data);
        this.invoiceFormVisible = false;
      },
      onUpload () {
        this.invoiceFormVisible = true;
      }
    },
    data () {
      return {  
        invoiceFormVisible: false
      }
    },
    created () {

    },
    destroyed () {
      
    }
  }
</script>

<style scoped>
  .invoice-container {
    margin: 20px 0px 10px 10px;
  }

  .invoice-container >>> .el-upload--picture-card {
    width: 75px;
    height: 75px;
    line-height: 75px;
  }

  .invoice-container >>> .el-upload-list--picture-card .el-upload-list__item {
    width: 75px;
    height: 75px;
  }
</style>