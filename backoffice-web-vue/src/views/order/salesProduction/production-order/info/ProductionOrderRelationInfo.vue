<template>
  <div class="po-relation-box">
    <el-tabs type="border-card" @tab-click="handleClick" :lazy="true">
      <el-tab-pane label="外发订单">
        <production-order-outbound-list v-if="showOutbound&&isMySelf" :page="page" :pageType="pageType" />
      </el-tab-pane>
      <el-tab-pane label="收发货">
        <shipping-tasks-detail :lazy="true" v-if="receiveDispatchTaskId" :id="receiveDispatchTaskId" shadow="hover"
          :showOrderInfo="false" />
      </el-tab-pane>
      <el-tab-pane label="对账单" :lazy="true">
        <reconciliation-tasks-detail v-if="reconciliationTaskId" :id="reconciliationTaskId" shadow="hover"
          :showOrderInfo="false" />
      </el-tab-pane>
      <el-tab-pane label="采购订单" :lazy="true">
        <purchase-order-basic-table :data="[]" v-if="isMySelf" />
      </el-tab-pane>
      <!-- <el-tab-pane label="财务" :lazy="true" v-if="isMySelf">
        <el-row v-if="isBrand()">
          <purchase-order-info-payment-finance :slotData="slotData" v-if="isBrand() && slotData.payPlan!= null" />
        </el-row>
        <el-row v-if="isFactory()">
          <purchase-order-info-receipt-finance :slotData="slotData" v-if="isFactory() && slotData.payPlan!= null" />
        </el-row>
      </el-tab-pane>
      <el-tab-pane label="利润核算" :lazy="true" v-if="isMySelf">
      </el-tab-pane> -->
      <el-tab-pane label="操作日志" :lazy="true" v-if="isMySelf">
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script>
  import PurchaseOrderInfoPaymentFinance from '@/views/order/purchase/info/PurchaseOrderInfoPaymentFinance';
  import PurchaseOrderInfoReceiptFinance from '@/views/order/purchase/info/PurchaseOrderInfoReceiptFinance';
  import PurchaseOrderBasicTable from '../../components/context-order-tab/PurchaseOrderBasicTable';
  import ProductionOrderOutboundList from '../list/ProductionOrderOutboundList'

  import {
    ShippingTasksDetail,
    ReconciliationTasksDetail
  } from '../../../../shipping-receipt/index';

  export default {
    name: 'ProductionOrderRelationInfo',
    props: ['slotData', 'id'],
    components: {
      PurchaseOrderInfoPaymentFinance,
      PurchaseOrderInfoReceiptFinance,
      PurchaseOrderBasicTable,
      ProductionOrderOutboundList,
      ShippingTasksDetail,
      ReconciliationTasksDetail
    },
    computed: {
      showOutbound: function () {
        if (this.slotData.taskOrderEntries == null) {
          return false;
        }
        return this.slotData.taskOrderEntries[0].type == 'FOUNDRY_PRODUCTION' && this.readOutbound;
      },
      //发货任务id
      receiveDispatchTaskId: function () {
        if (this.slotData.taskOrderEntries && this.slotData.taskOrderEntries[0] != null && this.slotData
          .taskOrderEntries[0].receiveDispatchTask !=
          null) {
          return this.slotData.taskOrderEntries[0].receiveDispatchTask.id;
        } else {
          return null;
        }
      },
      //对账任务id
      reconciliationTaskId: function () {
        if (this.slotData.taskOrderEntries && this.slotData.taskOrderEntries[0] != null && this.slotData
          .taskOrderEntries[0].reconciliationTask !=
          null) {
          return this.slotData.taskOrderEntries[0].reconciliationTask.id;
        } else {
          return null;
        }
      },
      isMySelf: function () {
        if (!this.slotData.taskOrderEntries) {
          return false;
        }
        return this.slotData.taskOrderEntries[0].belongTo.uid == this.$store.getters.currentUser.companyCode;
      },
    },
    methods: {
      handleClick(tab, event) {
        if (tab.label === '外发订单') {
          this.getOutboundOrder();
        }
      },
      async getOutboundOrder() {
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
          return;
        }
        if (result.content.length <= 0) {
          this.readOutbound = false;
          return;
        }
        let row = {
          id: result.content[0].id,
          code: result.content[0].code,
          productionLeader: this.slotData.productionLeader,
          merchandiser: result.content[0].merchandiser,
          state: result.content[0].state
        }
        if (result.content[0].state != 'TO_BE_ACCEPTED') {
          this.getOutboundproduction();
          return;
        }
        this.page.content = [row];
        this.pageType = 'OUTBOUND_ORDER';
        this.readOutbound = true;
      },
      async getOutboundproduction() {
        let id = parseInt(this.id);
        const url = this.apis().getoutboundProductionList();
        const result = await this.$http.post(url, {
          taskOrderIds: [id]
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
        this.page = result;
        this.pageType = 'OUTBOUND_PRODUCTION_ORDER';
        this.readOutbound = true;
      }
    },
    data() {
      return {
        pageType: '',
        readOutbound: false,
        page: {
          number: 0,
          size: 10,
          totalPages: 1,
          totalElements: 0,
          content: []
        },
      }
    },
    watch: {},
    created() {
      this.getOutboundOrder();
    }
  }

</script>

<style scoped>
  .po-relation-box {
    margin-top: 30px;
  }

</style>
