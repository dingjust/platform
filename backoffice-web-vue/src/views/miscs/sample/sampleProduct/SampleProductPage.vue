<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="2">
          <div class="sample-product-list-title1">
            <h6>样衣列表</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
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
      return {

      }
    },
    created() {
      this.onSearch();
    }
  }
</script>
<style scoped>
  .sample-product-list-title1 {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }
</style>
