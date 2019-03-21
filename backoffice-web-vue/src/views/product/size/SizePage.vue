<template>
  <div class="animated fadeIn content">
    <el-card>
      <size-toolbar @onNew="onNew" @onSearch="onSearch"/>
      <size-list :page="page" @onDetails="onDetails" @onSearch="onSearch"/>
    </el-card>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions} = createNamespacedHelpers('SizesModule');

  import SizeToolbar from './toolbar/SizeToolbar';
  import SizeList from './list/SizeList';
  import SizeDetailsPage from './details/SizeDetailsPage';

  export default {
    name: 'SizePage',
    components: {
      SizeToolbar,
      SizeList
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
        const url = this.apis().getSizes();
        this.search({url, keyword, page, size});
      },
      async onDetails(item) {
        const url = this.apis().getSize(item.code);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.fn.openSlider('尺码：' + item.name, SizeDetailsPage, result);
      },
      onNew(formData) {
        this.fn.openSlider('创建尺码', SizeDetailsPage, formData);
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
