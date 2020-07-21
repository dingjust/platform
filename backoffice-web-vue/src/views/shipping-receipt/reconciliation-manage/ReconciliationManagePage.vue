<template>
  <div>
    <reconciliation-manage-toolbar :queryFormData="queryFormData" :canCreate="canCreate" @onCreate="onCreate"
      @onAdvancedSearch="onAdvancedSearch" />
    <el-row type="flex" justify="end">
      <el-col :span="3">
        <el-button type="text" class="list-btn" @click="orderListVisible = !orderListVisible">对账单</el-button>
      </el-col>
    </el-row>
    <el-tabs v-model="activeName" @tab-click="handleClick">
      <template v-for="(map,status) in statusMap">
        <el-tab-pane :label="tabName(map)" :name="status" :key="status">
          <shipping-dynamic-table :page="page" :columns="map.columns" @onAdvancedSearch="onAdvancedSearch"
            @onSelect="onSelect" />
        </el-tab-pane>
      </template>
    </el-tabs>
    <el-dialog :visible.sync="orderListVisible" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <reconciliation-orders-page v-if="orderListVisible" :mode="mode" />
    </el-dialog>
  </div>
</template>

<script>
  import ReconciliationManageToolbar from './toolbar/ReconciliationManageToolbar'
  import ReconciliationOrdersPage from '../reconciliation-order/ReconciliationOrdersPage'
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
      ShippingDynamicTable
    },
    computed: {
      canCreate: function () {
        if (this.mode == 'import') {
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
              taskId: this.id,
              productionTaskOrder: this.selectData[0].productionTaskOrder,
              // receiveDispatchTaskId: this.formData.receiveDispatchTask.id
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
          this.stateCount = {};
          this.$message.error(result['errors'][0].message);
          return;
        }
        if (result.code === 0) {
          this.stateCount = {};
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
          this.stateCount = {};
          this.$message.error(result['errors'][0].message);
          return;
        }
        if (result.code === 0) {
          this.stateCount = {};
          this.$message.error(result.msg);
          return;
        }
        this.$set(this.stateCount, 'reconciliation', result.data);
      },
      tabName(map) {
        let tabName = this.getEnum('ShippingSheetState', map.status);

        switch (map.url) {
          //发货单
          case this.apis().shippingOrderList():
            if (!this.stateCount.shipping.hasOwnProperty(map.status)) {
              break;
            }
            tabName = this.getEnum('ShippingSheetState', map.status) + '(' + this.stateCount.shipping[map.status] +
              ')';
            break;
            //对账单
          case this.apis().reconciliationList():
            if (!this.stateCount.reconciliation.hasOwnProperty(map.status)) {
              break;
            }
            tabName = this.getEnum('ReconciliationOrderState', map.status) + '(' + this.stateCount.reconciliation[map.status] +
              ')';
            break;
        }
        return tabName;
      },
    },
    data() {
      return {
        activeName: 'PENDING_RECONCILED',
        orderListVisible: false,
        stateCount: {
          shipping: {},
          reconciliation: {}
        },
        selectData: []
      }
    },
    created() {
      this.shippingOrderStateCount();
      this.reconciliationStateCount();
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

</style>
