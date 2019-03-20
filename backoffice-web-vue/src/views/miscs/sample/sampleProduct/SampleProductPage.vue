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
        this.fn.openSlider('创建样衣', SampleProductForm, formData);
      },
      onDetails(row) {
        this.fn.openSlider('样衣明细:'+row.code, SampleProductDetailsPage, row);
      },
    },
    data() {
      return {
        keyword: this.$store.state.SampleProductModule.keyword,
        formData: this.$store.state.SampleProductModule.formData,
      }
    },
    created() {
      this.search('');
    }
  }
</script>
