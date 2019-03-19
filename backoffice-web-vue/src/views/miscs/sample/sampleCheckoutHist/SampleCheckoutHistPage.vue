<template>
  <div class="animated fadeIn content">
    <el-card>
      <sample-checkout-hist-toolbar @onSearch="onSearch" @onNew="onNew"/>
      <sample-checkout-hist-search-result-list :page="page" @onDetails="onDetails"/>
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
        page: 'page'
      })
    },
    methods: {
      ...mapActions({
        search: 'search',
        searchAdvanced: 'searchAdvanced',
      }),
      onSearch(keyword,page, size) {
        this.search({keyword, page, size});
      },
      onNew(formData) {
        this.fn.openSlider('创建样衣', SampleCheckoutHistForm, formData);
      },
      onDetails(row) {
        this.fn.openSlider('样衣明细:' + row.code, SampleCheckoutHistDetailsPage, row);
      },
    },
    data() {
      return {
        keyword: this.$store.state.SampleCheckoutHistModule.keyword,
        formData: this.$store.state.SampleCheckoutHistModule.formData,
      }
    },
    created() {
      this.search('');
    }
  }
</script>
