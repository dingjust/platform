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

  const {mapGetters, mapActions} = createNamespacedHelpers('BrandProductionOrdersModule');

  import PurchaseOrderToolbar from './toolbar/Toolbar';
  import PurchaseOrderSearchResultList from './list/SearchResultList';
  import PurchaseOrderForm from './form/PurchaseOrderForm';

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
        this.fn.openSlider('创建生产订单', PurchaseOrderForm, formData);
      },
      onDetails(row) {
        console.log('onDetails: ' + JSON.stringify(row));
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
