<template>
  <div class="animated fadeIn content">
    <el-card>
      <seal-toolbar  @onSearch="onSearch" class="seal-toolbar"/>
      <seal-list :page="page" @onDetails="onDetails" @onSearch="onSearch"/>
    </el-card>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';
  const {mapGetters, mapActions} = createNamespacedHelpers('ContractSealModule');

  import SealList from './list/SealSearchResultList';
  import SealToolbar from './toolbar/SealToolbar';


  export default {
    name: 'SealPage',
    components: {
      SealList,
      SealToolbar
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
        const url = this.apis().getSealsList();
        this.search({url, keyword, page, size});
      },
      async onDetails(item) {
        const url = this.apis().getLabel(item.id);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.fn.openSlider('明细：' + item.name, LabelDetailsPage, result);
      },
      onNew(formData) {
        this.fn.openSlider('创建', LabelDetailsPage, formData);
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
<style>
.seal-toolbar{
  margin-bottom: 10px;
}
</style>
