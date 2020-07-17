<template>
  <div>
    <reconciliation-manage-toolbar :queryFormData="queryFormData" :canCreate="canCreate"
      @onCreate="onCreate" @onAdvancedSearch="onAdvancedSearch" />
    <el-row type="flex" justify="end">
      <el-col :span="3">
        <el-button type="text" class="list-btn" @click="orderListVisible = !orderListVisible">对账单</el-button>
      </el-col>
    </el-row>
    <el-tabs v-model="activeName" @tab-click="handleClick">
      <template v-for="(map,status) in statusMap">
        <el-tab-pane :label="map.label" :name="status" :key="status">
          <shipping-dynamic-table :page="page" :columns="map.columns" @onAdvancedSearch="onAdvancedSearch" />
        </el-tab-pane>
      </template>
    </el-tabs>
    <el-dialog :visible.sync="orderListVisible" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <reconciliation-orders-page v-if="orderListVisible" :mode="mode"/>
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
        // 判断是否能创建对账单
        return true;
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
      // 创建对账单
      onCreate() {
        this.$router.push('/reconciliation/create/orders');
      }
    },
    data() {
      return {
        activeName: 'PENDING_RECONCILED',
        orderListVisible: false,
      }
    },
    created() {
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
