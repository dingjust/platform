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
      <div class="pt-2"></div>
      <sales-production-toolbar @onSearch="onSearch" @onAdvancedSearch="onAdvancedSearch"
                                @createSalesPlan="createSalesPlan" @createSalesOrder="createSalesOrder"/>
      <sales-production-status-bar/>
      <el-divider></el-divider>
      <sales-production-list :page="page"/>
      <!-- <sales-order-toolbar @onSearch="onSearch" @onAdvancedSearch="onAdvancedSearch" />
      <el-tabs v-model="activeStatus" @tab-click="handleClick">
        <template v-for="(item, index) in statues">
          <el-tab-pane :name="item.code" :key="index">
            <span slot="label">
              <tab-label-bubble :label="item.name" :num="0" />
            </span>
            <sales-order-search-result-list :page="page" @onSearch="onSearch" @onAdvancedSearch="onAdvancedSearch"
                                            @cannelOrder="cannelOrder" @remindDelivery="remindDelivery"
                                            @confirmDelivery="confirmDelivery" @onDeliveryForm="onDeliveryForm"/>
          </el-tab-pane>
        </template>
      </el-tabs> -->
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
    name: 'SalesProductionOrderPage',
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
      onSearch () {
        const url = this.apis().getSalesOrderList();
        this.setIsAdvancedSearch(false);
        this.search({
          url
        });
      },
      onAdvancedSearch () {

      },
      createSalesPlan () {

      },
      createSalesOrder () {

      }
    },
    data () {
    },
    created () {
      this.onSearch();
    },
    mounted () {

    }
  };
</script>

<style scoped>
   .sales-list-title {
     border-left: 2px solid #ffd60c;
     padding-left: 10px;
   }
</style>
