<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="4">
          <div class="application-list-title">
            <h6>第三方应用管理</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <application-management-toolbar :queryFormData="queryFormData" @onAdvancedSearch="onAdvancedSearch"/>
      <application-management-list :page="page" @onAdvancedSearch="onAdvancedSearch"/>
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
  mapMutations
} = createNamespacedHelpers(
  'ApplicationModule'
);

import ApplicationManagementToolbar from './toolbar/ApplicationManagementToolbar'
import ApplicationManagementList from './list/ApplicationManagementList'
export default {
  name: 'ApplicationManagement',
  components: {
    ApplicationManagementToolbar,
    ApplicationManagementList
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
      const url = this.apis().getApplicationList();
      this.searchAdvanced({
        url,
        query,
        page,
        size
      });
    },
  },
  data () {
    return {
      queryFormData: {
        keyword: ''
      }
    }
  },
  created () {
    this.onAdvancedSearch(0, 10);
  }
}
</script>

<style scoped>
  .application-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }
</style>