<!-- 
 * @description: 对账单
 * @fileName: ReconciliationOrdersPage.vue 
 * @author: yj 
 * @date: 2020-06-22 15:09:48
 * @version: V1.0.0 
!-->
<template>
  <div class="animated fadeIn">
    <el-row>
      <el-col :span="4">
        <div class="title">
          <h6>对账单列表</h6>
        </div>
      </el-col>
    </el-row>
    <div class="pt-2"></div>
    <reconciliation-orders-toolbar :queryFormData="queryFormData" 
                              @onAdvancedSearch="onAdvancedSearch"/>
    <el-tabs v-model="activeName" @tab-click="handleClick">
      <template v-for="item in statuses">
        <el-tab-pane :label="item.name" :name="item.code" :key="item.code">
          <reconciliation-orders-list :page="page" @onAdvancedSearch="onAdvancedSearch" @onDetail="onDetail"/>
        </el-tab-pane>
      </template>
    </el-tabs>
  </div>
</template>

<script>
  import { createNamespacedHelpers } from 'vuex';
  const {
    mapGetters,
    mapActions
  } = createNamespacedHelpers(
    'ReconciliationOrdersModule'
  );

  import ReconciliationOrdersToolbar from './toolbar/ReconciliationOrdersToolbar'
  import ReconciliationOrdersList from './list/ReconciliationOrdersList'
  export default {
    name: 'ReconciliationOrdersPage',
    props: {

    },
    components: {
      ReconciliationOrdersToolbar,
      ReconciliationOrdersList
    },
    computed: {
      ...mapGetters({
        keyword: 'keyword',
        page: 'page',
        formData: 'formData'
      })
    },
    methods: {
      ...mapActions({
        search: 'search',
        searchAdvanced: 'searchAdvanced'
      }),
      onSearch (page, size) {
        const keyword = this.keyword;
        const url = this.apis().getProductionTaskList();
        this.search({
          url,
          keyword,
          page,
          size
        });
      },
      onAdvancedSearch (page, size) {
        const query = this.queryFormData;
        const url = this.apis().getProductionTaskList();
        this.searchAdvanced({url, query, page, size});
      },
      handleClick (tab, event) {
        this.queryFormData.status = tab.name;
        this.onAdvancedSearch(0, 10);
      },
      onDetail (row) {
        this.$router.push('/reconciliation/orders/' + row.id);
      },
    },
    data() {
      return {
        activeName: '',
        statuses: [
          {
            code: '',
            name: '全部'
          },
          {
            code: '1',
            name: '待核验'
          },
          {
            code: '2',
            name: '复议中'
          },
          {
            code: '3',
            name: '待付款'
          },
          {
            code: '4',
            name: '已付款'
          }
        ],
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
      this.onSearch();
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

</style>