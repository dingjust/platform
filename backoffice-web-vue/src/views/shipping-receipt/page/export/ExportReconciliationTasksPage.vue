<!-- 
 * @description: 外发对账任务
 * @fileName: ExportReconciliationTasksPage.vue 
 * @author: yj 
 * @date: 2020-06-22 15:09:48
 * @version: V1.0.0 
!-->
<template>
  <div class="animated fadeIn">
    <el-card>
      <el-row>
        <el-col :span="4">
          <div class="title">
            <h6>对账单任务</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <reconciliation-tasks-page :page="page" :queryFormData="queryFormData" :canCreate="true" mode='export'
                                  @onSearch="onSearch" @onAdvancedSearch="onAdvancedSearch" 
                                  :dataQuery="dataQuery" @onResetQuery="onResetQuery"/>
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
    'ExportReconciliationModule'
  );

  import ReconciliationTasksPage from '../../reconciliation-task/ReconciliationTasksPage'
  export default {
    name: 'ExportReconciliationTasksPage',
    props: {

    },
    components: {
      ReconciliationTasksPage
    },
    computed: {
      ...mapGetters({
        keyword: 'keyword',
        page: 'page',
        formData: 'formData'
      })
    },
    methods: {
      ...mapActions({
        search: 'search',
        searchAdvanced: 'searchAdvanced'
      }),
      onSearch(page, size) {
        // TODO 查询外发的收发任务
        const keyword = this.keyword;
        const url = this.apis().reconciliationTaskList();
        this.search({
          url,
          keyword,
          page,
          size
        });
      },
      onAdvancedSearch(page, size) {
        if (this.queryFormData.users.length <= 0 && this.queryFormData.depts.length <= 0) {
          this.onResetQuery();
        }
        
        const query = this.queryFormData;
        const url = this.apis().reconciliationTaskList();
        const companyCode = this.currentUser.companyCode;
        this.searchAdvanced({
          url,
          query,
          page,
          size,
          companyCode
        });
      },
      onResetQuery () {
        this.queryFormData = JSON.parse(JSON.stringify(Object.assign(this.queryFormData, this.dataQuery)));
      }
    },
    data() {
      return {
        currentUser: this.$store.getters.currentUser,
        queryFormData: {
          keyword: '',
          productionLeaderName: '',
          operatorName: '',
          creationtimeStart: '',
          creationtimeEnd: '',
          states: 'PENDING_RECONCILIATION'
        },
        dataQuery: {}
      }
    },
    created() {
      this.dataQuery = this.getDataPerQuery('RECONCILIATION_TASK_OUT');
      this.onResetQuery();
      this.onAdvancedSearch();
    },
    destroyed() {

    }
  }

</script>

<style scoped>
  .title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

</style>
