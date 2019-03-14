<template>
  <div class="animated fadeIn content">
    <el-card>
      <purchase-order-toolbar @onSearch="onSearch"/>
      <purchase-order-search-result-list :page="page"/>
    </el-card>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions} = createNamespacedHelpers('BrandProductionOrdersModule');

  import PurchaseOrderToolbar from './toolbar/Toolbar';
  import PurchaseOrderSearchResultList from './list/SearchResultList';

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
      }
    },
    data() {
      return {}
    },
    created() {
    }
  }
</script>
