<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="4">
          <div class="sales-list-title">
            <h6>订单列表</h6>
          </div>
        </el-col>
      </el-row>
      <sales-production-toolbar @onSearch="onSearch" @onAdvancedSearch="onAdvancedSearch" :queryFormData="queryFormData"
        @createSalesPlan="createSalesPlan" @createSalesOrder="createSalesOrder"
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
        const result = await this.$http.get(url);
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
          name: '录入销售计划'
        });
      },
      createSalesOrder() {
        this.$router.push({
          name: '录入销售订单'
        });
      },
      onUniqueCodeImport() {},
    },
    data() {
      return {
        activeName: 'TO_BE_SUBMITTED',
        statuses: [],
        queryFormData: {
          code: '',
          requirementOrderCode: '',
          skuID: '',
          statuses: [],
          refunding: '',
          expectedDeliveryDateFrom: null,
          expectedDeliveryDateTo: null,
          createdDateFrom: null,
          createdDateTo: null,
          keyword: '',
          categories: [],
          state: 'TO_BE_SUBMITTED'
        },
        stateCount: {}
      }
    },
    created() {
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
