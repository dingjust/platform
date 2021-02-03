<!--
* @Description: 新对账单（出货对账）
* @Date 2020/11/23 14:09
* @Author L.G.Y
-->
<template>
  <div>
    <el-row>
      <div class="list-title">
        <h6>对账单列表</h6>
      </div>
    </el-row>
    <div class="pt-2"></div>
    <reconciliation-orders-toolbar-v2 :queryFormData="queryFormData" @onAdvancedSearch="onAdvancedSearch"/>
    <el-tabs v-model="activeName" @tab-click="handleClick">
      <template v-for="item in statuses">
        <el-tab-pane :label="tabName(item)" :name="item.code" :key="item.code">
          <reconciliation-orders-list-v2 :page="page" :activeName="activeName" @onAdvancedSearch="onAdvancedSearch"/>
        </el-tab-pane>
      </template>
    </el-tabs>
  </div>
</template>
 
<script>
import { createNamespacedHelpers } from 'vuex';

const {
  mapGetters,
  mapActions,
  mapMutations
} = createNamespacedHelpers(
  'ReconciliationOrdersV2Module'
);

import ReconciliationOrdersListV2 from './list/ReconciliationOrdersListV2'
import ReconciliationOrdersToolbarV2 from './toolbar/ReconciliationOrdersToolbarV2'
export default {
  name: 'ReconciliationOrdersPageV2',
  components: {
    ReconciliationOrdersListV2,
    ReconciliationOrdersToolbarV2
  },
  computed: {
    ...mapGetters({
      page: 'page',
      keyword: 'keyword'
    })
  },
  data () {
    return {
      activeName: 'WAIT_ME_SIGN',
      statuses: [
        {
          code: 'WAIT_ME_SIGN',
          name: '待我签署'
        }, {
          code: 'WAIT_PARTNER_SIGN',
          name: '待对方签署'
        }, {
          code: 'PENDING_APPROVAL',
          name: '待审批'
        }, {
          code: 'COMPLETED',
          name: '已完成'
        }, {
          code: 'CANCELLED',
          name: '已取消'
        }, {
          code: '',
          name: '全部'
        }
      ],
      queryFormData: {
        keyword: '',
        cooperatorName: '',
        states: '',
        signState: 'WAIT_ME_SIGN',
        // partyType: "PARTYA",
        createdDateFrom: '',
        createdDateTo: ''
      },
      stateCount: {},
    }
  },
  methods: {
    ...mapActions({
      searchAdvanced: 'searchAdvanced'
    }),
    onAdvancedSearch (page, size, isTabChange) {
      const query = this.queryFormData;
      const url = this.apis().getReconciliationV2List();
      this.searchAdvanced({
        url,
        query,
        page,
        size
      });

      // 获取统计信息
      if (!isTabChange) {
        this.getReconciliationV2ListCount();
      }
    },
    async getReconciliationV2ListCount () {
      let query = Object.assign({}, this.queryFormData);
      query.states = '';
      query.signState = '';

      const url = this.apis().getReconciliationV2ListCount();
      const result = await this.$http.post(url, query);
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
      if (tab.name === 'WAIT_ME_SIGN' || tab.name === 'WAIT_PARTNER_SIGN') {
        this.queryFormData.states = '';
        this.queryFormData.signState = tab.name;
      } else {
        this.queryFormData.states = tab.name === '全部' ? '' : tab.name;
        this.queryFormData.signState = '';
      }

      this.onAdvancedSearch(0, 10, true);
    }
  },
  created () {
    this.onAdvancedSearch(0, 10);
  }
}
</script>

<style>
  .list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }
</style>