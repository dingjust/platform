<template>
  <div>
    <reconciliation-manage-toolbar :queryFormData="queryFormData" @onAdvancedSearch="onAdvancedSearch" />
    <el-row type="flex" justify="end" align="middle" :gutter="10">
      <el-col :span="2"><span>单据明细：</span></el-col>
      <el-col :span="2">
        <el-button class="list-btn" @click="orderListVisible = !orderListVisible" size="mini">对账单
        </el-button>
      </el-col>
      <el-col :span="3">
        <el-button v-if="mode=='import'" class="list-btn" @click="importTaskVisible = !importTaskVisible" size="mini">
          对账任务
        </el-button>
        <el-button v-if="mode=='export'" class="list-btn" @click="exportTaskVisible = !exportTaskVisible" size="mini">
          对账任务
        </el-button>
      </el-col>
      <el-col :span="3" v-if="canCreate">
        <el-button class="create-btn" @click="onCreate">创建对账单</el-button>
      </el-col>
    </el-row>
    <el-tabs v-model="activeName" @tab-click="handleClick">
      <template v-for="(map,status) in statusMap">
        <el-tab-pane :label="mode=='import'?importTabName(map):exportTabName(map)" :name="status" :key="status">
          <shipping-dynamic-table :page="page" :columns="map.columns" @onAdvancedSearch="onAdvancedSearch"
            @onSelect="onSelect" />
        </el-tab-pane>
      </template>
    </el-tabs>
    <el-dialog :visible.sync="orderListVisible" width="90%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <reconciliation-orders-page v-if="orderListVisible" :mode="mode" />
    </el-dialog>
    <el-dialog :visible.sync="importTaskVisible" width="90%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <import-reconciliation-tasks-page v-if="importTaskVisible" />
    </el-dialog>
    <el-dialog :visible.sync="exportTaskVisible" width="90%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <export-reconciliation-tasks-page v-if="exportTaskVisible" />
    </el-dialog>
  </div>
</template>

<script>
  import ReconciliationManageToolbar from './toolbar/ReconciliationManageToolbar'
  import ReconciliationOrdersPage from '../reconciliation-order/ReconciliationOrdersPage'
  import ImportReconciliationTasksPage from '../page/import/ImportReconciliationTasksPage'
  import ExportReconciliationTasksPage from '../page/export/ExportReconciliationTasksPage'

  import {
    ShippingDynamicTable
  } from '../components/index'
  export default {
    name: 'ReconciliationManagePage',
    props: {
      mode: {
        type: String,
        default: 'import'
      },
      page: {
        type: Object,
        required: true
      },
      queryFormData: {
        type: Object,
        required: true
      },
      statusMap: {
        type: Object,
        required: true
      }
    },
    components: {
      ReconciliationManageToolbar,
      ReconciliationOrdersPage,
      ShippingDynamicTable,
      ImportReconciliationTasksPage,
      ExportReconciliationTasksPage
    },
    computed: {
      canCreate: function () {
        //收货方发起对账
        if (this.mode == 'export') {
          return true;
        } else {
          return false;
        }
      }
    },
    methods: {
      handleClick(tab, event) {
        this.$emit('handleClick', {
          status: this.statusMap[tab.name].status,
          searchUrl: this.statusMap[tab.name].url
        });
      },
      async onAdvancedSearch(page, size) {
        this.$emit('onAdvancedSearch');
      },
      onSelect(val) {
        this.$set(this, 'selectData', val);
        this.$emit('onSelect', val);
      },
      // 创建对账单
      onCreate() {
        if (this.selectData.length > 0) {
          this.$router.push({
            name: '创建对账单',
            params: {
              // taskId: this.id,
              // productionTaskOrder: this.selectData[0].productionTaskOrder,
              // receiveDispatchTaskId: this.formData.receiveDispatchTask.id
              productionTaskOrderId: this.selectData[0].productionTaskOrder.id,
              selectShipOrder: this.selectData
            }
          });
        } else {
          this.$router.push('/reconciliation/create/orders');
        }
      },
      // 查询发货单状态统计
      async shippingOrderStateCount() {
        let query = Object.assign({}, this.queryFormData);
        query.states = '';
        if (this.mode == 'import') {
          query['shipParty'] = this.$store.getters.currentUser.companyCode;
        } else {
          query['receiveParty'] = this.$store.getters.currentUser.companyCode;
        }

        const url = this.apis().shippingOrderStateCount();
        const result = await this.$http.post(url, query);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        this.$set(this.stateCount, 'shipping', result.data);
      },
      // 查询对账单状态统计
      async reconciliationStateCount() {
        let query = Object.assign({}, this.queryFormData);
        query.states = '';
        if (this.mode == 'import') {
          query['shipParty'] = this.$store.getters.currentUser.companyCode;
        } else {
          query['receiveParty'] = this.$store.getters.currentUser.companyCode;
        }

        const url = this.apis().reconciliationSheetStateCount();
        const result = await this.$http.post(url, query);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        this.$set(this.stateCount, 'reconciliation', result.data);
      },
      // 查询对账单（收货方审核）状态统计
      async reconciliationSheetAuditStateCount() {
        let query = Object.assign({}, this.queryFormData);
        query.states = 'PENDING_CONFIRM';
        if (this.mode == 'import') {
          query['shipParty'] = this.$store.getters.currentUser.companyCode;
        } else {
          query['receiveParty'] = this.$store.getters.currentUser.companyCode;
        }

        const url = this.apis().reconciliationSheetAuditStateCount();
        const result = await this.$http.post(url, query);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        this.$set(this.stateCount, 'reconciliationAudit', result.data);
      },
      //发货方
      importTabName(map) {
        let tabName = '';

        switch (map.status) {
          case 'PENDING_RECONCILED': //发货单
            if (!this.stateCount.shipping.hasOwnProperty(map.status)) {
              tabName = this.getEnum('ShippingSheetState', map.status);
              break;
            }
            tabName = this.getEnum('ShippingSheetState', map.status) + '(' + this.stateCount.shipping[map.status] +
              ')';
            break;
          case 'PENDING_CONFIRM': //对账单
            if (!this.stateCount.reconciliation.hasOwnProperty(map.status)) {
              tabName = this.getEnum('ReconciliationOrderState', map.status);
              break;
            }
            tabName = this.getEnum('ReconciliationOrderState', map.status) + '(' + this.stateCount.reconciliation[map
                .status] +
              ')';
            break;
          case 'PENDING_APPROVAL': //审核单-审核中
            if (!this.stateCount.reconciliationAudit.hasOwnProperty('AUDITING')) {
              tabName = this.getEnum('ReconciliationOrderState', map.status);
              break;
            }
            tabName = this.getEnum('ReconciliationOrderState', map.status) + '(' + this.stateCount.reconciliationAudit[
                'AUDITING'] +
              ')';
            break;
          case 'REJECTED': //审核单-拒绝
            if (!this.stateCount.reconciliationAudit.hasOwnProperty('AUDITED_FAILED')) {
              tabName = this.getEnum('ReconciliationOrderState', map.status);
              break;
            }
            tabName = this.getEnum('ReconciliationOrderState', map.status) + '(' + this.stateCount.reconciliationAudit[
                'AUDITED_FAILED'] +
              ')';
            break;
          case 'CONFIRMED': //对账单-完成
            if (!this.stateCount.reconciliation.hasOwnProperty(map.status)) {
              tabName = this.getEnum('ReconciliationOrderState', map.status);
              break;
            }
            tabName = this.getEnum('ReconciliationOrderState', map.status) + '(' + this.stateCount.reconciliation[
                map.status] +
              ')';
            break;
        }

        return tabName;
      },
      //收货方（审核状态处理）
      exportTabName(map) {
        let tabName = this.getEnum('ShippingSheetState', map.status);
        switch (map.url) {
          //发货单
          case this.apis().shippingOrderList():
            if (this.stateCount.shipping == null || !this.stateCount.shipping.hasOwnProperty(map.status)) {
              break;
            }
            tabName = this.getEnum('ShippingSheetState', map.status) + '(' + this.stateCount.shipping[map.status] +
              ')';
            break;
            //对账单
          case this.apis().reconciliationList():
            if (this.stateCount.reconciliation == null || !this.stateCount.reconciliation.hasOwnProperty(map.status)) {
              tabName = this.getEnum('ReconciliationOrderState', map.status);
              break;
            }
            tabName = this.getEnum('ReconciliationOrderState', map.status) + '(' + this.stateCount.reconciliation[map
                .status] +
              ')';
            break;
        }
        return tabName;
      }
    },
    data() {
      return {
        activeName: 'PENDING_RECONCILED',
        orderListVisible: false,
        importTaskVisible: false,
        exportTaskVisible: false,
        stateCount: {
          shipping: {},
          reconciliation: {},
          reconciliationAudit: {}
        },
        selectData: []
      }
    },
    created() {
      this.shippingOrderStateCount();
      this.reconciliationStateCount();

      if (this.mode == 'import') {
        this.reconciliationSheetAuditStateCount();
      }
    },
  }

</script>

<style scoped>
  .title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .list-btn {
    font-size: 16px;
    color: #606266;
  }

  .create-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
  }

</style>
