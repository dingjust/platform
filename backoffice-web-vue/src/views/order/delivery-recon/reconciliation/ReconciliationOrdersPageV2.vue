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
        <el-tab-pane :label="item.name" :name="item.code" :key="item.code">
          <reconciliation-orders-list-v2 :page="page" @onAdvancedSearch="onAdvancedSearch"/>
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
      activeName: 'PENDING_B_SIGN',
      statuses: [
        {
          code: 'PENDING_B_SIGN',
          name: '待乙方签署'
        }, {
          code: 'PENDING_APPROVAL',
          name: '待审批'
        }, {
          code: 'PENDING_A_SIGN',
          name: '待甲方签署'
        }, {
          code: 'COMPLETED',
          name: '已完成'
        }, {
          code: 'CANCELLED',
          name: '已取消'
        }
      ],
      queryFormData: {
        keyword: '',
        cooperator: '',
        states: 'PENDING_B_SIGN',
        partyType: "PARTYA",
        expectedDeliveryDateFrom: '',
        expectedDeliveryDateTo: ''
      }
    }
  },
  methods: {
    ...mapActions({
      searchAdvanced: 'searchAdvanced'
    }),
    onAdvancedSearch (page, size) {
      const query = this.queryFormData;
      const url = this.apis().getReconciliationV2List();
      this.searchAdvanced({
        url,
        query,
        page,
        size
      });
    },
    handleClick (tab, event) {
      this.queryFormData.states = tab.name;
      this.onAdvancedSearch(0, 10);
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