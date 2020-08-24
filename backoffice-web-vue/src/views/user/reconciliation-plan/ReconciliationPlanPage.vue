<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row type="flex" justify="space-between">
        <el-col :span="6">
          <div class="node-list-title">
            <h6>对账方案列表</h6>
          </div>
        </el-col>
        <el-col :span="6">
          <el-row type="flex" justify="end">
            <!--          <Authorized :permission="['PROGRESS_PLAN_OPERATE']">-->
            <el-button type="text" @click="createNode">创建对账方案</el-button>
            <!--          </Authorized>-->
          </el-row>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <reconciliation-plan-toolbar :queryFormData="queryFormData" @onSearch="onSearch" />
      <el-row type="flex" justify="start">
        <template v-for="(item, index) in statuses">
          <el-button @click="handleClick(item.code, index)" :key="item.code" class="state-btn"
            :style="item.backgroundColor">
            {{item.name}}
          </el-button>
        </template>
      </el-row>
      <reconciliation-plan-list :page="page" @onSearch="onSearch" />
    </el-card>
  </div>
</template>

<script>
  import ReconciliationPlanToolbar from './toolbar/ReconciliationPlanToolbar';
  import ReconciliationPlanList from './list/ReconciliationPlanList';
  export default {
    name: 'ReconciliationPlanPage',
    components: {
      ReconciliationPlanList,
      ReconciliationPlanToolbar
    },
    methods: {
      async onSearch(page, size) {
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
      createNode() {
        this.$router.push('/account/setting/reconciliation-plan/create');
      },
      handleClick(code, index) {
        // eslint-disable-next-line no-return-assign
        this.statuses.forEach(item => item.backgroundColor = 'background-color: #FFFFFF');
        this.statuses[index].backgroundColor = 'background-color: #ffd60c';
        if (code === '') {
          this.$delete(this.queryFormData, 'isEnable');
        } else if (code === 'enabled') {
          this.$set(this.queryFormData, 'isEnable', true);
        } else if (code === 'forbidden') {
          this.$set(this.queryFormData, 'isEnable', false);
        }
        // this.queryFormData.state = code;
        this.onSearch(0, 10);
      },
    },
    data() {
      return {
        queryFormData: {
          keyword: ''
        },
        page: {},
        statuses: [{
          code: 'enabled',
          name: '启用',
          backgroundColor: 'background-color: #ffd60c'
        }, {
          code: 'forbidden',
          name: '禁用',
          backgroundColor: 'background-color: #FFFFFF'
        }, {
          code: '',
          name: '全部',
          backgroundColor: 'background-color: #FFFFFF'
        }]
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
