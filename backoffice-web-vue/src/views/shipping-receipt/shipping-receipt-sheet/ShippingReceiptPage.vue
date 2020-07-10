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
    </el-row>
    <el-tabs v-model="activeName" @tab-click="handleClick">
      <template v-for="(map,status) in statusMap">
        <el-tab-pane :label="map.status" :name="status" :key="status">
          <shipping-dynamic-table :page="page" :canCreateReceipt="canCreateReceipt" :columns="map.columns"
            @onAdvancedSearch="onAdvancedSearch" />
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
  </div>
</template>

<script>
  import ShippingReceiptToolbar from './toolbar/ShippingReceiptToolbar'
  import ShippingOrdersPage from '../shipping-order/ShippingOrdersPage'
  import ReceiptOrdersPage from '../receipt-order/ReceiptOrdersPage'
  import ReturnOrdersPage from '../return-order/ReturnOrdersPage'
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
      }
    },
    components: {
      ShippingReceiptToolbar,
      ShippingOrdersPage,
      ReceiptOrdersPage,
      ReturnOrdersPage,
      ShippingDynamicTable,
      ReceiptOrdersList,
      ReturnOrdersList
    },
    computed: {
      canCreateReceipt: function () {
        // 判断是否能创建收货单
        return true;
      }
    },
    methods: {
      handleClick(tab, event) {
        this.$emit('handleClick', {
          status: this.statusMap[tab.name].status,
          code: this.statusMap[tab.name].code,
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
        activeName: 'STATUS_1',
        shippingListVisible: false,
        receiptListVisible: false,
        returnListVisible: false,
        statusMap: {
          STATUS_1: {
            status: '待收货',
            code: 'PENDING_RECEIVED',
            columns: [{
              key: '发货单号'
            }, {
              key: '产品名称'
            }, {
              key: '关联订单'
            }, {
              key: '发货人'
            }, {
              key: '单价'
            }, {
              key: '发货数量'
            }, {
              key: '发货总额'
            }, {
              key: '发货日期'
            }, {
              key: '发货操作'
            }],
            url: this.apis().shippingOrderList()
          },
          STATUS_2: {
            status: '待退货',
            code: 'PENDING_RETURNED',
            columns: [{
              key: '发货单号'
            }, {
              key: '产品名称'
            }, {
              key: '关联订单'
            }, {
              key: '关联收货单'
            }, {
              key: '收货单创建人'
            }, {
              key: '发货数'
            }, {
              key: '收货数'
            }, {
              key: '发货操作'
            }],
            url: this.apis().shippingOrderList()
          },
          STATUS_3: {
            status: '退货待收',
            code: 'RETURN_TO_BE_RECEIVED',
            columns: [{
              key: '退货单'
            }, {
              key: '产品名称'
            }, {
              key: '关联订单'
            }, {
              key: '关联发货单',
              props: {
                code: 'logisticsSheet.code',
                id: 'logisticsSheet.id'
              }
            }, {
              key: '退货单创建人'
            }, {
              key: '单价'
            }, {
              key: '退货数'
            }, {
              key: '退货操作'
            }],
            url: this.apis().returnOrderList()
          },
          STATUS_4: {
            status: '退货已收',
            code: 'RETURN_RECEIVED',
            columns: [{
              key: '退货单'
            }, {
              key: '产品名称'
            }, {
              key: '关联订单'
            }, {
              key: '关联发货单',
              props: {
                code: 'logisticsSheet.code',
                id: 'logisticsSheet.id'
              }
            }, {
              key: '退货单创建人'
            }, {
              key: '单价'
            }, {
              key: '退货数'
            }, {
              key: '退货操作'
            }],
            url: this.apis().returnOrderList()
          },
          STATUS_5: {
            status: '已完成',
            code: 'COMPLETED',
            columns: [{
              key: '发货单号'
            }, {
              key: '产品名称'
            }, {
              key: '单价'
            }, {
              key: '发货数量'
            }, {
              key: '收货单'
            }, {
              key: '收货数',
              props: {
                prop: 'receiptSheets'
              }
            }, {
              key: '差异数'
            }, {
              key: '发货操作'
            }],
            url: this.apis().shippingOrderList()
          }
        }
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
