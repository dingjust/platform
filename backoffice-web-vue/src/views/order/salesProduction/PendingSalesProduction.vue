<!-- 
 * @description: 待接销售订单
 * @fileName: PendingSalesProduction.vue 
 * @author: yj 
 * @date: 2020-06-22 09:33:13
 * @version: V1.0.0 
!-->
<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="4">
          <div class="sales-list-title">
            <h6>外接订单列表</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <sales-production-toolbar @onSearch="onSearch" @onAdvancedSearch="onAdvancedSearch" :queryFormData="queryFormData"
        @createSalesPlan="createSalesPlan" @createSalesOrder="createSalesOrder"
        @onUniqueCodeImport="onUniqueCodeImport" :isPending="true" :dataQuery="dataQuery"/>
      <el-tabs v-model="activeName" @tab-click="handleClick">
        <template v-for="item in statuses">
          <el-tab-pane :label="tabName(item)" :name="item.code" :key="item.code">
            <sales-production-list :page="page" @onSearch="onSearch" @onAdvancedSearch="onAdvancedSearch"
                                    :isPending="true" @onDelete="onDelete" />
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
    'PendingSalesProductionOrdersModule'
  );

  export default {
    name: 'PendingSalesProduction',
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
        const url = this.apis().getPendingSalesOrderList();
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
          this.queryFormData = JSON.parse(JSON.stringify(Object.assign(this.queryFormData, this.dataQuery)));
        }
        const query = this.queryFormData;
        const url = this.apis().getPendingSalesOrderList();
        this.searchAdvanced({
          url,
          query,
          page,
          size
        });
        this.pendingOrderStateCount();
      },
      handleClick (tab, event) {
        this.queryFormData.state = tab.name;
        this.onAdvancedSearch();
      },
      async pendingOrderStateCount () {
        const url = this.apis().pendingOrderStateCount();
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
          if (tab.code == 'TO_BE_ACCEPTED') {
            return '待接单/待提交(' + this.stateCount[tab.code] +')';
          }
          return tab.name +'('+ this.stateCount[tab.code] +')';  
        }
        return tab.name;
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
      onUniqueCodeImport() {},
    },
    data() {
      return {
        pageSign: 'SALES_OUT_ORDER',
        activeName: 'TO_BE_ACCEPTED',
        statuses: [],
        queryFormData: {
          keyword: '',
          planLeader: '',
          originCooperator: '',
          state: 'TO_BE_ACCEPTED'
        },
        stateCount: {},
        dataQuery: {}
      }
    },
    created() {
      this.dataQuery = this.getDataPerQuery(this.pageSign);
      this.queryFormData = JSON.parse(JSON.stringify(Object.assign(this.queryFormData, this.dataQuery)));
      this.onAdvancedSearch();
      this.statuses = Object.assign([], this.$store.state.EnumsModule.SalesProductionOrderState);
      // 去除未提交
      let index = this.statuses.findIndex(item => item.code == 'TO_BE_SUBMITTED');
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
