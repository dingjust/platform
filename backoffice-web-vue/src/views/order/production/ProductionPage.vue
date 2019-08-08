<template>
  <div class="animated fadeIn content">
    <div class="report"><production-report /></div>
    <el-card>
      <el-row>
        <el-col :span="2">
          <h6>订单列表</h6>
        </el-col>
      </el-row>
      <production-toolbar @onNew="onNew"
                              @onSearch="onSearch"
                              @onAdvancedSearch="onAdvancedSearch"/>
      <production-search-result-list :page="page"
                                         @onDetails="onDetails"
                                         @onSearch="onSearch"
                                         @onAdvancedSearch="onAdvancedSearch"/>
    </el-card>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions,mapMutations} = createNamespacedHelpers('PurchaseOrdersModule');

  import ProductionToolbar from './toolbar/ProductionToolbar';
  import ProductionSearchResultList from './list/ProductionSearchResultList';
  import ProductionReport from './components/ProductionReport';
  // import PurchaseOrderDetailsPage from "./details/PurchaseOrderDetailsPage";

  export default {
    name: 'PurchaseOrderPage',
    components: {
      ProductionToolbar,
      ProductionSearchResultList,
      ProductionReport
    },
    computed: {
      ...mapGetters({
        page: 'page',
        keyword: 'keyword',
        queryFormData: 'queryFormData',
      })
    },
    methods: {
      ...mapActions({
        search: 'search',
        searchAdvanced: 'searchAdvanced'
      }),
      ...mapMutations({
        setIsAdvancedSearch: 'isAdvancedSearch'
      }),
      onSearch(page, size) {
        const keyword = this.keyword;
        const statuses = this.statuses;
        const url = this.apis().getPurchaseOrders();
        this.setIsAdvancedSearch(false);
        this.search({url, keyword, statuses, page, size});
      },
      onAdvancedSearch(page, size) {
        this.setIsAdvancedSearch(true);
        const query = this.queryFormData;
        const url = this.apis().getPurchaseOrders();
        this.searchAdvanced({url, query, page, size});
      },
      async onDetails(row) {
        const url = this.apis().getPurchaseOrder(row.code);
        const result = await this.$http.get(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        // this.fn.openSlider('生产订单：' + result.code, PurchaseOrderDetailsPage, result);
      },
      onNew(formData) {
        // this.fn.openSlider('创建手工单', PurchaseOrderDetailsPage, formData);
      },
    },
    data() {
      return {
        formData: this.$store.state.PurchaseOrdersModule.formData,
      }
    },
    created() {
      this.onSearch('');
    }
  }
</script>
<style>
.report{
  margin-bottom: 10px;
}
</style>

