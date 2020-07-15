<template>
  <div>
    <shipping-receipt-toolbar :queryFormData="queryFormData" :canCreateReceipt="canCreateReceipt"
      @onCreate="onCreateReceiptOrder" @onAdvancedSearch="onAdvancedSearch" />
    <el-row type="flex" justify="end">
      <el-col :span="3">
        <el-button type="text" class="list-btn" @click="shippingListVisible = !shippingListVisible">发货单</el-button>
      </el-col>
      <el-col :span="3">
        <el-button type="text" class="list-btn" @click="receiptListVisible = !receiptListVisible">收货单</el-button>
      </el-col>
      <el-col :span="3">
        <el-button type="text" class="list-btn" @click="returnListVisible = !returnListVisible">退货单</el-button>
      </el-col>
      <el-col :span="3">
        <el-button type="text" class="list-btn" @click="reconsiderListVisible = !reconsiderListVisible">复议单</el-button>
      </el-col>
    </el-row>
    <el-tabs v-model="activeName" @tab-click="handleClick">
      <template v-for="(map,status) in statusMap">
        <el-tab-pane :label="getEnum('ShippingSheetState', map.status)" :name="status" :key="status">
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
      ReconsiderOrderModePage
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
      }
    },
    data() {
      return {
        activeName: 'PENDING_RECEIVED',
        shippingListVisible: false,
        receiptListVisible: false,
        returnListVisible: false,
        reconsiderListVisible: false,
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

</style>
