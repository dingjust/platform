<!-- 
 * @description: 订单对账任务
 * @fileName: ImportReconciliationTasksPage.vue 
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
            <h6>对账单看板</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <reconciliation-tasks-page :page="page" :queryFormData="queryFormData" :canCreate="false" @onCreate="onCreate" mode='import'
        @onSearch="onSearch" @onAdvancedSearch="onAdvancedSearch" />
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
    'ImportReconciliationModule'
  );

  import ReconciliationTasksPage from '../../reconciliation-task/ReconciliationTasksPage'
  export default {
    name: 'ImportReconciliationTasksPage',
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
        // TODO 查询外发的收发任务
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
      onCreate() {
        // TODO 创建对账单
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
        }
      }
    },
    created() {
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
