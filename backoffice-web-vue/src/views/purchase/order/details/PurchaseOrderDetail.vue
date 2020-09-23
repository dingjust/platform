<template>
  <div class="animated fadeIn">
    <el-card>
      <el-row type="flex" justify="space-between"> 
        <el-col :span="6">
          <div class="purchase-list-title">
            <h6>采购单详情</h6>
          </div>
        </el-col>
        <el-col :span="6">
          <h6>状态/标签：{{getEnum('PurchaseOrderState', orderDetail.state)}}</h6>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <div class="basic-row">
        <purchase-order-basic-info :formData="orderDetail.workOrder" :order="orderDetail" :readOnly="true"/>
        <el-divider></el-divider>
        <el-row type="flex" justify="start">
          <h6>采购信息</h6>
        </el-row>
        <el-row type="flex" justify="start">
          <h6>供应商：{{cooperator}}</h6>
        </el-row>
        <purchase-material-table :order="orderDetail" :readOnly="true"/>
        <purchase-order-detail-tabs :order="orderDetail" />
      </div>
    </el-card>
  </div>
</template>

<script>
import PurchaseOrderBasicInfo from '../components/PurchaseOrderBasicInfo'
import PurchaseMaterialTable from '../components/PurchaseMaterialTable'
import PurchaseOrderDetailTabs from './PurchaseOrderDetailTabs'

export default {
  name: 'PurchaseOrderDetail',
  props: ['orderDetail'],
  components: {
    PurchaseOrderBasicInfo,
    PurchaseMaterialTable,
    PurchaseOrderDetailTabs
  },
  computed: {
    cooperator: function () {
      if (!this.orderDetail.cooperator && this.orderDetail.cooperatorName) {
        return this.orderDetail.cooperatorName;
      }
      if (this.orderDetail.cooperator) {
        return this.orderDetail.cooperator.type === 'ONLINE' ? this.orderDetail.cooperator.partner.name : this.orderDetail.cooperator.name;
      }
    }
  }  
}
</script>

<style scoped>
  .purchase-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .basic-row {
    margin: 0px 0px 10px 20px;
  }
</style>