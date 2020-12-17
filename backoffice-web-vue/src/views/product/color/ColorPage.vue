<template>
  <div class="animated fadeIn content">
    <el-dialog :visible.sync="colorDetailsPageVisible" width="80%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <color-details-page v-if="colorDetailsPageVisible" :slot-data="itemData"
                          @colorDetailsPageVisibleTurn="colorDetailsPageVisibleTurn"
                          @_updateColor="_updateColor"/>
    </el-dialog>
    <el-card>
      <el-row>
        <el-col :span="2">
          <div class="color-list-title">
            <h6>颜色列表</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <color-toolbar @onNew="onNew" @onSearch="onSearch"/>
      <!--      <el-tabs v-model="activeName" @tab-click="handleTabClick">-->
      <!--        <el-tab-pane v-for="status of statuses" :key="status.code" :label="status.name" :name="status.code">-->
      <el-tabs v-model="activeStatus" @tab-click="handleClick">
        <el-tab-pane v-for="status of statuses" :key="status.code" :label="status.name" :name="status.code">
          <color-list :page="page" @onDetails="onDetails" @onSearch="onSearch" @changeActive="changeActive"/>
        </el-tab-pane>
      </el-tabs>
<!--      <color-list :page="page" @onDetails="onDetails" @onSearch="onSearch" @changeActive="changeActive"/>-->
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
        const url = this.apis().getColorsSearch();
        this.search({url, keyword, page, size});
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
      },
      async _updateColor (slotData) {
        let formData = slotData;

        const url = this.apis().updateColor(formData.code);
        const result = await this.$http.put(url, formData);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.$message.success('修改成功');
        // this.$set(this.slotData, 'code', result);
        // this.refresh(this.apis().getColors());
        // this.fn.closeSlider(true);
        this.onSearch(this.page.number);
        this.colorDetailsPageVisible = false;
      },
      changeActive (row) {
        const formData = {
          id: row.id,
          code: row.code,
          name: row.name,
          active: !row.active,
          customize: row.customize
        }
        this._updateColor(formData);
      },
      handleClick (tab, event) {
        if (tab.name === '') {
          this.queryFormData.active = null;
        } else {
          this.queryFormData.active = tab.label == '启用';
        }
        this.onSearch();
      }
    },
    data () {
      return {
        itemData: '',
        colorDetailsPageVisible: false,
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
  .color-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }
</style>
