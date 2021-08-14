<!--
* @Description: 托管
* @Date 2021/08/13 16:13
* @Author L.G.Y
-->
<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <div class="orders-list-title">
          <h6>托管申请列表</h6>
        </div>
      </el-row>
      <div class="pt-2"></div>
      <trusteeship-toolbar :queryFormData="queryFormData" @onAdvancedSearch="onAdvancedSearch" />
      <el-tabs v-model="activeName" @tab-click="handleTabClick">
        <el-tab-pane v-for="status of statuses" :key="status.code" :label="status.name" :name="status.code">
          <trusteeship-list :page="page" @onAdvancedSearch="onAdvancedSearch"/>
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
  'TrusteeshipModule'
);

import TrusteeshipList from './list/TrusteeshipList.vue';
import TrusteeshipToolbar from './toolbar/TrusteeshipToolbar.vue';

export default {
  name: 'TrusteeshipPage',
  components: { TrusteeshipList, TrusteeshipToolbar },
  computed: {
    ...mapGetters({
      page: 'page',
      queryFormData: 'queryFormData'
    }),
  },
  methods: {
    ...mapActions({
      searchAdvanced: 'searchAdvanced'
    }),
    onAdvancedSearch (page, size) {
      const query = this.queryFormData;

      const url = this.apis().searchTrusteeship();
      this.searchAdvanced({url, query, page, size});
    },
    handleTabClick(tab) {
      this.queryFormData.isProcessed = tab.name
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
        },
        {
          code: true,
          name: '已处理'
        }, 
        {
          code: false,
          name: '未处理'
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