<template>
  <div>
    <shipping-receipt-toolbar :queryFormData="queryFormData" :canCreateReceipt="canCreateReceipt"
      @onCreate="onCreateReceiptOrder" @onAdvancedSearch="onAdvancedSearch" />
    <el-row type="flex" justify="end">
      <el-col :span="3">
        <el-button class="list-btn" @click="shippingListVisible = !shippingListVisible">发货单</el-button>
      </el-col>
      <el-col :span="3">
        <el-button class="list-btn" @click="receiptListVisible = !receiptListVisible">收货单</el-button>
      </el-col>
      <el-col :span="3">
        <el-button class="list-btn" @click="returnListVisible = !returnListVisible">退货单</el-button>
      </el-col>
      <el-col :span="3">
        <el-button class="list-btn" @click="reconsiderListVisible = !reconsiderListVisible">复议单</el-button>
      </el-col>
      <el-col :span="3" v-if="mode=='import'">
        <el-button class="list-btn" @click="shipTaskVisible = !shipTaskVisible">发货任务</el-button>
      </el-col>
      <el-col :span="3" v-if="mode=='export'">
        <el-button class="list-btn" @click="receTaskVisible = !receTaskVisible">收货任务</el-button>
      </el-col>
    </el-row>
    <el-tabs v-model="activeName" @tab-click="handleClick">
      <template v-for="(map,status) in statusMap">
        <el-tab-pane :label="tabName(map)" :name="status" :key="status">
          <shipping-dynamic-table :page="page" :columns="map.columns" @onAdvancedSearch="onAdvancedSearch" />
        </el-tab-pane>
      </template>
    </el-tabs>
    <el-dialog :visible.sync="shippingListVisible" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <shipping-orders-page :mode="mode" v-if="shippingListVisible" />
    </el-dialog>
    <el-dialog :visible.sync="receiptListVisible" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <receipt-orders-page :mode="mode" v-if="receiptListVisible" />
    </el-dialog>
    <el-dialog :visible.sync="returnListVisible" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <return-orders-page :mode="mode" v-if="returnListVisible" />
    </el-dialog>
    <el-dialog :visible.sync="reconsiderListVisible" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <reconsider-order-mode-page :mode="mode" v-if="reconsiderListVisible" />
    </el-dialog>
    <el-dialog :visible.sync="shipTaskVisible" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <import-shipping-tasks-page :mode="mode" v-if="shipTaskVisible" />
    </el-dialog>
    <el-dialog :visible.sync="receTaskVisible" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <export-shipping-tasks-page :mode="mode" v-if="receTaskVisible" />
    </el-dialog>
  </div>
</template>

<script>
  import ShippingReceiptToolbar from './toolbar/ShippingReceiptToolbar'
  import ShippingOrdersPage from '../shipping-order/ShippingOrdersPage'
  import ReceiptOrdersPage from '../receipt-order/ReceiptOrdersPage'
  import ReturnOrdersPage from '../return-order/ReturnOrdersPage'
  import ReconsiderOrderModePage from '../reconsider-order/ReconsiderOrderModePage'
  import {
    ShippingDynamicTable
  } from '../components/index'
  import ReceiptOrdersList from '../receipt-order/list/ReceiptOrdersList'
  import ReturnOrdersList from '../return-order/list/ReturnOrdersList'
  import ImportShippingTasksPage from '../page/import/ImportShippingTasksPage'
  import ExportShippingTasksPage from '../page/export/ExportShippingTasksPage'
  export default {
    name: 'ShippingReceiptPage',
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
      ShippingReceiptToolbar,
      ShippingOrdersPage,
      ReceiptOrdersPage,
      ReturnOrdersPage,
      ShippingDynamicTable,
      ReceiptOrdersList,
      ReturnOrdersList,
      ReconsiderOrderModePage,
      ImportShippingTasksPage,
      ExportShippingTasksPage
    },
    computed: {
      canCreateReceipt: function () {
        // 判断是否能创建收货单
        return true;
      }
    },
    methods: {
      // getEnumLabel(status) {
      //   if (status == 'PENDING_RECONCILED') {
      //     return '完成'
      //   } else {
      //     return this.getEnum('ShippingSheetState', status);
      //   }
      // },
      handleClick(tab, event) {
        if (this.statusMap[tab.name].status == 'COMPLETED') {
          this.$emit('handleClick', {
            status: ['PENDING_RECONCILED', 'RECONCILED', 'COMPLETED'],
            searchUrl: this.statusMap[tab.name].url
          });
          return;
        }
        this.$emit('handleClick', {
          status: this.statusMap[tab.name].status,
          searchUrl: this.statusMap[tab.name].url
        });
      },
      onSearch(page, size) {
        this.$emit('onSearch');
      },
      onAdvancedSearch(page, size) {
        this.$emit('onAdvancedSearch');
        this.shippingOrderStateCount();
        this.reconsiderOrderStateCount();
      },
      // 创建发货单
      onCreateReceiptOrder() {
        this.$router.push({
          name: '收货单表单',
          params: {
            shippingOrder: {
              colorSizeEntries: this.page.content[0].productionEntry.colorSizeEntries
            }
          }
        });
      },
      tabName(map) {
        let tabName = this.getEnum('ShippingSheetState', map.status);

        switch (map.url) {
          //发货单
          case this.apis().shippingOrderList():
            if (!this.stateCount.shipping.hasOwnProperty(map.status)) {
              break;
            }
            if (map.status == 'COMPLETED') {
              let count = this.parseIntNotNaN(this.stateCount.shipping['COMPLETED']) +
                this.parseIntNotNaN(this.stateCount.shipping['PENDING_RECONCILED']) +
                this.parseIntNotNaN(this.stateCount.shipping['RECONCILED']);
              if (count > 0) {
                tabName = this.getEnum('ShippingSheetState', map.status) + '(' + count + ')';
              }
            } else {
              tabName = this.getEnum('ShippingSheetState', map.status) + '(' + this.stateCount.shipping[map.status] +
                ')';
            }
            break;
            //复议单
          case this.apis().reconsiderOrderList():
            if (!this.stateCount.reconsider.hasOwnProperty(map.status)) {
              break;
            }
            tabName = this.getEnum('ShippingSheetState', map.status) + '(' + this.stateCount.reconsider[map.status] +
              ')';
            break;
            //退货单
          case this.apis().returnOrderList():
            if (!this.stateCount.return.hasOwnProperty(map.status)) {
              break;
            }
            tabName = this.getEnum('ShippingSheetState', map.status) + '(' + this.stateCount.return[map.status] +
              ')';
            break;
        }
        return tabName;
      },
      parseIntNotNaN(count) {
        if (isNaN(parseInt(count))) {
          return 0;
        }
        return parseInt(count);
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
      // 查询复议单状态统计
      async reconsiderOrderStateCount() {
        let query = Object.assign({}, this.queryFormData);
        query.states = '';
        if (this.mode == 'import') {
          query['shipParty'] = this.$store.getters.currentUser.companyCode;
        } else {
          query['receiveParty'] = this.$store.getters.currentUser.companyCode;
        }

        const url = this.apis().reconsiderOrderStateCount();
        const result = await this.$http.post(url, query);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        this.$set(this.stateCount, 'reconsider', result.data);
      },
      // 查询退货单状态统计
      async returnOrderStateCount() {
        let query = Object.assign({}, this.queryFormData);
        query.states = '';
        if (this.mode == 'import') {
          query['shipParty'] = this.$store.getters.currentUser.companyCode;
        } else {
          query['receiveParty'] = this.$store.getters.currentUser.companyCode;
        }

        const url = this.apis().returnSheetStateCount();
        const result = await this.$http.post(url, query);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        this.$set(this.stateCount, 'return', result.data);
      }
    },
    data() {
      return {
        stateCount: {
          shipping: {},
          reconsider: {},
          return: {}
        },
        activeName: 'PENDING_RECEIVED',
        shippingListVisible: false,
        receiptListVisible: false,
        returnListVisible: false,
        reconsiderListVisible: false,
        shipTaskVisible: false,
        receTaskVisible: false
      }
    },
    created() {
      this.shippingOrderStateCount();
      this.reconsiderOrderStateCount();
      this.returnOrderStateCount();
    }
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
