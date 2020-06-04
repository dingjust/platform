<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="4">
          <div class="sales-list-title">
<!--            采购任务列表-->
            <h6>订单列表</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <purchase-task-toolbar :queryFormData="queryFormData"
                             @onAdvancedSearch="onAdvancedSearch" @createPurchaseTask="createPurchaseTask"/>
      <el-tabs v-model="activeName" @tab-click="handleClick">
        <template v-for="(item, index) in statuses">
          <el-tab-pane :name="item.code" :label="item.name">
            <purchase-task-list :page="page" @onAdvancedSearch="onAdvancedSearch"/>
          </el-tab-pane>
        </template>
      </el-tabs>
    </el-card>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';

  const {
    mapGetters,
    mapActions
  } = createNamespacedHelpers(
    'PurchaseTaskModule'
  );

  import PurchaseTaskList from './list/PurchaseTaskList';
  import PurchaseTaskToolbar from './toolbar/PurchaseTaskToolbar';
  export default {
    name: 'PurchaseTaskPage',
    components: {PurchaseTaskToolbar, PurchaseTaskList},
    computed: {
      ...mapGetters({
        page: 'page',
        keyword: 'keyword',
        queryFormData: 'queryFormData'
      })
    },
    methods: {
      ...mapActions({
        search: 'search',
        searchAdvanced: 'searchAdvanced'
      }),
      onSearch (page, size) {
      },
      onAdvancedSearch (page, size) {
        const query = this.queryFormData;
        const url = this.apis().getPurchaseTaskList();
        this.searchAdvanced({url, query, page, size});
      },
      handleClick (tab, event) {
        // this.queryFormData.status = tab.name;
        this.onAdvancedSearch();
      },
      createPurchaseTask () {
        this.$router.push('/sales/create/purchaseTask');
      }
    },
    data () {
      return {
        activeName: '',
        statuses: [{
          code: '',
          name: '全部'
        }, {
          code: 'UNPURCHASE',
          name: '未采购'
        }, {
          code: 'PURCHASE',
          name: '已采购'
        }]
      }
    },
    created () {
      this.onAdvancedSearch();
    }
  }
</script>

<style scoped>
  .sales-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }
</style>
