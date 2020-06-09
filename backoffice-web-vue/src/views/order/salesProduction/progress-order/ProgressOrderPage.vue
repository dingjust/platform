<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="6">
          <div class="progress-list-title">
            <!--进度工单列表-->
            <h6>订单列表</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <progress-order-toolbar @onAdvancedSearch="onAdvancedSearch" :queryFormData="queryFormData"/>
      <el-tabs v-model="activeName" @tab-click="handleClick">
        <template v-for="(item, index) in statuses">
          <el-tab-pane :name="item.code" :key="index" :label="item.name">
            <progress-order-list :page="page" @onAdvancedSearch="onAdvancedSearch"/>
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
    mapActions,
    mapMutations
  } = createNamespacedHelpers(
    'ProgressOrderModule'
  );

  import ProgressOrderToolbar from './toolbar/ProgressOrderToolbar';
  import ProgressOrderList from './list/ProgressOrderList';
  export default {
    name: 'ProgressOrderPage',
    props: [],
    components: {ProgressOrderList, ProgressOrderToolbar},
    computed: {
      ...mapGetters({
        page: 'page',
        keyword: 'keyword',
        queryFormData: 'queryFormData',
        contentData: 'detailData'
      })
    },
    methods: {
      ...mapActions({
        search: 'search',
        searchAdvanced: 'searchAdvanced'
      }),
      onSearch(page, size) {
      },
      onAdvancedSearch (page, size) {
        const query = this.queryFormData;
        const url = this.apis().getProgressOrderList();
        this.searchAdvanced({url, query, page, size});
      },
      handleClick (tab, event) {
        this.queryFormData.statuses = tab.name;
        this.onAdvancedSearch();
      }
    },
    data () {
      return {
        activeName: '',
        statuses: [{
          code: '',
          name: '全部'
        }, {
          code: 'IN_PRODUCTION',
          name: '生产中'
        }, {
          code: 'COMPLETED',
          name: '完成'
        }]
      }
    },
    created() {
      this.onAdvancedSearch();
    }
  }
</script>

<style scoped>
  .progress-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }
</style>
