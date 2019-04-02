<template>
  <div class="animated fadeIn content">
    <el-card>
      <sample-checkout-hist-toolbar @onSearch="onSearch" @onNew="onNew" @onAdvancedSearch="onAdvancedSearch"/>
      <sample-checkout-hist-search-result-list :page="page" @onDetails="onDetails" />
    </el-card>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions} = createNamespacedHelpers('SampleCheckoutHistModule');

  import SampleCheckoutHistToolbar from './toolbar/SampleCheckoutHistToolbar';
  import SampleCheckoutHistSearchResultList from './list/SampleCheckoutHistSearchResultList';
  import SampleCheckoutHistDetailsPage from "./details/SampleCheckoutHistDetailsPage";
  import SampleCheckoutHistForm from './form/SampleCheckoutHistForm';

  export default {
    name: 'SampleCheckoutHistPage',
    components: {
      SampleCheckoutHistToolbar,
      SampleCheckoutHistSearchResultList
    },
    computed: {
      ...mapGetters({
        keyword: 'keyword',
        page: 'page',
        queryFormData: 'queryFormData',
      })
    },
    methods: {
      ...mapActions({
        search: 'search',
        searchAdvanced: 'searchAdvanced'
      }),
      onSearch(page, size) {
        const keyword = this.keyword;
        const url = this.apis().getSampleCheckoutHists();
        this.search({url, keyword, page, size});
      },
      onAdvancedSearch(page, size) {
        const query = this.queryFormData;
        const url = this.apis().getAdvanceSampleCheckoutHists();
        this.searchAdvanced({url, query, page, size});
      },
      async onDetails(row) {
        console.log(row);
        const url = this.apis().getSampleCheckoutHist(row.id);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.fn.openSlider('明细:' + row.code, SampleCheckoutHistDetailsPage, row);
      },
      onNew(formData) {
        this.fn.openSlider('新建', SampleCheckoutHistForm, formData);
      },
    },
    data() {
      return {
      }
    },
    created() {
      this.onSearch();
    }
  }
</script>
