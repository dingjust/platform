<template>
  <div class="invoice-container">
    <el-row type="flex" justify="space-between" align="middle">      
      <h6>{{readOnly ? '发票详情' : '上传发票'}}</h6>
    </el-row>
    <el-row type="flex" justify="start" align="top">
      <el-col :span="23" :offset="1">
        <images-upload :slotData="invoiceList" :disabled="true" :custom="true" @onUpload="onUpload"
          @callback="showInvoice" />
      </el-col>
    </el-row>
    <el-dialog :visible.sync="invoiceFormVisible" class="purchase-dialog" width="60%" append-to-body
      :close-on-click-modal="false">
      <financial-invoice-form v-if="invoiceFormVisible" :invoiceData="invoiceData" :readOnly="readOnly"
        @onCancel="onCancel" @onConfirm="onConfirm" />
    </el-dialog>
  </div>
</template>

<script>
  import FinancialInvoiceForm from './FinancialInvoiceForm'
  import {
    ImagesUpload
  } from '@/components/index.js'

  export default {
    name: 'FinancialInvoiceInfo',
    props: ['formData'],
    components: {
      FinancialInvoiceForm,
      ImagesUpload
    },
    computed: {
      invoiceList: function () {
        let invoiceList = []
        if (this.formData.invoiceList != null) {
          this.formData.invoiceList.forEach(item => {
            invoiceList.push(item.image);
          })
        }
        return invoiceList;
      }
    },
    methods: {
      onCancel() {
        this.invoiceFormVisible = false;
      },
      async onConfirm(data) {
        let formData = data;
        formData.bill = {
          id: this.formData.id
        }
        const url = this.apis().appendInvoice();
        const result = await this.$http.post(url, formData);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        this.$emit('callback');

        this.invoiceFormVisible = false;
      },
      onUpload() {
        this.readOnly = false;
        this.invoiceFormVisible = true;
        this.invoiceData = {
          image: {},
          amount: '',
          remark: ''
        }
      },
      showInvoice(data) {
        let index = this.formData.invoiceList.findIndex(item => item.image.id == data.id);
        this.invoiceData = this.formData.invoiceList[index];
        this.readOnly = true;
        this.invoiceFormVisible = true;
      },
    },
    data() {
      return {
        invoiceFormVisible: false,
        invoiceData: '',
        readOnly: false
      }
    },
    created() {

    },
    destroyed() {

    }
  }

</script>

<style scoped>
  .invoice-container {
    margin: 20px 0px 10px 10px;
  }

  .invoice-container>>>.el-upload--picture-card {
    width: 75px;
    height: 75px;
    line-height: 75px;
  }

  .invoice-container>>>.el-upload-list--picture-card .el-upload-list__item {
    width: 75px;
    height: 75px;
  }
</style>
