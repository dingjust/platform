<template>
  <div class="animated fadeIn content">
    <el-card>
      <industrial-cluster-toolbar @onNew="onNew" @onSearch="onSearch"/>
      <industrial-cluster-list :page="page" @onDetails="onDetails" @onSearch="onSearch"/>
    </el-card>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions} = createNamespacedHelpers('IndustrialClustersModule');

  import IndustrialClusterToolbar from './toolbar/IndustrialClusterToolbar';
  import IndustrialClusterList from './list/IndustrialClusterList';
  import IndustrialClusterDetailsPage from './details/IndustrialClusterDetailsPage';

  export default {
    name: 'IndustrialClusterPage',
    components: {
      IndustrialClusterToolbar,
      IndustrialClusterList
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
        const url = this.apis().getIndustrialClusters();
        this.search({url, keyword, page, size});
      },
      async onDetails(item) {
        const url = this.apis().getIndustrialCluster(item.code);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.fn.openSlider('员工：' + item.name, IndustrialClusterDetailsPage, result);
      },
      onNew(formData) {
        this.fn.openSlider('创建员工', IndustrialClusterDetailsPage, formData);
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
