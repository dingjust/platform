<!--
* @Description: 平台端查看所有外接外发单列表
* @Date 2021/07/02 10:50
* @Author L.G.Y
-->
<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <div class="orders-list-title">
          <h6>订单列表</h6>
        </div>
      </el-row>
      <div class="pt-2"></div>
      <pend-out-view-toolbar :queryFormData="queryFormData" @onAdvancedSearch="onAdvancedSearch"/>
      <el-tabs v-model="activeName" @tab-click="handleClick">
        <template v-for="item in statuses">
          <el-tab-pane :label="item.name" :name="item.code" :key="item.code">
            <pend-out-view-list :page="page" @onAdvancedSearch="onAdvancedSearch" />
          </el-tab-pane>
        </template>
      </el-tabs>
    </el-card>
  </div>
</template>

<script>
import {
  createNamespacedHelpers
} from 'vuex';

const {
  mapGetters,
  mapActions,
} = createNamespacedHelpers(
  'PendOutOrderModule'
);

import PendOutViewToolbar from './toolbar/PendOutViewToolbar'
import PendOutViewList from './list/PendOutViewList'

export default {
  name: 'PendOutView',
  components: { PendOutViewToolbar, PendOutViewList },
  computed: {
    ...mapGetters({
      page: 'page',
      keyword: 'keyword',
      queryFormData: 'queryFormData'
    }),
  },
  methods: {
    ...mapActions({
      searchAdvanced: 'searchAdvanced'
    }), 
    onAdvancedSearch(page, size) {
      const query = this.queryFormData;

      const url = this.apis().searchPendOut();
      this.searchAdvanced({url, query, page, size});
    },
    handleClick(tab, event) {
      this.queryFormData.state = tab.name;
      this.onAdvancedSearch();
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
          code: 'TO_BE_SUBMITTED',
          name: '待提交'
        }, {
          code: 'AUDITING',
          name: '待审核'
        }, {
          code: 'AUDIT_REJECTED',
          name: '审核驳回'
        }, {
          code: 'TO_BE_ACCEPTED',
          name: '待接单'
        }, {
          code: 'AUDIT_PASSED',
          name: '生产中'
        }, {
          code: 'COMPLETED',
          name: '已完成'
        }, {
          code: 'CANCELED',
          name: '已取消'
        }
      ]
    }
  },
  created () {
    this.onAdvancedSearch();
  }
}
</script>

<style scoped>

</style>