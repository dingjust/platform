<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row type="flex" justify="space-between">
        <el-col :span="6">
          <div class="node-list-title">
            <h6>节点方案列表</h6>
          </div>
        </el-col>
        <el-col :span="2">
          <Authorized :permission="['PROGRESS_PLAN_OPERATE']">
            <el-button type="primary" class="toolbar-search_input" @click="createNode">创建节点方案</el-button>
          </Authorized>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <progress-plan-toolbar :queryFormData="queryFormData" @onSearch="onSearch"/>
      <progress-plan-list :page="page" @onSearch="onSearch"/>
    </el-card>
  </div>
</template>

<script>
  import ProgressPlanToolbar from './toolbar/ProgressPlanToolbar';
  import ProgressPlanList from './list/ProgressPlanList';
  export default {
    name: 'ProgressPlanPage',
    components: {ProgressPlanList, ProgressPlanToolbar},
    methods: {
      async onSearch (page, size) {
        const url = this.apis().getProgressPlan();
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
        this.$router.push('/account/setting/progress-plan/create');
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
