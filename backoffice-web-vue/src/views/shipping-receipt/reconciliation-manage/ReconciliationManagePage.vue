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
      <reconciliation-manage-toolbar :queryFormData="queryFormData" :canCreateReceipt="canCreateReceipt"
                                @onCreate="onCreate" @onAdvancedSearch="onAdvancedSearch"/>
      <el-row type="flex" justify="end">
        <el-col :span="3">
          <el-button type="text" class="list-btn" @click="orderListVisible = !orderListVisible">对账单</el-button>
        </el-col>
      </el-row>
      <el-tabs v-model="activeName" @tab-click="handleClick">
        <el-tab-pane label="待对账" name="first">
          <shipping-orders-list :page="page" :canCreateReceipt="canCreateReceipt"
                                @onAdvancedSearch="onAdvancedSearch" @onDetail="onShippingDetail"/> 
        </el-tab-pane>
        <el-tab-pane label="待核验" name="second">
          <reconciliation-orders-list :page="page" @onAdvancedSearch="onAdvancedSearch" @onDetail="onReconciliationDetail"/>
        </el-tab-pane>
        <el-tab-pane label="已核验" name="third">
          <reconciliation-orders-list :page="page" @onAdvancedSearch="onAdvancedSearch" @onDetail="onReconciliationDetail"/>
        </el-tab-pane>
      </el-tabs>
    </el-card>
    <el-dialog :visible.sync="orderListVisible" width="80%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <reconciliation-orders-page v-if="orderListVisible"/>
    </el-dialog>
  </div>
</template>

<script>
  import ReconciliationManageToolbar from './toolbar/ReconciliationManageToolbar'
  import ReconciliationOrdersPage from '../reconciliation-order/ReconciliationOrdersPage'
  import ShippingOrdersList from '../shipping-order/list/ShippingOrdersList'
  import ReconciliationOrdersList from '../reconciliation-order/list/ReconciliationOrdersList'
  export default {
    name: 'ReconciliationManagePage',
    props: ['mode'],
    components: {
      ReconciliationManageToolbar,
      ReconciliationOrdersPage,
      ShippingOrdersList,
      ReconciliationOrdersList
    },
    computed: {
      canCreateReceipt: function () {
        // 判断是否能创建收货单
        return true;
      }
    },
    methods: {
      handleClick (tab, event) {
        if (tab.name == 'first') {
          this.queryFormData.status = '待对账';
          this.searchUrl = this.apis().getProductionTaskList();
        } else if (tab.name == 'second') {
          this.queryFormData.status = '待核验';
          this.searchUrl = this.apis().getProductionOrders();
        } else if (tab.name == 'third') {
          this.queryFormData.status = '已核验';
          this.searchUrl = this.apis().getProductionOrders();
        } 
        this.onAdvancedSearch(0, 10);
      },
      async onAdvancedSearch (page, size) {
        const url = this.searchUrl;
        const query = this.queryFormData;
        const result = await this.$http.post(url, query, {
          page: page,
          size: size
        });
        this.page = result;
      },
      onShippingDetail () {

      },
      onReconciliationDetail (row) {
        this.$router.push('/reconciliation/orders/' + row.id);
      },
      // 创建对账单
      onCreate () {
        this.$router.push('/reconciliation/create/orders');
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
        orderListVisible: false,
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
      this.queryFormData.status = '待对账';
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
