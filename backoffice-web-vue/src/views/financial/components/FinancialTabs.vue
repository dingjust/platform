<template>
  <div>
    <el-tabs type="border-card">
      <el-tab-pane label="收付款">
        <financial-invoice-info v-if="belongTo == 'PAYABLE_PAGE'" :formData="formData" @callback="callback" />
        <financial-reconciliation-table :belongTo="belongTo" :formData="formData" />
        <financial-record-list :belongTo="belongTo" :content="formData.requestList" :outboundOrder="outboundOrder"
          @onConfirmReceipt="onConfirmReceipt" />
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script>
  import FinancialInvoiceInfo from './invoice/FinancialInvoiceInfo'
  import FinancialReconciliationTable from './FinancialReconciliationTable'
  import FinancialRecordList from './FinancialRecordList'
  export default {
    name: 'FinancialTabs',
    props: ['formData', 'belongTo', 'outboundOrder'],
    components: {
      FinancialInvoiceInfo,
      FinancialReconciliationTable,
      FinancialRecordList
    },
    computed: {

    },
    methods: {
      async onConfirmReceipt(row) {
        const url = this.apis().paymentRequestPayConfirm(row.id);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        this.$message.success('确认收款成功！');
        this.$emit('callback');
      },
      callback() {
        this.$emit('callback');
      }
    },
    data() {
      return {

      }
    },
    created() {

    }
  }

</script>

<style scoped>
  .over-tabs {
    position: absolute;
    z-index: 100;
    right: 30px;
    margin-top: 2px;
  }

</style>
