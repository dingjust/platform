<!--
* @Description: 物流管理
* @Date 2021/11/25 14:01
* @Author L.G.Y
-->
<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <div class="orders-list-title">
          <h6>物流单号管理</h6>
        </div>
      </el-row>
      <div class="pt-2"></div>
      <logistics-toolbar @onAdvancedSearch="onAdvancedSearch" />
      <logistics-list :page="page" @onAdvancedSearch="onAdvancedSearch" />
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
  'LogisticsModule'
);

import LogisticsToolbar from './toolbar/LogisticsToolbar'
import LogisticsList from './list/LogisticsList'

export default {
  name: 'LogisticsPage',
  components: { LogisticsToolbar, LogisticsList },
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
      const query = {};

      const url = this.apis().searchLogistics();
      this.searchAdvanced({url, query, page, size});
    },
  },
  data () {
    return {

    }
  },
  created () {
    this.onAdvancedSearch();
  }
}
</script>

<style>

</style>