<template>
  <div class="animated fadeIn content">
    <el-card>
      <color-toolbar @onNew="onNew" @onSearch="onSearch"/>
      <color-list :page="page" @onDetails="onDetails" @onSearch="onSearch"/>
    </el-card>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions} = createNamespacedHelpers('ColorsModule');

  import ColorToolbar from './toolbar/ColorToolbar';
  import ColorList from './list/ColorList';
  import ColorDetailsPage from './details/ColorDetailsPage';

  export default {
    name: 'ColorPage',
    components: {
      ColorToolbar,
      ColorList
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
        const url = this.apis().getColors();
        this.search({url, keyword, page, size});
      },
      async onDetails(item) {
        const url = this.apis().getColor(item.code);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.fn.openSlider('颜色：' + item.name, ColorDetailsPage, result);
      },
      onNew(formData) {
        this.fn.openSlider('创建颜色', ColorDetailsPage, formData);
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
