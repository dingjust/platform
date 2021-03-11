<!--
* @Description: 活动 -> 积分申请列表
* @Date 2021/03/09 16:58
* @Author L.G.Y
-->
<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <div class="activity-title">
          <h6>积分申请</h6>
        </div>
      </el-row>
      <div class="pt-2"></div>
      <points-exchange-toolbar @onAdvancedSearch="onAdvancedSearch" :queryFormData="queryFormData" />
      <el-tabs v-model="activeName" @tab-click="handleClick">
        <template v-for="item in statuses">
          <el-tab-pane :label="item.name" :name="item.code" :key="item.code">
            <points-exchange-list :page="page" @onAdvancedSearch="onAdvancedSearch"/>
          </el-tab-pane>
        </template>
      </el-tabs>
    </el-card>
  </div>
</template>

<script>
import { createNamespacedHelpers } from 'vuex';

const { mapGetters, mapActions } = createNamespacedHelpers(
  'PointsExchangeModule'
);

import PointsExchangeToolbar from './toolbar/PointsExchangeToolbar'
import PointsExchangeList from './list/PointsExchangeList'

export default {
  name: 'PointsExchangePage',
  components: { 
    PointsExchangeToolbar,
    PointsExchangeList 
  },
  data () {
    return {
      activeName: '',
      statuses: [
        {
        code: '',
        name: '全部'
      }, {
        code: 'SUBMIT',
        name: '已提交'
      }, {
        code: 'APPROVED',
        name: '审核通过'
      }, {
        code: 'REJECT',
        name: '审核驳回'
      }],
      queryFormData: {
        keyword: '',
        state: ''
      }
    }
  },
  computed: {
    ...mapGetters({
      page: 'page'
    })
  },
  methods: {
    ...mapActions({
      searchAdvanced: 'searchAdvanced'
    }),
    onAdvancedSearch (page, size) {
      const query = this.queryFormData;
      const url = this.apis().searchPointsExchange();

      this.searchAdvanced({url, query, page, size});
    },
    handleClick (tab, event) {
      this.queryFormData.state = tab.name;
      this.onAdvancedSearch();
    }
  },
  created () {
    this.onAdvancedSearch();
  }
}
</script>

<style scoped>
  .activity-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }
</style>