<!--
* @Description: 出货单
* @Date 2020/11/23 17:55
* @Author L.G.Y
-->
<template>
  <div>
    <el-row>
      <div class="list-title">
        <h6>出货单列表</h6>
      </div>
    </el-row>
    <div class="pt-2"></div>
    <delivery-orders-toolbar :queryFormData="queryFormData" @onAdvancedSearch="onAdvancedSearch"/>
    <el-tabs v-model="activeName" @tab-click="handleClick">
      <template v-for="item in statuses">
        <el-tab-pane :label="item.name" :name="item.code" :key="item.code">
          <delivery-orders-list :page="page"/>
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
  'DeliveryOrdersModule'
);

import DeliveryOrdersList from './list/DeliveryOrdersList'
import DeliveryOrdersToolbar from './toolbar/DeliveryOrdersToolbar'

export default {
  name: 'DeliveryOrdersPageV2',
  components: {
    DeliveryOrdersList,
    DeliveryOrdersToolbar
  },
  computed: {
    ...mapGetters({
      page: 'page',
      keyword: 'keyword'
    })
  },
  data () {
    return {
      activeName: 'PENDING_RECONCILED',
      statuses: [
        {
          code: 'PENDING_RECONCILED',
          name: '待对账',
        },
        {
          code: 'IN_RECONCILED',
          name: '对账中',
        },
        {
          code: 'COMPLETED',
          name: '已完成',
        },
      ],
      queryFormData: {
        keyword: '',
        cooperator: '',
        status: '',
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
      const url = this.apis().getoutboundOrdersList();
      this.searchAdvanced({
        url,
        query,
        page,
        size
      });
    },
    handleClick (tab, event) {
      this.queryFormData.status = tab.name;
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