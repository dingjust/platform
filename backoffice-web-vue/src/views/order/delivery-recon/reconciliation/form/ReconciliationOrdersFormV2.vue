<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <div class="reconcilication-order-title">
          <h6>创建对账单</h6>
        </div>
      </el-row>
      <div class="pt-2"></div>
      <el-form :model="formData" :inline="true" class="form-container">
        <reconciliation-orders-form-v2-header :formData="formData" />
        <reconciliation-info-table :formData="formData" />
        <reconciliation-approvers-part :formData="formData"/>
        <reconciliation-upload-part :formData="formData"/>
      </el-form>
    </el-card>
  </div>
</template>

<script>
import ReconciliationOrdersFormV2Header from './ReconciliationOrdersFormV2Header'
import ReconciliationInfoTable from './ReconciliationInfoTable'
import ReconciliationApproversPart from './ReconciliationApproversPart'
import ReconciliationUploadPart from './ReconciliationUploadPart'

export default {
  name: 'ReconciliationOrdersFormV2',
  components: {
    ReconciliationOrdersFormV2Header,
    ReconciliationInfoTable,
    ReconciliationApproversPart,
    ReconciliationUploadPart
  },
  data () {
    return {
      formData: {
        fastShippingSheets: [
          {
            id: '',
            code: ''
          }
        ],
        entries: [
          // {
          //   product: {
          //     id: '',
          //     name: '',
          //     thumbnail: '',
          //     skuID: ''
          //   },
          //   waveBand: '',
          //   orderItemNo: '',
          //   customizedMode: '',
          //   deliveryDate: '',
          //   contractDate: '',
          //   orderQuantity: '',
          //   cutQuantity: '',
          //   packageQuantity: '',
          //   storageQuantity: '',
          //   returnQuantity: '',
          //   unitContractPrice: '',
          //   loanAmount: '',
          //   expressFee: '',
          //   deductionAmount: '',
          //   settlementAmount: '',
          //   remarks: ''
          // }
        ],
        approvers: [null],
        enclosure: [],
        contract: []
      }
    }
  }
}
</script>

<style scoped>
  .reconcilication-order-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .form-container {
    margin: 0 0 0 20px;
  }
</style>