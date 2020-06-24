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
        @onUniqueCodeImport="onUniqueCodeImport" :isPending="true"/>
      <el-tabs v-model="activeName" @tab-click="handleClick">
        <template v-for="item in statuses">
          <el-tab-pane :label="item.name" :name="item.code" :key="item.code">
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
      handleClick (tab, event) {
        this.queryFormData.status = tab.name;
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
        activeName: '',
        statuses: [
          {
            code: '',
            name: '全部'
          },
          {
            code: 'NONE',
            name: '未提交'
          },
          {
            code: 'AUDITING',
            name: '审核中'
          },
          {
            code: 'PASSED',
            name: '审核通过'
          },
          {
            code: 'AUDITED_FAILED',
            name: '审核驳回'
          },
          {
            code: 'CANCELLED',
            name: '已取消'
          }
        ]
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
