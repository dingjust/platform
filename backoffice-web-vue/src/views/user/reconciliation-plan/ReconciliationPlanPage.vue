<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row type="flex" justify="space-between">
        <el-col :span="6">
          <div class="node-list-title">
            <h6>对账方案列表</h6>
          </div>
        </el-col>
        <el-col :span="2">
<!--          <Authorized :permission="['PROGRESS_PLAN_OPERATE']">-->
            <el-button type="primary" class="toolbar-search_input" @click="createNode">创建对账方案</el-button>
<!--          </Authorized>-->
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <reconciliation-plan-toolbar :queryFormData="queryFormData" @onSearch="onSearch"/>
      <reconciliation-plan-list :page="page" @onSearch="onSearch"/>
    </el-card>
  </div>
</template>

<script>
  import ReconciliationPlanToolbar from './toolbar/ReconciliationPlanToolbar';
  import ReconciliationPlanList from './list/ReconciliationPlanList';
  export default {
    name: 'ReconciliationPlanPage',
    components: {ReconciliationPlanList, ReconciliationPlanToolbar},
    methods: {
      async onSearch (page, size) {
        const url = this.apis().getReconciliationPlan();
        const result = await this.$http.post(url, this.queryFormData, {
          page: page,
          size: size
        });
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.page = result;
      },
      createNode () {
        this.$router.push('/account/setting/reconciliation-plan/create');
      }
    },
    data () {
      return {
        queryFormData: {
          keyword: ''
        },
        page: {}
      }
    },
    created() {
      this.onSearch();
    }
  }
</script>

<style scoped>
  .node-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .toolbar-search_input {
    background-color: #ffd60c;
    border-color: #ffd60c;
  }
</style>
