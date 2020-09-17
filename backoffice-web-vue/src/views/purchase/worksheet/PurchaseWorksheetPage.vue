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
            <el-tab-pane :label="item.name" :name="item.code" :key="item.code">
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
    onAdvancedSearch(page, size) {
      if (this.queryFormData.users.length <= 0 && this.queryFormData.depts.length <= 0) {
        this.onResetQuery();
      }
      const query = this.queryFormData;
      const url = this.apis().getoutboundOrdersList();
      this.searchAdvanced({
        url,
        query,
        page,
        size
      });
    },
    handleClick (tab, event) {
      this.queryFormData.state = tab.name;
      this.onAdvancedSearch(0, 10);
    },
    onResetQuery () {
      this.queryFormData = JSON.parse(JSON.stringify(Object.assign(this.queryFormData, this.dataQuery)));
    }
  },
  data () {
    return {
      queryFormData: {
        keyword: '',
        operatorName: '',
        state: '1'
      },
      dataQuery: {},
      activeName: '1',
      statuses: [{
          code: '1',
          name: '待采购'
        }, {
          code: '2',
          name: '待回料'
        }, {
          code: 'COMPLETED',
          name: '采购完成'
        }, {
          code: '',
          name: '全部'
      }]
    }
  },
  created () {
    this.dataQuery = this.getDataPerQuery('PURCHASE_WORKSHEET');
    this.onResetQuery();
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