<template>
  <div class="po-relation-box">
    <el-tabs type="border-card" @tab-click="handleClick" :lazy="true">
      <el-tab-pane label="外发订单">
        <production-order-outbound-list/>
      </el-tab-pane>
      <el-tab-pane label="采购订单">
        <purchase-order-basic-table :data="[]" />
      </el-tab-pane>
      <el-tab-pane label="财务">
        <el-row v-if="isBrand()">
          <purchase-order-info-payment-finance :slotData="slotData" v-if="isBrand() && slotData.payPlan!= null" />
        </el-row>
        <el-row v-if="isFactory()">
          <purchase-order-info-receipt-finance :slotData="slotData" v-if="isFactory() && slotData.payPlan!= null" />
        </el-row>
      </el-tab-pane>
      <el-tab-pane label="利润核算">
      </el-tab-pane>
      <el-tab-pane label="操作日志">
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script>
  import PurchaseOrderInfoPaymentFinance from '@/views/order/purchase/info/PurchaseOrderInfoPaymentFinance';
  import PurchaseOrderInfoReceiptFinance from '@/views/order/purchase/info/PurchaseOrderInfoReceiptFinance';
  import PurchaseOrderBasicTable from '../../components/context-order-tab/PurchaseOrderBasicTable';
  import ProductionOrderOutboundList from '../list/ProductionOrderOutboundList'

  export default {
    name: 'ProductionOrderRelationInfo',
    props: ['slotData', 'id'],
    components: {
      PurchaseOrderInfoPaymentFinance,
      PurchaseOrderInfoReceiptFinance,
      PurchaseOrderBasicTable,
      ProductionOrderOutboundList
    },
    methods: {
      handleClick (tab, event) {
        if (tab.label) {
          this.getOutboundOrder();
        }
      },
      async getOutboundOrder () {
        const url = this.apis().getoutboundOrdersList();
        const result = await this.$http.post(url, {
          originOrder: this.id
        }, {
          page: 0,
          size: 10
        });
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        if (result.code == 0) {
          this.$message.error(result.msg);
        }
      }
    },
    data () {
      return {
      }
    },
    created () {
      this.getOutboundOrder();
    }
  }

</script>

<style scoped>
  .po-relation-box {
    margin-top: 30px;
  }

</style>
