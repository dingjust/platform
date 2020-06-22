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
            <h6>待接订单列表</h6>
          </div>
        </el-col>
      </el-row>
      <sales-production-toolbar @onSearch="onSearch" @onAdvancedSearch="onAdvancedSearch"
        @createSalesPlan="createSalesPlan" @createSalesOrder="createSalesOrder"
        @onUniqueCodeImport="onUniqueCodeImport" />
      <el-divider class="sales-divider"></el-divider>
      <sales-production-list :page="page" @onSearch="onSearch" @onAdvancedSearch="onAdvancedSearch"
        @onDelete="onDelete" />
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
        queryFormData: 'queryFormData',
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
        const statuses = this.statuses;
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

      }
    },
    created() {
      this.onSearch();
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
