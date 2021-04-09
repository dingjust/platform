<!--
* @Description: 成本单
* @Date 2021/02/24 17:52
* @Author L.G.Y
-->
<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <div class="cost-order-title">
          <h6>成本单</h6>
        </div>
      </el-row>
      <div class="pt-2"></div>
      <cost-order-toolbar @onAdvancedSearch="onAdvancedSearch" :queryFormData="queryFormData" />
      <el-tabs v-model="activeName" @tab-click="handleClick">
        <template v-for="item in statuses">
          <el-tab-pane :label="tabName(item)" :name="item.code" :key="item.code">
            <cost-order-list :page="page" @onAdvancedSearch="onAdvancedSearch"/>
          </el-tab-pane>
        </template>
      </el-tabs>
    </el-card> 
  </div>
</template>

<script>
import { createNamespacedHelpers } from 'vuex';

const { mapGetters, mapActions } = createNamespacedHelpers(
  'CostOrderModule'
);

import CostOrderList from './list/CostOrderList'
import CostOrderToolbar from './toolbar/CostOrderToolbar'

export default {
  name: 'CostOrderPage',
  components: {
    CostOrderList,
    CostOrderToolbar
  },
  data () {
    return {
      queryFormData: {
        keyword: '',
        statuses: ''
      },
      activeName: '',
      statuses: [{
        code: '',
        name: '全部'
      }].concat(this.$store.state.EnumsModule.CostOrderType),
      stateCount: {}
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
    onAdvancedSearch (page, size, isTabChange) {
      const query = this.queryFormData;
      const url = this.apis().searchCostOrder();
 
      this.searchAdvanced({url, query, page, size});
      if (!isTabChange) {
        this.searchCostOrderCout();
      }
    },
    async searchCostOrderCout() {
      let query = Object.assign({}, this.queryFormData);
      query.statuses = '';

      const url = this.apis().searchCostOrderCout();
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
      this.queryFormData.statuses = tab.name;
      this.onAdvancedSearch(0, 10, true);
    }
  },
  created () {
    this.onAdvancedSearch();
  }
}
</script>

<style scoped>
  .cost-order-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }
</style>