<template>
  <el-tabs type="border-card">
    <el-tab-pane label="收付款"> 
      <!-- <financial-invoice-info :formData="formData" @callback="callback" />
      <financial-reconciliation-table belongTo="PAYABLE_PAGE" :formData="formData"/>
      <financial-record-list belongTo="PAYABLE_PAGE" :content="formData.requestList" 
                              @onConfirmReceipt="onConfirmReceipt"/> -->
    </el-tab-pane>
  </el-tabs>
</template>

<script>
  import FinancialInvoiceInfo from './invoice/FinancialInvoiceInfo'
  import FinancialReconciliationTable from './FinancialReconciliationTable'
  import FinancialRecordList from './FinancialRecordList'
  export default {
    name: 'FinancialTabs',
    props: {

    },
    components: {
      FinancialInvoiceInfo,
      FinancialReconciliationTable,
      FinancialRecordList
    },
    computed: {

    },
    methods: {

    },
    data () {
      return {

      }
    },
    created () {

    }
  }
</script>

<style scoped>

</style>