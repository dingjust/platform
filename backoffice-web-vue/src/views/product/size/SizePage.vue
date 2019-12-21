<template>
  <div class="animated fadeIn content">
    <el-dialog :visible.sync="sizeDetailsPageVisible" width="80%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <size-details-page v-if="sizeDetailsPageVisible" :slot-data="itemData"
                         @sizeDetailsPageVisibleTurn="sizeDetailsPageVisibleTurn"
                          @onSearch="onSearch"/>
    </el-dialog>
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
      SizeDetailsPage,
      SizeToolbar,
      SizeList
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
        const url = this.apis().getSizesSearch();
        this.search({url, keyword, page, size});
      },
      async onDetails (item) {
        const url = this.apis().getSizeSearch(item.code);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.itemData = Object.assign({}, result);
        this.sizeDetailsPageVisible = !this.sizeDetailsPageVisible;
        // this.fn.openSlider('尺码：' + item.name, SizeDetailsPage, result);
      },
      onNew (formData) {
        this.itemData = Object.assign({}, formData);
        this.sizeDetailsPageVisible = !this.sizeDetailsPageVisible;
        // this.fn.openSlider('创建尺码', SizeDetailsPage, formData);
      },
      sizeDetailsPageVisibleTurn () {
        this.sizeDetailsPageVisible = !this.sizeDetailsPageVisible;
      }
    },
    data () {
      return {
        sizeDetailsPageVisible: false,
        itemData: '',
        result: ''
      };
    },
    created () {
      this.onSearch();
    }
  };
</script>
