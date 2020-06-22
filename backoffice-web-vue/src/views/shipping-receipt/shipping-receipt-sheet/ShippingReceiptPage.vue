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
        <el-tab-pane label="待发货" name="first">
          <shipping-orders-list :page="page" @onAdvancedSearch="onAdvancedSearch" @onDetail="onShippingDetail" />
        </el-tab-pane>
        <el-tab-pane label="已发货" name="second">
          <receipt-orders-list :page="page" @onAdvancedSearch="onAdvancedSearch" @onDetail="onReceiptDetail" />
        </el-tab-pane>
        <el-tab-pane label="待退货" name="third">
          <shipping-orders-list :page="page" @onAdvancedSearch="onAdvancedSearch" @onDetail="onShippingDetail" />
        </el-tab-pane>
        <el-tab-pane label="退货待收" name="fourth">
          <return-orders-list :page="page" @onAdvancedSearch="onAdvancedSearch" @onDetail="onReturnDetail" />
        </el-tab-pane>
        <el-tab-pane label="退货已收" name="fifth">
          <return-orders-list :page="page" @onAdvancedSearch="onAdvancedSearch" @onDetail="onReturnDetail" />
        </el-tab-pane>
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
  import ShippingOrdersList from '../shipping-order/list/ShippingOrdersList'
  import ReceiptOrdersList from '../receipt-order/list/ReceiptOrdersList'
  import ReturnOrdersList from '../return-order/list/ReturnOrdersList'
  export default {
    name: 'ShippingReceiptPage',
    components: {
      ShippingReceiptToolbar,
      ShippingOrdersPage,
      ReceiptOrdersPage,
      ReturnOrdersPage,
      ShippingOrdersList,
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
        if (tab.name == 'first') {
          this.queryFormData.status = '待发货';
          this.searchUrl = this.apis().getProductionTaskList();
        } else if (tab.name == 'second') {
          this.queryFormData.status = '';
          this.searchUrl = this.apis().getProductionOrders();
        } else if (tab.name == 'third') {
          this.queryFormData.status = '待退货';
          this.searchUrl = this.apis().getProductionTaskList();
        } else if (tab.name == 'fourth') {
          this.queryFormData.status = '退货待收';
          this.searchUrl = this.apis().getoutboundOrdersList();
        } else if (tab.name == 'fifth') {
          this.queryFormData.status = '退货已收';
          this.searchUrl = this.apis().getoutboundOrdersList();
        }
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
      onShippingDetail() {

      },
      onReceiptDetail() {

      },
      onReturnDetail() {

      },
      // 创建收货单
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
        activeName: 'first',
        searchUrl: '',
        shippingListVisible: false,
        receiptListVisible: false,
        returnListVisible: false,
        queryFormData: {
          keyword: '',
          productionLeaderName: '',
          operatorName: '',
          creationtimeStart: '',
          creationtimeEnd: '',
          status: ''
        }
      }
    },
    created() {
      this.queryFormData.status = '待发货';
      this.searchUrl = this.apis().getProductionTaskList();
      this.onAdvancedSearch(0, 10);
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
