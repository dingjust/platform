<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="4">
          <div class="sales-list-title">
            <h6>企划订单列表</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <sales-production-toolbar @onSearch="onSearch" @onAdvancedSearch="onAdvancedSearch" :queryFormData="queryFormData"
        @createSalesPlan="createSalesPlan" @createSalesOrder="createSalesOrder" :dataQuery="dataQuery" @onResetQuery="onResetQuery"
        @onUniqueCodeImport="onUniqueCodeImport" />
      <!-- <el-divider class="sales-divider"></el-divider> -->
      <el-tabs v-model="activeName" @tab-click="handleClick">
        <template v-for="item in statuses">
          <el-tab-pane :label="tabName(item)" :name="item.code" :key="item.code">
            <sales-production-list :page="page" @onSearch="onSearch" @onAdvancedSearch="onAdvancedSearch"
              @onDelete="onDelete" />
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
  import SalesProductionToolbar from './toolbar/SalesProductToolbar';
  import SalesProductionStatusBar from './components/SalesProductionStatusBar';
  import SalesProductionList from './list/SalesProductionList';

  const {
    mapGetters,
    mapActions,
    mapMutations
  } = createNamespacedHelpers(
    'SalesProductionOrdersModule'
  );

  export default {
    name: 'SalesProduction',
    components: {
      SalesProductionList,
      SalesProductionStatusBar,
      SalesProductionToolbar
    },
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
      ...mapMutations({
        setIsAdvancedSearch: 'isAdvancedSearch',
        setDetailData: 'detailData'
      }),
      onSearch(page, size) {
        const keyword = this.keyword;
        const statuses = ['NONE'];
        const url = this.apis().getSalesOrderList();
        this.setIsAdvancedSearch(false);
        this.search({
          url,
          keyword,
          statuses,
          page,
          size
        });
      },
      onAdvancedSearch(page, size) {
        this.setIsAdvancedSearch(true);
        if (this.queryFormData.users.length <= 0 && this.queryFormData.depts.length <= 0) {
          this.onResetQuery();
        }
        const query = this.queryFormData;
        const url = this.apis().getSalesOrderList();
        this.searchAdvanced({
          url,
          query,
          page,
          size
        });
        this.salesOrderStateCount();
      },
      async salesOrderStateCount () {
        const url = this.apis().salesOrderStateCount();
        const result = await this.$http.post(url, this.queryFormData);
        if (result['errors']) {
          this.stateCount = {};
          this.$message.error(result['errors'][0].message);
          return;
        }
        if (result.code === 0) {
          this.stateCount = {};
          this.$message.error(result.msg);
          return;
        }
        this.stateCount = result.data;
      },
      tabName (tab) {
        if (this.stateCount.hasOwnProperty(tab.code)) {
          return tab.name +'('+ this.stateCount[tab.code] +')';  
        }
        return tab.name;
      },
      handleClick (tab, event) {
        this.queryFormData.state = tab.name;
        this.onAdvancedSearch();
      },
      onDelete() {

      },
      createSalesPlan() {
        this.$router.push({
          name: '录入企划订单'
        });
      },
      createSalesOrder() {
        this.$router.push({
          name: '录入业务订单'
        });
      },
      onResetQuery () {
        this.queryFormData = JSON.parse(JSON.stringify(Object.assign(this.queryFormData, this.dataQuery)));
      },
      onUniqueCodeImport() {},
    },
    data() {
      return {
        activeName: 'TO_BE_SUBMITTED',
        statuses: [],
        queryFormData: {
          keyword: '',
          planLeader: '',
          originCooperator: '',
          cooperator: '',
          state: 'TO_BE_SUBMITTED'
        },
        stateCount: {},
        dataQuery: {}
      }
    },
    created() {
      this.dataQuery = this.getDataPerQuery('SALES_PLAN');
      this.onResetQuery();
      this.onAdvancedSearch(0, 10);
      this.statuses = Object.assign([], this.$store.state.EnumsModule.SalesProductionOrderState);
      // 去除未接单
      let index = this.statuses.findIndex(item => item.code == 'TO_BE_ACCEPTED');
      this.statuses.splice(index, 1);
    }
  }

</script>

<style scoped>
  .sales-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .sales-divider {
    margin: 5px
  }

</style>
