<template>
  <div class="animated fadeIn content">
    <el-card>
      <category-toolbar @onNew="onNew" @onSearch="onSearch"/>
      <category-list :page="page" @onDetails="onDetails" @onSearch="onSearch"/>
    </el-card>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions} = createNamespacedHelpers('CategoriesModule');

  import CategoryToolbar from './toolbar/CategoryToolbar';
  import CategoryList from './list/CategoryList';
  import CategoryDetailsPage from './details/CategoryDetailsPage';

  export default {
    name: 'CategoryPage',
    components: {
      CategoryToolbar,
      CategoryList
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
        const url = this.apis().getCategorys();
        this.search({url, keyword, page, size});
      },
      async onDetails(item) {
        const url = this.apis().getCategory(item.uid);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.fn.openSlider('员工：' + item.name, CategoryDetailsPage, result);
      },
      onNew(formData) {
        this.fn.openSlider('创建员工', CategoryDetailsPage, formData);
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
