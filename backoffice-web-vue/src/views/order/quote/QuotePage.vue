<template>
  <div class="animated fadeIn content">
    <el-card>
      <quote-toolbar @onSearch="onSearch" @onAdvancedSearch="onAdvancedSearch"/>
      <quote-search-result-list :page="page"
                                @onDetails="onDetails"
                                @onSearch="onSearch"
                                @onAdvancedSearch="onAdvancedSearch"/>
    </el-card>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions} = createNamespacedHelpers('QuotesModule');

  import QuoteToolbar from './toolbar/QuoteToolbar';
  import QuoteSearchResultList from './list/QuoteSearchResultList';
  import QuoteDetailsPage from "./details/QuoteDetailsPage";

  export default {
    name: 'QuotePage',
    components: {
      QuoteToolbar,
      QuoteSearchResultList
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
      async onDetails(item) {
        const result = await this.$http.get('/b2b/orders/quote/' + item.code);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.fn.openSlider('报价单明细，单号：' + item.code, QuoteDetailsPage, result);
      },
    },
    data() {
      return {
        keyword: this.$store.state.QuotesModule.keyword,
        formData: this.$store.state.QuotesModule.formData,
        queryFormData: this.$store.state.QuotesModule.queryFormData,
        isAdvancedSearch: this.$store.state.QuotesModule.isAdvancedSearch,
      };
    },
    created() {
      this.onSearch();
    }
  };
</script>
