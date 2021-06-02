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
      <agent-operation-list :page="page" @onAdvancedSearch="onAdvancedSearch"/>
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
    }
  },
  data () {
    return {
      queryFormData: {
        keyword: ''
      }
    }
  },
  created () {
    this.onAdvancedSearch();
  }
}
</script>

<style scoped>
</style>