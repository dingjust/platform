<template>
  <div class="animated fadeIn content">
    <el-card>
      <factory-toolbar @onNew="onNew" @onSearch="onSearch"/>
      <factory-list :page="page" @onDetails="onDetails" @onSearch="onSearch"/>
    </el-card>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions} = createNamespacedHelpers('FactoriesModule');

  import FactoryToolbar from './toolbar/FactoryToolbar';
  import FactoryList from './list/FactoryList';
  import FactoryDetailsPage from './details/FactoryDetailsPage';

  export default {
    name: 'FactoryPage',
    components: {
      FactoryToolbar,
      FactoryList
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
        const url = this.apis().getFactories();
        this.search({url, keyword, page, size});
      },
      async onDetails(item) {
        const url = this.apis().getFactory(item.uid);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.fn.openSlider('品牌：' + item.name, FactoryDetailsPage, result);
      },
      onNew(formData) {
        this.fn.openSlider('创建品牌', FactoryDetailsPage, formData);
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
