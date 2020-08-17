<template>
  <div class="animated fadeIn">
    <el-card>
      <el-row type="flex" justify="space-between">
        <el-col :span="6">
          <div class="node-list-title">
            <h6>对账方案选择</h6>
          </div>
        </el-col>
        <el-col :span="2">
          <!--          <Authorized :permission="['PROGRESS_PLAN_OPERATE']">-->
          <el-button type="primary" class="toolbar-search_input" @click="createNode">创建对账方案</el-button>
          <!--          </Authorized>-->
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <el-row type="flex" justify="space-between">
        <reconciliation-plan-toolbar :queryFormData="queryFormData" @onSearch="onSearch" />
        <el-button class="submit-btn" @click="onSubmit">确定</el-button>
      </el-row>
      <el-table class="form-table" ref="resultTable" stripe :data="page.content" :height="autoHeight"
        highlight-current-row @current-change="handleCurrentChange">
        <el-table-column label="方案名称" prop="name"></el-table-column>
        <el-table-column label="创建时间" prop="creationtime">
          <template slot-scope="scope">
            <span> {{scope.row.creationtime | timestampToTime}}</span>
          </template>
        </el-table-column>
      </el-table>
      <div class="pt-2"></div>
      <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper"
        @size-change="onPageSizeChanged" @current-change="onCurrentPageChanged" :current-page="page.number + 1"
        :page-size="page.size" :page-count="page.totalPages" :total="page.totalElements">
      </el-pagination>
    </el-card>
  </div>
</template>

<script>
  import ReconciliationPlanToolbar from '../toolbar/ReconciliationPlanToolbar';
  import ReconciliationPlanList from '../list/ReconciliationPlanList';
  export default {
    name: 'ReconciliationPlanSelector',
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
      onPageSizeChanged(val) {
        this.onSearch(0, val)
      },
      onCurrentPageChanged(val) {
        this.onSearch(val, 10)
      },
      handleCurrentChange(val) {
        this.selectedData = val;
      },
      onSubmit() {
        if (this.selectedData != null && this.selectedData != '') {
          this.$emit('onSelect', this.selectedData);
        }
      }
    },
    data() {
      return {
        queryFormData: {
          keyword: '',
          isEnable: true
        },
        page: {},
        selectedData: '',
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

  .form-table>>>.current-row td {
    background-color: #FFD60C !important;
  }

  .submit-btn {
    background-color: #ffd60c;
    border-color: #ffd60c;
    height: 30px;
  }

</style>
