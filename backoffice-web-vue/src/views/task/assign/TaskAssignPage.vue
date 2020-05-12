<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="4">
          <div class="assign-list-title">
            <h6>待我分配</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <el-tabs v-model="activeName" type="card" @tab-click="handleClick">
        <el-tab-pane label="订单任务" name="ORDER_TASK">
          <div class="tab-basic-row">
            <task-assign-toolbar :queryFormData="queryFormData" :statuses="statuses"
                                 @onReset="onReset" @onAdvancedSearch="onAdvancedSearch"/>
            <task-assign-list :page="page" @onAdvancedSearch="onAdvancedSearch"
                              @onDetail="onDetail" @onAssign="onAssign"/>
          </div>
        </el-tab-pane>
        <el-tab-pane label="采购任务" name="PURCHASE_TASK">
          <div class="tab-basic-row">
            <task-assign-toolbar :queryFormData="queryFormData" :statuses="statuses"
                                 @onReset="onReset" @onAdvancedSearch="onAdvancedSearch"/>
            <task-assign-list :page="page" @onAdvancedSearch="onAdvancedSearch"
                              @onDetail="onDetail" @onAssign="onAssign"/>
          </div>
        </el-tab-pane>
      </el-tabs>
    </el-card>
  </div>
</template>

<script>
  import TaskAssignToolbar from './toolbar/TaskAssignToolbar';
  import TaskAssignList from './list/TaskAssignList';
  export default {
    name: 'TaskAssignPage',
    components: {TaskAssignList, TaskAssignToolbar},
    props: [],
    computed: {

    },
    methods: {
      onAdvancedSearch () {
        this.$message('---------onAdvancedSearch-------------');
      },
      onReset () {
        this.queryFormData.keyword = '';
        this.queryFormData.charge = '';
        this.queryFormData.creationtime = '';
        this.queryFormData.status = '';
      },
      handleClick (tab, event) {
        this.$message('-------------' + tab.name + '--------------------')
        this.onReset();
        // TODO 根据tab.name查询page数据
        switch (tab.name) {

        }
      },
      onDetail (code) {
        this.$message('---------onDetail-------------');
      },
      onAssign (code) {
        this.$message('---------onUndertake-------------');
      }
    },
    data () {
      return {
        activeName: 'ORDER_TASK',
        statuses: [
          {
            code: 'unAssign',
            name: '待分配'
          },
          {
            code: 'assign',
            name: '已分配'
          }
        ],
        queryFormData: {
          keyword: '',
          charge: '',
          creationtime: '',
          status: ''
        },
        page: {
          number: 0,
          size: 10,
          currentPageNumber: 0,
          currentPageSize: 10,
          totalPages: 1,
          totalElements: 1,
          content: [{
            code: 'CO0000000001',
            type: '销售订单',
            creationPerson: '马云',
            creationtime: 1589268308,
            deliverytime: 1589268308,
            status: '待承接'
          }]
        }
      }
    },
    created () {

    },
    mounted () {

    }
  }
</script>

<style scoped>
  .assign-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }
</style>
