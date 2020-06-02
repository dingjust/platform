<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="4">
          <div class="handle-list-title">
            <h6>待我处理</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <el-tabs v-model="activeName" type="card" @tab-click="handleClick">
        <el-tab-pane name="ORDER_TASK">
          <span slot="label">
            订单任务
            <el-badge :value="orderTaskToDoRead" :max="99" :hidden="orderTaskToDoRead == 0" class="item">
            </el-badge>
          </span>
          <div class="tab-basic-row">
            <task-handle-toolbar :queryFormData="queryFormData"
                                 @onReset="onReset" @onAdvancedSearch="onAdvancedSearch"/>
            <el-tabs v-model="activeStatus" @tab-click="handleClick">
              <template v-for="(item, index) in statuses">
                <el-tab-pane :name="item.code" :label="item.name">
                  <task-handle-list :page="page" @onAdvancedSearch="onAdvancedSearch"
                                    @onDetail="onDetail" @onUndertake="onUndertake" @onAssignment="onAssignment"/>
                </el-tab-pane>
              </template>
            </el-tabs>
          </div>
        </el-tab-pane>
        <el-tab-pane label="采购任务" name="PURCHASE_TASK">
<!--          <div class="tab-basic-row">-->
<!--            <task-handle-toolbar :queryFormData="queryFormData" :statuses="statuses"-->
<!--                                 @onReset="onReset" @onAdvancedSearch="onAdvancedSearch"/>-->
<!--            <task-handle-list :page="page" @onAdvancedSearch="onAdvancedSearch"-->
<!--                              @onDetail="onDetail" @onUndertake="onUndertake"/>-->
<!--          </div>-->
        </el-tab-pane>
        <el-tab-pane label="报价任务" name="QUOTE_TASK">
<!--          <div class="tab-basic-row">-->
<!--            <task-handle-toolbar :queryFormData="queryFormData" :statuses="statuses"-->
<!--                          @onReset="onReset" @onAdvancedSearch="onAdvancedSearch"/>-->
<!--            <task-handle-list :page="page" @onAdvancedSearch="onAdvancedSearch"-->
<!--                       @onDetail="onDetail" @onUndertake="onUndertake"/>-->
<!--          </div>-->
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
    'TaskHandleModule'
  );

  import TaskHandleToolbar from './toolbar/TaskHandleToolbar';
  import TaskHandleList from './list/TaskHandleList';
  export default {
    name: 'TaskHandlePage',
    components: {TaskHandleList, TaskHandleToolbar},
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
        const url = this.apis().getToDoList();
        this.search({
          url,
          keyword,
          page,
          size
        });
      },
      onAdvancedSearch (page, size) {
        const query = this.queryFormData;
        const url = this.apis().getToDoList();
        this.searchAdvanced({url, query, page, size});
      },
      onReset () {
      },
      handleClick (tab, event) {
        this.onReset();
        this.queryFormData.status = tab.name;
        this.onAdvancedSearch();
      },
      onDetail (row) {
        if (row.type == 'ProductionTask') {
          if (!row.read) {
            this.updateRead(row);
          }
          this.$router.push('/sales/production/' + row.refItemPk);
        }
      },
      onUndertake (row) {
        this.$message('--------------------承接-------------------------')
      },
      onAssignment () {
        this.$message('--------------------分配任务-------------------------')
      },
      updateRead (row) {
        const url = this.apis().updateToRead(row.id);
        const result = this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
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
            code: 'unUndertake',
            name: '待承接'
          },
          {
            code: 'undertake',
            name: '已承接'
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
  .handle-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .tab-basic-row {
    margin-left: 10px;
  }

  .item {
    margin-top: -5px;
    margin-right: 0px;
    position: absolute;
    z-index: 999;
  }
</style>
