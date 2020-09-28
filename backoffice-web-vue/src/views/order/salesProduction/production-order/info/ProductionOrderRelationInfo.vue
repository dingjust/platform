<template>
  <div class="po-relation-box">
    <div class="over-tabs">
      <el-row type="flex">
        <el-button v-if="activeName === '采购订单'" class="material-btn" @click="onCreatePurchase">创建单据</el-button>
      </el-row>
    </div>
    <el-tabs type="border-card" v-model="activeName" @tab-click="handleClick" :lazy="true">
      <el-tab-pane label="外发订单" name="外发订单" v-if="showOutbound&&isMySelf">
        <production-order-outbound-list  :page="page" :pageType="pageType" />
      </el-tab-pane>
      <el-tab-pane label="收发货" name="收发货">
        <shipping-tasks-detail :lazy="true" v-if="receiveDispatchTaskId" :id="receiveDispatchTaskId" shadow="hover"
          :showOrderInfo="false" />
      </el-tab-pane>
      <el-tab-pane label="对账单" name="对账单" :lazy="true">
        <reconciliation-tasks-detail v-if="reconciliationTaskId" :id="reconciliationTaskId" shadow="hover"
          :showOrderInfo="false" />
      </el-tab-pane>
      <el-tab-pane label="采购订单" name="采购订单" :lazy="true">
        <purchase-order-basic-table v-if="isMySelf" :purchaseList="purchaseList"/>
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
        } else if (tab.label === '采购订单') {
          this.getPurchaseRequirement();
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
      },
      async getPurchaseRequirement () {
        const id = this.id;

        const url = this.apis().getPurchaseRequirementByProductionId(id);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        if (result.code === 1) {
          this.purchaseList = result.data;
        } else if (result.code === 0) {
          this.$message.error(result.msg);
        }
      },
      onCreatePurchase () {
        let formData = {
          code: '',
          includeTax: false,
          taxPoint: 0.03,
          qualityRequirement: '',
          productionTask: {
            id: this.slotData.taskOrderEntries[0].id,
            code: this.slotData.taskOrderEntries[0].code,
            product: {
              skuID: this.slotData.taskOrderEntries[0].product.skuID
            }
          },
          workOrders: [],
          auditNeeded: true,
          merchandiser: {},
          approvers: [null],
          shippingAddress: {},
        }
        this.$router.push({
          name: '创建采购需求',
          params: {
            formData: formData
          }
        })
      }
    },
    data() {
      return {
        activeName: '收发货',
        purchaseList: [],
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
    mounted () {
      if (this.showOutbound && this.isMySelf) {
        this.activeName = '外发订单';
      }
    },
    created() {
      this.getOutboundOrder();
    }
  }

</script>

<style scoped>
  .po-relation-box {
    margin-top: 30px;
  }

  .over-tabs {
    position: absolute;
    z-index: 100;
    right: 5px;
    margin-top: 2px;
  }

  .material-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    width: 90px;
    height: 35px;
  }
</style>
