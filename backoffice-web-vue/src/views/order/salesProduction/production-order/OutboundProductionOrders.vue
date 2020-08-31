<!-- 
 * @description: 外发工单列表
 * @fileName: OutboundProductionOrders.vue 
 * @author: yj 
 * @date: 2020-06-23 10:58:30
 * @version: V1.0.0 
!-->
<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="4">
          <div class="orders-list-title">
            <h6>外发工单列表</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <production-order-toolbar @onSearch="onSearch" @onAdvancedSearch="onAdvancedSearch" :queryFormData="queryFormData"
                                :isOutProduction="true" :dataQuery="dataQuery" @onResetQuery="onResetQuery"/>
      <el-tabs v-model="activeStatus" @tab-click="handleClick">
        <template v-for="(item, index) in statues">
          <el-tab-pane :name="item.code" :key="index" :label="tabName(item)">
            <production-order-list mode='export' :page="page" @onSearch="onSearch" @onAdvancedSearch="onAdvancedSearch" :isOutProduction="true" />
          </el-tab-pane>
        </template>
      </el-tabs>
    </el-card>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from "vuex";

  const {
    mapGetters,
    mapActions,
    mapMutations
  } = createNamespacedHelpers(
    'OutboundProductionOrderModule'
  );

  import ProductionOrderList from './list/ProductionOrderList';
  import ProductionOrderToolbar from './toolbar/ProductionOrderToolbar';

  export default {
    name: 'ProductionOrders',
    components: {
      ProductionOrderList,
      ProductionOrderToolbar
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
        searchAdvanced: 'searchAdvanced',
      }),
      ...mapMutations({
        setIsAdvancedSearch: 'isAdvancedSearch',
        setDetailData: 'detailData'
      }),
      onSearch(page, size) {
        const keyword = this.keyword;
        const statuses = this.statuses;
        const url = this.apis().getoutboundProductionList();
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
        const url = this.apis().getoutboundProductionList();
        this.searchAdvanced({
          url,
          query,
          page,
          size
        });
        this.outProductionOrderStateCount();
      },
      async outProductionOrderStateCount () {
        const url = this.apis().outProductionOrderStateCount();
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
      handleClick(tab, event) {
        this.queryFormData.state = tab.name;
        this.onAdvancedSearch();
      },
      onResetQuery () {
        this.queryFormData = JSON.parse(JSON.stringify(Object.assign(this.queryFormData, this.dataQuery)));
      },
    },
    data() {
      return {
        formData: this.$store.state.ProductionOrderModule.formData,
        activeStatus: 'TO_BE_PRODUCED',
        statues: [{
          code: 'TO_BE_PRODUCED',
          name: '待生产'
        }, {
          code: 'PRODUCING',
          name: '生产中'
        }, {
          code: 'TO_BE_DELIVERED',
          name: '待出库'
        }, {
          code: 'TO_BE_RECONCILED',
          name: '待对账'
        }, {
          code: 'COMPLETED',
          name: '已完成'
        }, {
          code: 'CANCED',
          name: '已取消'
        }, {
          code: '',
          name: '全部'
        }],
        queryFormData: {
          createdDateFrom: null,
          createdDateTo: null,
          keyword: '',
          categories: [],
          state: 'TO_BE_PRODUCED'
        },
        stateCount: {},
        dataQuery: {}
      };
    },
    created() {
      this.dataQuery = this.getDataPerQuery('OUT_PRODUCTION_TASK_ORDER');
      this.onResetQuery();
      this.onAdvancedSearch(0, 10);
    },
    mounted() {

    },
    destroyed() {
    }
  };

</script>
<style>
  .report {
    margin-bottom: 10px;
  }

  .orders-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .purchase-dialog .el-dialog {
    border-radius: 10px !important;
  }

  .purchase-dialog-header {
    padding: 0px !important;
  }

  .purchase-dialog .el-dialog__header {
    padding: 0px !important;
  }

</style>
