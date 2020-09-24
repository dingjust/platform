<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="6">
          <div class="purchase-list-title">
            <h6>采购工单列表</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <purchase-worksheet-toolbar @onAdvancedSearch="onAdvancedSearch" 
                                    :queryFormData="queryFormData" :dataQuery="dataQuery"/>
      <div>
        <div class="tags-container">
          <el-button>未延期</el-button>
          <el-button>已延期</el-button>
        </div>
        <el-tabs v-model="activeName" @tab-click="handleClick">
          <template v-for="item in statuses">
            <el-tab-pane :label="tabName(item)" :name="item.code" :key="item.code">
              <purchase-worksheet-list :page="page" @onAdvancedSearch="onAdvancedSearch"/>
            </el-tab-pane>
          </template>
        </el-tabs>
      </div>
    </el-card>
  </div>
</template>

<script>
import { createNamespacedHelpers } from 'vuex';

const {
  mapGetters,
  mapActions,
  mapMutations
} = createNamespacedHelpers(
  'PurchaseWorksheetModule'
);

import PurchaseWorksheetToolbar from './toolbar/PurchaseWorksheetToolbar'
import PurchaseWorksheetList from './list/PurchaseWorksheetList'

export default {
  name: 'PurchaseWorksheetPage',
  components: {
    PurchaseWorksheetToolbar,
    PurchaseWorksheetList
  },
  computed: {
    ...mapGetters({
      page: 'page',
    })
  },
  methods: {
    ...mapActions({
      searchAdvanced: 'searchAdvanced'
    }),
    onAdvancedSearch(page, size, isTab) {
      // if (this.queryFormData.users.length <= 0 && this.queryFormData.depts.length <= 0) {
      //   this.onResetQuery();
      // }
      const query = this.queryFormData;
      const url = this.apis().getPurchaseWorkOrder();
      this.searchAdvanced({
        url,
        query,
        page,
        size
      });

      // 切换tab页不再重新查询统计接口
      if (!isTab) {
        this.getPurchaseWorksheetCount();
      }
    },
    async getPurchaseWorksheetCount() {
      const url = this.apis().getPurchaseWorksheetCount();
      const result = await this.$http.post(url, this.queryFormData);
      if (result['errors']) {
        this.stateCount = {};
        this.$message.error(result['errors'][0].message);
        return;
      }
      if (result.code === 0) {
        this.stateCount = {};
        this.$message.error(result.msg);
        return;
      }
      this.stateCount = result.data;
    },
    tabName(tab) {
      if (this.stateCount.hasOwnProperty(tab.code)) {
        return tab.name + '(' + this.stateCount[tab.code] + ')';
      }
      return tab.name;
    },
    handleClick (tab, event) {
      this.queryFormData.state = tab.name;
      this.onAdvancedSearch(0, 10, true);
    },
    // onResetQuery () {
    //   this.queryFormData = JSON.parse(JSON.stringify(Object.assign(this.queryFormData, this.dataQuery)));
    // }
  },
  data () {
    return {
      queryFormData: {
        keyword: '',
        operatorName: '',
        state: 'WAIT_TO_PURCHASE'
      },
      dataQuery: {},
      activeName: 'WAIT_TO_PURCHASE',
      statuses: [{
          code: 'WAIT_TO_PURCHASE',
          name: '待采购'  
        }, {
          code: 'WAIT_TO_RECYCLE_MATERIAL',
          name: '待回料'
        }, {
          code: 'COMPLETE',
          name: '采购完成'
        }, {
          code: '',
          name: '全部'
      }],
      stateCount: {}
    }
  },
  created () {
    // this.dataQuery = this.getDataPerQuery('PURCHASE_WORKSHEET');
    // this.onResetQuery();
    this.onAdvancedSearch(0, 10);
  }
}
</script>

<style scoped>
  .purchase-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .tags-container {
    position: absolute;
    right: 20px;    
    z-index: 999;
  }
</style>