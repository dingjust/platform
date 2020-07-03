<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="4">
          <div class="title">
            <h6>收发货列表</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
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
              @onAdvancedSearch="onAdvancedSearch"/>
          </el-tab-pane>
        </template>
      </el-tabs>
    </el-card>
    <el-dialog :visible.sync="shippingListVisible" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <shipping-orders-page v-if="shippingListVisible" />
    </el-dialog>
    <el-dialog :visible.sync="receiptListVisible" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <receipt-orders-page v-if="receiptListVisible" />
    </el-dialog>
    <el-dialog :visible.sync="returnListVisible" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <return-orders-page v-if="returnListVisible" />
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
        this.queryFormData.status = this.statusMap[tab.name].status;
        this.searchUrl = this.statusMap[tab.name].url;
        this.onAdvancedSearch(0, 10);
      },
      async onAdvancedSearch(page, size) {
        const url = this.searchUrl;
        const query = this.queryFormData;
        const result = await this.$http.post(url, query, {
          page: page,
          size: size
        });
        this.page = result;
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
        page: {
          number: 0, // 当前页，从0开始
          size: 10, // 每页显示条数
          totalPages: 1, // 总页数
          totalElements: 0, // 总数目数
          content: [] // 当前页数据
        },
        activeName: 'STATUS_1',
        searchUrl: this.apis().shippingOrderList(),
        shippingListVisible: false,
        receiptListVisible: false,
        returnListVisible: false,
        queryFormData: {
          keyword: '',
          productionLeaderName: '',
          operatorName: '',
          creationtimeStart: '',
          creationtimeEnd: '',
          status: '待收货'
        },
        statusMap: {
          STATUS_1: {
            status: '待收货',
            columns: ['发货单号', '产品名称', '关联订单', '发货人', '单价', '发货数量', '发货总额', '发货日期', '发货操作'],
            url: this.apis().shippingOrderList()
          },
          STATUS_2: {
            status: '待退货',
            columns: ['发货单号', '产品名称', '关联订单', '关联收货单', '收货单创建人', '发货数', '收货数', '发货操作'],
            url: this.apis().shippingOrderList()
          },
          STATUS_3: {
            status: '退货待收',
            columns: ['退货单', '产品名称', '关联订单', '关联发货单', '退货单创建人', '单价', '退货数', '退货操作'],
            url: this.apis().shippingOrderList()
          },
          STATUS_4: {
            status: '退货已收',
            columns: ['退货单', '产品名称', '关联订单', '关联发货单', '退货单创建人', '单价', '退货数', '退货操作'],
            url: this.apis().shippingOrderList()
          },
          STATUS_5: {
            status: '已完成',
            columns: ['发货单号', '产品名称', '单价', '发货数量', '收货单', '收货数', '差异数', '发货操作'],
            url: this.apis().shippingOrderList()
          }
        }
      }
    },
    created() {
      this.onAdvancedSearch(this.page.number, this.page.size);
    },
    destroyed() {

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
