<template>
  <div>
    <purchase-order-toolbar @onAdvancedSearch="onAdvancedSearch" @onResetQuery="onResetQuery"
                            :queryFormData="queryFormData" :dataQuery="dataQuery"/>
    <div>
      <el-tabs v-model="activeName" @tab-click="handleClick">
        <template v-for="item in statuses">
          <el-tab-pane :label="tabName(item)" :name="item.code" :key="item.code">
            <purchase-order-list :page="page" @onAdvancedSearch="onAdvancedSearch" :isSelect="true"
                                  @setPurchaseOrder="setPurchaseOrder"/>
          </el-tab-pane>
        </template>
      </el-tabs>
    </div>
  </div>
</template>

<script>
import { createNamespacedHelpers } from 'vuex';

const {
  mapGetters,
  mapActions,
  mapMutations
} = createNamespacedHelpers(
  'PurchaseOrderModule'
);

import PurchaseOrderToolbar from '../toolbar/PurchaseOrderToolbar'
import PurchaseOrderList from '../list/PurchaseOrderList'

export default {
  name: 'PurchaseOrderSelectPage',
  components: {
    PurchaseOrderToolbar,
    PurchaseOrderList
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
      if (this.queryFormData.users.length <= 0 && this.queryFormData.depts.length <= 0) {
        this.onResetQuery();
      }
      const query = this.queryFormData;
      const url = this.apis().searchPurchaseOrder();
      this.searchAdvanced({
        url,
        query,
        page,
        size
      });

      // 切换tab页不再重新查询统计接口
      if (!isTab) {
        this.getPurchaseOrderCount();
      }
    },
    async getPurchaseOrderCount() {
      const url = this.apis().getPurchaseOrderCount();
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
    setPurchaseOrder (val) {
      this.$emit('setPurchaseOrder', val);
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
        state: 'WAIT_TO_REV_MATERIALS'
      },
      dataQuery: {},
      activeName: 'WAIT_TO_REV_MATERIALS',
      statuses: [{
          code: 'WAIT_TO_REV_MATERIALS',
          name: '待回料'
        }, {
          code: 'COMPLETED',
          name: '已完成'
        }
      ],
      stateCount: {}
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