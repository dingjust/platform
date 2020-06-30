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
      <production-order-toolbar @onSearch="onSearch" @onAdvancedSearch="onAdvancedSearch" 
                                :isOutProduction="true"/>
      <el-tabs v-model="activeStatus" @tab-click="handleClick">
        <template v-for="(item, index) in statues">
          <el-tab-pane :name="item.code" :key="index" :label="item.name">
            <production-order-list :page="page" @onSearch="onSearch" @onAdvancedSearch="onAdvancedSearch" />
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
  import Bus from '@/common/js/bus.js';

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
        queryFormData: 'queryFormData',
        contentData: 'detailData'
      })
    },
    methods: {
      ...mapActions({
        search: 'search',
        searchAdvanced: 'searchAdvanced',
        clearQueryFormData: 'clearQueryFormData'
      }),
      ...mapMutations({
        setIsAdvancedSearch: 'isAdvancedSearch',
        setDetailData: 'detailData'
      }),
      onSearch(page, size) {
        const keyword = this.keyword;
        const statuses = this.statuses;
        const url = this.apis().getoutboundProductionList();
        // const url = this.apis().getPurchaseOrders();
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
        const url = this.apis().getoutboundProductionList();
        // const url = this.apis().getPurchaseOrders();
        this.searchAdvanced({
          url,
          query,
          page,
          size
        });
      },
      handleClick(tab, event) {
        // console.log(tab.name);
        if (tab.name == 'ALL') {
          this.queryFormData.statuses = [];
          this.onAdvancedSearch();
        } else {
          this.queryFormData.statuses = [tab.name];
          this.onAdvancedSearch();
        }
      },
    },
    data() {
      return {
        formData: this.$store.state.ProductionOrderModule.formData,
        activeStatus: 'ALL',
        statues: [{
          code: 'ALL',
          name: '全部'
        }],
      };
    },
    created() {
      this.$store.state.EnumsModule.purchaseOrderStatuses.forEach(element => {
        this.statues.push(element);
      });
      this.onSearch();
    },
    mounted() {

    },
    destroyed() {
      this.clearQueryFormData();
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
