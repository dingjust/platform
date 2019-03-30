<template>
  <div class="animated fadeIn content">
    <el-card>
      <label-toolbar @onNew="onNew" @onSearch="onSearch"/>
      <label-list :page="page" @onDetails="onDetails" @onSearch="onSearch"/>
    </el-card>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions} = createNamespacedHelpers('LabelsModule');

  import LabelToolbar from './toolbar/LabelToolbar';
  import LabelList from './list/LabelList';
  import LabelDetailsPage from './details/LabelDetailsPage';

  export default {
    name: 'LabelPage',
    components: {
      LabelToolbar,
      LabelList
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
        const url = this.apis().getLabels();
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
