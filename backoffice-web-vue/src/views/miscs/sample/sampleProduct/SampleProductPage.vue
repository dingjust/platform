<template>
  <div class="animated fadeIn content">
    <el-card>
      <sample-product-toolbar @onSearch="onSearch" @onNew="onNew"/>
      <sample-product-search-result-list :page="page" @onDetails="onDetails"/>
    </el-card>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions} = createNamespacedHelpers('SampleProductModule');

  import SampleProductToolbar from './toolbar/SampleProductToolbar';
  import SampleProductSearchResultList from './list/SampleProductSearchResultList';
  import SampleProductDetailsPage from "./details/SampleProductDetailsPage";
  import SampleProductForm from './form/SampleProductForm';

  export default {
    name: 'SampleProductPage',
    components: {
      SampleProductToolbar,
      SampleProductSearchResultList
    },
    computed: {
      ...mapGetters({
        keyword: 'keyword',
        page: 'page'
      })
    },
    methods: {
      ...mapActions({
        search: 'search',
      }),
      onSearch(page, size) {
        const keyword = this.keyword;
        const url = this.apis().getSampleProducts();
        this.search({url, keyword, page, size});
      },
      onNew(formData) {
        this.fn.openSlider('新建', SampleProductForm, formData);
      },
      onDetails(formData) {
        this.fn.openSlider('明细:' + formData.code, SampleProductDetailsPage, formData);
      },
    },
    data() {
      return {}
    },
    created() {
      this.onSearch();
    }
  }
</script>
