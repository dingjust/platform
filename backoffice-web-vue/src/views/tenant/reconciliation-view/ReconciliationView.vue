<!--
* @Description: 平台端查看所有对账单
* @Date 2021/08/19 14:15
* @Author L.G.Y
-->

<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <div class="orders-list-title">
          <h6>对账单列表</h6>
        </div>
      </el-row>
      <div class="pt-2"></div>
      <reconciliation-orders-toolbar-v2 :queryFormData="queryFormData" @onAdvancedSearch="onAdvancedSearch"/>
      <el-tabs v-model="activeName" @tab-click="handleClick">
        <template v-for="item in statuses">
          <el-tab-pane :label="item.name" :name="item.code" :key="item.code">
            <reconciliation-view-list :page="page" @onAdvancedSearch="onAdvancedSearch"/>
          </el-tab-pane>
        </template>
      </el-tabs>
    </el-card>
  </div>
</template>

<script>
import { createNamespacedHelpers } from 'vuex';

const {
  mapGetters,
  mapActions
} = createNamespacedHelpers(
  'ReconciliationOrdersV2Module'
);

import ReconciliationOrdersToolbarV2 from '@/views/order/delivery-recon/reconciliation/toolbar/ReconciliationOrdersToolbarV2'
import ReconciliationViewList from '@/views/tenant/reconciliation-view/list/ReconciliationViewList'

export default {
  name: 'ReconciliationView',
  components: { ReconciliationViewList, ReconciliationOrdersToolbarV2 },
  computed: {
    ...mapGetters({
      page: 'page',
      keyword: 'keyword'
    })
  },
  methods: {
    ...mapActions({
      searchAdvanced: 'searchAdvanced'
    }),
    onAdvancedSearch (page, size) {
      const query = this.queryFormData;
      const url = this.apis().searchReconciliation();
      this.searchAdvanced({
        url,
        query,
        page,
        size
      });
    },
    handleClick (tab, event) {
      this.queryFormData.states = tab.name;
      this.onAdvancedSearch(0, this.page.size);
    }
  },
  data () {
    return {
      activeName: '',
      statuses: [
        {
          code: '',
          name: '全部'
        }, {
          code: 'PENDING_A_SIGN',
          name: '待甲方签署'
        }, {
          code: 'PENDING_B_SIGN',
          name: '待乙方签署'
        }, {
          code: 'PENDING_APPROVAL',
          name: '待审批'
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
        cooperatorName: '',
        states: '',
        signState: '',
        // partyType: "PARTYA",
        createdDateFrom: '',
        createdDateTo: ''
      }
    }
  },
  created () {
    this.onAdvancedSearch(0, 10);
  }
}
</script>

<style scoped>

</style>