<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="4">
          <div class="approval-list-title">
            <h6>待我审批</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <el-tabs v-model="activeName" type="card" @tab-click="handleClick">
        <el-tab-pane label="订单任务" name="ORDER_TASK">
          <div class="tab-basic-row">
            <task-approval-toolbar :queryFormData="queryFormData"
                          @onReset="onReset" @onAdvancedSearch="onAdvancedSearch"/>
            <el-tabs v-model="activeStatus" @tab-click="handleClick">
              <template v-for="(item, index) in statuses">
                <el-tab-pane :name="item.code" :label="item.name">
                  <task-approval-list :page="page" @onAdvancedSearch="onAdvancedSearch"
                                      @onDetail="onDetail" @onApproval="onApproval"/>
                </el-tab-pane>
              </template>
            </el-tabs>
          </div>
        </el-tab-pane>
        <el-tab-pane label="采购任务" name="PURCHASE_TASK">
          <div class="tab-basic-row">
            <task-approval-toolbar :queryFormData="queryFormData"
                                   @onReset="onReset" @onAdvancedSearch="onAdvancedSearch"/>
            <el-tabs v-model="activeStatus" @tab-click="handleClick">
              <template v-for="(item, index) in statuses">
                <el-tab-pane :name="item.code" :label="item.name">
                  <task-approval-list :page="page" @onAdvancedSearch="onAdvancedSearch"
                                      @onDetail="onDetail" @onApproval="onApproval"/>
                </el-tab-pane>
              </template>
            </el-tabs>
          </div>
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
    'TaskApprovalModule'
  );

  import TaskApprovalToolbar from './toolbar/TaskApprovalToolbar';
  import TaskApprovalList from './list/TaskApprovalList';
  export default {
    name: 'TaskApprovalPage',
    components: {TaskApprovalList, TaskApprovalToolbar},
    props: [],
    computed: {
      ...mapGetters({
        page: 'page',
        queryFormData: 'queryFormData'
      }),
      orderTaskToDoRead: function () {
        let count = 0;
        this.page.content.forEach(val => {
          if (!val.read) {
            count++;
          }
        })
        return count;
      }
    },
    methods: {
      ...mapActions({
        search: 'search',
        searchAdvanced: 'searchAdvanced'
      }),
      onSearch (page, size) {
        const keyword = this.queryFormData.keyword;
        const url = this.apis().getAuditList();
        this.search({
          url,
          keyword,
          page,
          size
        });
      },
      onAdvancedSearch (page, size) {
        const query = this.queryFormData;
        const url = this.apis().getAuditList();
        this.searchAdvanced({url, query, page, size});
      },
      onReset () {
      },
      handleClick (tab, event) {
        this.onReset();
        this.queryFormData.status = tab.name;
        this.onAdvancedSearch();
      },
      onDetail (code) {
      },
      async onApproval (row) {
        let formData = {
          id: row.id,
          auditMsg: '',
          state: 'PASSED'
        };
        const url = this.apis().taskAudit();
        const result = await this.$http.post(url, formData);
        if (result.code == 0) {
          this.$message.error(result.msg);
        }
      }
    },
    data () {
      return {
        activeName: 'ORDER_TASK',
        statuses: [
          {
            code: '',
            name: '全部'
          },
          {
            code: 'unApproval',
            name: '待审批'
          },
          {
            code: 'approval',
            name: '已审批'
          },
          {
            code: 'reject',
            name: '已驳回'
          }
        ]
      }
    },
    created () {
      this.onSearch();
    },
    mounted () {

    }
  }
</script>

<style scoped>
  .approval-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }
</style>
