<template>
  <div class="animated fadeIn content">
    <el-card>
      <brand-toolbar @onNew="onNew" @onSearch="onSearch"/>
      <brand-list :page="page" @onDetails="onDetails" @onSearch="onSearch"/>
    </el-card>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions} = createNamespacedHelpers('BrandsModule');

  import BrandToolbar from './toolbar/BrandToolbar';
  import BrandList from './list/BrandList';
  import BrandDetailsPage from './details/BrandDetailsPage';

  export default {
    name: 'BrandPage',
    components: {
      BrandToolbar,
      BrandList
    },
    computed: {
      ...mapGetters({
        page: 'page',
        keyword: 'keyword',
      })
    },
    methods: {
      ...mapActions({
        search: 'search',
      }),
      onSearch(page, size) {
        const keyword = this.keyword;
        const url = this.apis().getBrands();
        this.search({url, keyword, page, size});
      },
      async onDetails(item) {
        const url = this.apis().getBrand(item.uid);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.fn.openSlider('品牌：' + item.name, BrandDetailsPage, result);
      },
      onNew(formData) {
        this.fn.openSlider('创建品牌', BrandDetailsPage, formData);
      },
    },
    data() {
      return {};
    },
    created() {
      this.onSearch();
    }
  };
</script>
