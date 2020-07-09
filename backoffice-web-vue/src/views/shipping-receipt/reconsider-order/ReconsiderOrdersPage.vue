<template>
  <div>
    <reconsider-orders-toolbar :queryFormData="queryFormData" :ableToApply="ableToApply"
      @onAdvancedSearch="onAdvancedSearch" @onApply="onApply" />
    <el-row type="flex" justify="start">
      <h6 style="color: #F56C6C">注明：待复议中的发货订单，申请复议时间为5天，如5天内没有申请复议，则视为放弃复议，此发货单将不再接受复议</h6>
    </el-row>
    <div class="over-tabs">
      <el-row type="flex">
        <el-button v-if="activeName=='PENDING_RECONSIDER'" class="material-btn" @click="onReconsider">申请复议</el-button>
      </el-row>
    </div>
    <el-tabs v-model="activeName" @tab-click="handleClick">
      <template v-for="(map,states) in statusMap">
        <el-tab-pane :label="getEnum('ShippingSheetState', map.states)" :name="states" :key="states">
          <shipping-dynamic-table :page="page" :columns="map.columns" @onAdvancedSearch="onAdvancedSearch"
            @onSelect="onSelect" />
        </el-tab-pane>
      </template>
    </el-tabs>
  </div>
</template>

<script>
  import ReconsiderOrdersToolbar from './toolbar/ReconsiderOrdersToolbar'
  import ReconsiderOrdersList from './list/ReconsiderOrdersList'

  import {
    ShippingDynamicTable
  } from '../components/index'

  export default {
    name: 'ReconsiderOrdersPage',
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
      ReconsiderOrdersToolbar,
      ReconsiderOrdersList,
      ShippingDynamicTable
    },
    computed: {
      ableToApply: function () {
        return this.activeName == 'first';
      }
    },
    methods: {
      getStatusVal(state) {
        return this.getEnum("ShippingSheetState", state);
      },
      handleClick(tab, event) {
        this.$emit('handleClick', {
          states: this.statusMap[tab.name].states,
          searchUrl: this.statusMap[tab.name].url
        });
      },
      onSearch(page, size) {
        this.$emit('onSearch');
      },
      onAdvancedSearch(page, size) {
        this.$emit('onAdvancedSearch');
      },
      onApply() {

      },
      onDetail() {

      },
      onSelect(val) {        
        this.selectedData=val;
      },
      onReconsider() {

      }
    },
    data() {
      return {
        activeName: 'PENDING_RECONSIDER',
        statusMap: {
          PENDING_RECONSIDER: {
            states: 'PENDING_RECONSIDER',
            columns: ['多选', '发货单号', '产品名称', '关联订单', '发货收货数', '退货收货数', '收货日期', '差异数', '发货操作'],
            url: this.apis().shippingOrderList()
          },
          IN_RECONSIDER: {
            states: 'IN_RECONSIDER',
            columns: ['多选','发货单号', '产品名称', '关联订单', '关联收货单', '收货单创建人', '发货数', '收货数', '发货操作'],
            url: this.apis().shippingOrderList()
          },
          RECONSIDER_SUCCESS: {
            states: 'RECONSIDER_SUCCESS',
            columns: ['多选','退货单', '产品名称', '关联订单', '关联发货单', '退货单创建人', '单价', '退货数', '退货操作'],
            url: this.apis().shippingOrderList()
          },
          RECONSIDER_FAIL: {
            states: 'RECONSIDER_FAIL',
            columns: ['多选','退货单', '产品名称', '关联订单', '关联发货单', '退货单创建人', '单价', '退货数', '退货操作'],
            url: this.apis().shippingOrderList()
          },
          RECONSIDER_EXPIRED: {
            states: 'RECONSIDER_EXPIRED',
            columns: ['多选','发货单号', '产品名称', '单价', '发货数量', '收货单', '收货数', '差异数', '发货操作'],
            url: this.apis().shippingOrderList()
          }
        },
        selectedData:''
      }
    },
  }

</script>

<style scoped>
  .title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .over-tabs {
    position: absolute;
    z-index: 100;
    right: 30px;
    margin-top: 2px;
  }

  .material-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    width: 120px;
    height: 35px;
  }

</style>
