<template>
  <div class="animated fadeIn content">
    <el-dialog :visible.sync="colorDetailsPageVisible" width="80%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <color-details-page v-if="colorDetailsPageVisible" :slot-data="itemData"
                          @colorDetailsPageVisibleTurn="colorDetailsPageVisibleTurn"
                          @onSearch="onSearchwithPage"/>
    </el-dialog>
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
      ColorDetailsPage,
      ColorToolbar,
      ColorList
    },
    computed: {
      ...mapGetters({
        page: 'page',
        keyword: 'keyword'
      })
    },
    methods: {
      ...mapActions({
        search: 'search'
      }),
      onSearch (page, size) {
        const keyword = this.keyword;
        const url = this.apis().getColorsSearch();
        this.search({url, keyword, page, size});
      },
      onSearchwithPage () {
        const number = this.page.number;
        this.onSearch(number);
      },
      async onDetails (item) {
        const url = this.apis().getColorSearch(item.code);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.itemData = Object.assign({}, result);
        this.colorDetailsPageVisible = true;
        // this.fn.openSlider('颜色：' + item.name, ColorDetailsPage, result);
      },
      onNew (formData) {
        this.itemData = Object.assign({}, formData);
        this.colorDetailsPageVisible = true;
        // this.fn.openSlider('创建颜色', ColorDetailsPage, formData);
      },
      colorDetailsPageVisibleTurn () {
        this.colorDetailsPageVisible = !this.colorDetailsPageVisible;
      }
    },
    data () {
      return {
        itemData: '',
        colorDetailsPageVisible: false,
        result: ''
      };
    },
    created () {
      this.onSearch();
    }
  };
</script>
