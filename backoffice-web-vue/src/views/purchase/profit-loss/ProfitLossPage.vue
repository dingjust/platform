<!--
* @Description: 报价单（根据成本单创建
* @Date 2021/03/16 15:18
* @Author L.G.Y
-->
<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <div class="cost-order-title">
          <h6>盈亏分析</h6>
        </div>
      </el-row>
      <div class="pt-2"></div>
      <profit-loss-toolbar @onAdvancedSearch="onAdvancedSearch" :queryFormData="queryFormData" />
      <profit-loss-list :page="page" @onAdvancedSearch="onAdvancedSearch"/>
    </el-card> 
  </div>
</template>

<script>
import { createNamespacedHelpers } from 'vuex';

const { mapGetters, mapActions } = createNamespacedHelpers(
  'ProfitLossModule'
);

import ProfitLossList from './list/ProfitLossList'
import ProfitLossToolbar from './toolbar/ProfitLossToolbar'

export default {
  name: 'ProfitLossPage',
  components: {
    ProfitLossList,
    ProfitLossToolbar
  },
  data () {
    return {
      queryFormData: {
        keyword: '',
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
      const url = this.apis().searchProfitLoss();
 
      this.searchAdvanced({url, query, page, size});
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