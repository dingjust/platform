<!-- 
 * @description: 对账任务
 * @fileName: ReconciliationTasksPage.vue 
 * @author: yj 
 * @date: 2020-06-22 15:09:48
 * @version: V1.0.0 
!-->
<template>
  <div>
    <reconciliation-tasks-toolbar :queryFormData="queryFormData" :canCreate="canCreate"
      @onAdvancedSearch="onAdvancedSearch" @onCreate="onCreate" />
    <el-tabs v-model="activeName" @tab-click="handleClick">
      <template v-for="item in statuses">
        <el-tab-pane :label="item.name" :name="item.code" :key="item.code">
          <reconciliation-tasks-list :page="page" @onAdvancedSearch="onAdvancedSearch" @onDetail="onDetail" />
        </el-tab-pane>
      </template>
    </el-tabs>
  </div>
</template>

<script>
  /**
   * @param {Object} [page]     - 列表数据，必传
   * @param {Object} [queryFormData]     - 查询表单对象，必传
   */
  import ReconciliationTasksToolbar from './toolbar/ReconciliationTasksToolbar'
  import ReconciliationTasksList from './list/ReconciliationTasksList'
  export default {
    name: 'ReconciliationTasksPage',
    props: {
      page: {
        type: Object,
        required: true
      },
      queryFormData: {
        type: Object,
        required: true
      },
      canCreate: {
        type: Boolean,
        default: false
      }
    },
    components: {
      ReconciliationTasksToolbar,
      ReconciliationTasksList
    },
    computed: {},
    methods: {
      onAdvancedSearch(page, size) {
        this.$emit('onAdvancedSearch');
      },
      handleClick(tab, event) {
        this.queryFormData.states = tab.name;
        this.$emit('onAdvancedSearch');
      },
      onCreate() {
        this.$router.push('/reconciliation/create/orders');
      },
      onDetail(row) {
        this.$router.push('/reconciliation/tasks/detail/' + row.id);
      },
    },
    data() {
      return {
        activeName: 'PENDING_RECONCILIATION',
        statuses: [{
          code: 'PENDING_RECONCILIATION',
          name: '待对账'
        }, {
          code: 'IN_RECONCILIATION',
          name: '对账中'
        }, {
          code: 'COMPLETED',
          name: '已完成'
        }, ]
      }
    },
    created() {},
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
