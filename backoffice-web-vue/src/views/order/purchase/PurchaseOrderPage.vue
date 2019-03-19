<template>
  <div class="animated fadeIn content">
    <el-card>
      <purchase-order-toolbar @onNew="onNew"
                              @onSearch="onSearch"
                              @onAdvancedSearch="onAdvancedSearch"/>
      <purchase-order-search-result-list :page="page"
                                         @onDetails="onDetails"
                                         @onSearch="onSearch"
                                         @onAdvancedSearch="onAdvancedSearch"/>
    </el-card>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions} = createNamespacedHelpers('PurchaseOrdersModule');

  import PurchaseOrderToolbar from './toolbar/PurchaseOrderToolbar';
  import PurchaseOrderSearchResultList from './list/PurchaseOrderSearchResultList';
  import PurchaseOrderDetailsPage from "./details/PurchaseOrderDetailsPage";

  export default {
    name: 'PurchaseOrderPage',
    components: {
      PurchaseOrderToolbar,
      PurchaseOrderSearchResultList
    },
    computed: {
      ...mapGetters({
        page: 'page'
      })
    },
    methods: {
      ...mapActions({
        search: 'search',
        searchAdvanced: 'searchAdvanced'
      }),
      onSearch(page, size) {
        const keyword = this.keyword;
        const statuses = this.statuses;
        this.search({keyword, statuses, page, size});
      },
      onAdvancedSearch(page, size) {
        this.isAdvancedSearch = true;

        const query = this.queryFormData;
        this.searchAdvanced({query, page, size});
      },
      async onDetails(row) {
        const result = await this.$http.get('/b2b/orders/purchase/' + row.code);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.fn.openSlider('生产订单：' + result.code, PurchaseOrderDetailsPage, result);
      },
      onNew(formData) {
        this.fn.openSlider('创建手工单', PurchaseOrderDetailsPage, formData);
      },
    },
    data() {
      return {
        keyword: this.$store.state.PurchaseOrdersModule.keyword,
        formData: this.$store.state.PurchaseOrdersModule.formData,
        queryFormData: this.$store.state.PurchaseOrdersModule.queryFormData,
        isAdvancedSearch: this.$store.state.PurchaseOrdersModule.isAdvancedSearch,
      }
    },
    created() {
      this.onSearch('');
    }
  }
</script>
