<template>
  <div class="animated fadeIn content">
    <el-card>
      <apparel-product-toolbar @onNew="onNew"
                               @onSearch="onSearch"
                               @onAdvancedSearch="onAdvancedSearch"/>
      <apparel-product-search-result-list :page="page"
                                          @onDetails="onDetails"
                                          @onSearch="onSearch"
                                          @onAdvancedSearch="onAdvancedSearch"/>
    </el-card>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions} = createNamespacedHelpers('ApparelProductsModule');

  import ApparelProductToolbar from "./toolbar/ApparelProductToolbar";
  import ApparelProductSearchResultList from './list/ApparelProductSearchResultList';
  import ApparelProductDetailsPage from './details/ApparelProductDetailsPage';

  export default {
    name: 'ApparelProductPage',
    components: {
      ApparelProductToolbar,
      ApparelProductSearchResultList
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
        const url = this.apis().getApparelProducts();
        this.search({url, keyword, page, size});
      },
      onAdvancedSearch(page, size) {
        this.isAdvancedSearch = true;

        const query = this.queryFormData;
        const url = this.apis().getApparelProducts();
        this.searchAdvanced({url, query, page, size});
      },
      async onDetails(item) {
        const url = this.apis().getApparelProduct(item.code);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.fn.openSlider('商品：' + item.code, ApparelProductDetailsPage, result);
      },
      onNew(formData) {
        this.fn.openSlider('创建商品', ApparelProductDetailsPage, formData);
      },
    },
    data() {
      return {
        keyword: this.$store.state.ApparelProductsModule.keyword,
        formData: this.$store.state.ApparelProductsModule.formData,
        queryFormData: this.$store.state.ApparelProductsModule.queryFormData,
        isAdvancedSearch: this.$store.state.ApparelProductsModule.isAdvancedSearch,
      };
    },
    created() {
      this.onSearch();
    }
  };
</script>
