<template>
  <div class="animated fadeIn content">
    <el-card>
      <purchase-order-toolbar @onSearch="onSearch" @onNew="onNew"/>
      <purchase-order-search-result-list :page="page" @onDetails="onDetails"/>
    </el-card>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions} = createNamespacedHelpers('BrandPurchaseOrdersModule');

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
      onSearch(keyword) {
        this.search({keyword});
      },
      onNew(formData) {
        // console.log('onNew: ' + JSON.stringify(formData));
        this.fn.openSlider('创建生产订单', PurchaseOrderDetailsPage, formData);
      },
      async onDetails(row) {
        // console.log('onDetails: ' + JSON.stringify(row));
        const result = await this.$http.get('/b2b/orders/purchase/' + row.code);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.fn.openSlider('明细，订单编号：' + result.code, PurchaseOrderDetailsPage, result);
      }
    },
    data() {
      return {}
    },
    created() {
      this.search('');
    }
  }
</script>
