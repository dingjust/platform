<template>
  <div class="animated fadeIn content">
    <el-dialog :visible.sync="sizeDetailsPageVisible" width="80%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <size-details-page v-if="sizeDetailsPageVisible" :slot-data="itemData"
                         @sizeDetailsPageVisibleTurn="sizeDetailsPageVisibleTurn"
                         @_updateSize="_updateSize"/>
    </el-dialog>
    <el-card>
      <el-row>
        <el-col :span="2">
          <div class="size-list-title">
            <h6>尺码列表</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <size-toolbar @onNew="onNew" @onSearch="onSearch"/>
      <el-tabs v-model="activeStatus" @tab-click="handleClick">
        <el-tab-pane v-for="status of statuses" :key="status.code" :label="status.name" :name="status.code">
          <size-list :page="page" @onDetails="onDetails" @onSearch="onSearch" @changeActive="changeActive"/>
        </el-tab-pane>
      </el-tabs>
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
        keyword: 'keyword',
        queryFormData: 'queryFormData'
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
      onSearchwithPage () {
        const number = this.page.number;
        this.onSearch(number);
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
      },
      async _updateSize (slotData) {
        let formData = slotData;

        const url = this.apis().updateSize(formData.code);
        const result = await this.$http.put(url, formData);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.$message.success('尺码修改成功');
        this.onSearch(this.page.number);
        this.sizeDetailsPageVisible = false;
        // this.$set(this.slotData, 'code', result);
        // this.refresh(this.apis().getSizes());
        // this.fn.closeSlider(true);
        // this.$emit('onSearch')
        // this.$emit('sizeDetailsPageVisibleTurn');
      },
      changeActive (row) {
        const formData = {
          id: row.id,
          code: row.code,
          name: row.name,
          active: !row.active,
          sequence: row.sequence
        }
        this._updateSize(formData);
      },
      handleClick (tab, event) {
        if (tab.name === '') {
          this.queryFormData.active = null;
        } else {
          console.log(tab);
          this.queryFormData.active = tab.label == '启用';
        }
        this.onSearch();
      }
    },
    data () {
      return {
        sizeDetailsPageVisible: false,
        itemData: '',
        result: '',
        activeStatus: '',
        statuses: [
          {
            code: '',
            name: '全部'
          },
          {
            code: 'true',
            name: '启用'
          },
          {
            code: 'false',
            name: '禁用'
          }
        ]
      };
    },
    created () {
      this.onSearch();
    }
  };
</script>
<style scoped>
  .size-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }
</style>
