<!--
* @Description: 代运营审阅
* @Date 2021/05/22 15:11
* @Author L.G.Y
-->
<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <div class="orders-list-title">
          <h6>代运营审阅</h6>
        </div>
      </el-row>
      <div class="pt-2"></div>
      <agent-operation-toolbar :queryFormData="queryFormData" @onAdvancedSearch="onAdvancedSearch"/>
      <el-tabs v-model="activeName" @tab-click="handleClick">
        <el-tab-pane v-for="item in statuses" :label="item.name" :name="item.code" :key="item.code">
          <agent-operation-list :page="page" @onAdvancedSearch="onAdvancedSearch"/>
        </el-tab-pane>
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
  mapActions
} = createNamespacedHelpers(
  'AgentOperationModule'
);

import AgentOperationList from './list/AgentOperationList'
import AgentOperationToolbar from './toolbar/AgentOperationToolbar'

export default {
  name: 'AgentOperationReview',
  components: { AgentOperationToolbar, AgentOperationList },
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

      const url = this.apis().searchAgentOperationReview();
      this.searchAdvanced({url, query, page, size});
    },
    handleClick(tab, event) {
      this.queryFormData.statuses = tab.name;
      this.onAdvancedSearch(0, this.page.size);
    },
  },
  data () {
    return {
      activeName: 'REVIEWING',
      queryFormData: {
        keyword: '',
        statuses: 'REVIEWING'
      },
      statuses: [    
        {
          code: 'REVIEWING',
          name: '审核中'
        },
        {
          code: 'REVIEW_PASSED',
          name: '审核通过'
        },
        {
          code: 'REVIEW_REJECTED',
          name: '审核失败'
        },
        {
          code: 'COMPLETED',
          name: '已签署'
        },
        {
          code: '',
          name: '全部'
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