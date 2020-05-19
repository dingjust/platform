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
      <sales-production-toolbar @onSearch="onSearch" @onAdvancedSearch="onAdvancedSearch"
        @createSalesPlan="createSalesPlan" @createSalesOrder="createSalesOrder" />
      <el-divider class="sales-divider"></el-divider>
      <sales-production-list :page="page" />
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
      onSearch() {
        const url = this.apis().getSalesOrderList();
        this.setIsAdvancedSearch(false);
        this.search({
          url
        });
      },
      onAdvancedSearch() {

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
      }
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
