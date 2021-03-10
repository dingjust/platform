<!--
* @Description: 活动 -> 积分记录列表
* @Date 2021/03/09 16:58
* @Author L.G.Y
-->
<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <div class="activity-title">
          <h6>积分记录</h6>
        </div>
      </el-row>
      <div class="pt-2"></div>
      <points-record-toolbar @onAdvancedSearch="onAdvancedSearch" :queryFormData="queryFormData" />
      <points-record-list :page="page" @onAdvancedSearch="onAdvancedSearch"/>
    </el-card>
  </div>
</template>

<script>
import { createNamespacedHelpers } from 'vuex';

const { mapGetters, mapActions } = createNamespacedHelpers(
  'PointsRecordModule'
);

import PointsRecordToolbar from './toolbar/PointsRecordToolbar'
import PointsRecordList from './list/PointsRecordList'

export default {
  name: 'PointsRecordPage',
  components: { 
    PointsRecordToolbar,
    PointsRecordList 
  },
  data () {
    return {
      queryFormData: {
        keyword: ''
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
      const url = this.apis().searchPointsRecord();

      this.searchAdvanced({url, query, page, size});
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