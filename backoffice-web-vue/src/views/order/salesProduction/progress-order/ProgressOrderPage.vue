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
        <template v-for="item in statuses">
          <el-tab-pane :name="item.code" :key="item.code" :label="tabName(item)">
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
        this.progressOrderStateCount();
      },
      async getPhaseList () {
        const url = this.apis().getProgressPhaseList();
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        result.data.content.forEach(item => {
          this.statuses.push({
            name: item.name,
            code: item.id + ''
          })
        })
      },
      async progressOrderStateCount () {
        const url = this.apis().progressOrderStateCount();
        const result = await this.$http.post(url, this.queryFormData);
        if (result['errors']) {
          this.stateCount = {};
          return;
        }
        if (result.code === 0) {
          this.stateCount = {};
          return;
        }
        this.stateCount = result.data;
      },
      tabName (tab) {
        let index = this.stateCount.findIndex(item => item.stateName == tab.name);
        if (index > -1) {
          return tab.name +'('+ this.stateCount[index].count +')';
        }
        // if (this.stateCount.hasOwnProperty(tab.code)) {
        //   return tab.name +'('+ this.stateCount[tab.code] +')';  
        // }
        return tab.name;
      },
      handleClick (tab, event) {
        this.queryFormData.state = tab.name;
        this.onAdvancedSearch();
      }
    },
    data () {
      return {
        activeName: '',
        statuses: [{
          code: '',
          name: '全部'
        }],
        queryFormData: {
          keyword: '',
          state: '',
          expectedDeliveryDateFrom: '',
          expectedDeliveryDateTo: '',
          operatorName: ''
        },
        stateCount: []
      }
    },
    created() {
      this.onAdvancedSearch();
      this.getPhaseList();
    },
    destroyed() {
    }
  }
</script>

<style scoped>
  .progress-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }
</style>
