<template>
  <div>
    <pending-order-select-toolbar  @onAdvancedSearch="onAdvancedSearch" :queryFormData="queryFormData" />
    <el-tabs v-model="activeName" @tab-click="handleClick">
      <template v-for="item in statuses">
        <el-tab-pane :label="tabName(item)" :name="item.code" :key="item.code">
          <pending-order-select-list :page="page" @onAdvancedSearch="onAdvancedSearch" @onSelectOrder="onSelectOrder"/>
        </el-tab-pane>
      </template>
    </el-tabs>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';
  import PendingOrderSelectToolbar from './toolbar/PendingOrderSelectToolbar'
  import PendingOrderSelectList from './list/PendingOrderSelectList'

  const {
    mapGetters,
    mapActions,
    mapMutations
  } = createNamespacedHelpers(
    'PendingSalesProductionOrdersModule'
  );

  export default {
    name: 'PendingSalesProduction',
    components: {
      PendingOrderSelectToolbar,
      PendingOrderSelectList
    },
    computed: {
      ...mapGetters({
        page: 'page',
        keyword: 'keyword'
      })
    },
    methods: {
      ...mapActions({
        search: 'search',
        searchAdvanced: 'searchAdvanced'
      }),
      onAdvancedSearch(page, size) {
        const query = this.queryFormData;
        const url = this.apis().getPendingSalesOrderList();
        this.searchAdvanced({
          url,
          query,
          page,
          size
        });
        this.pendingOrderStateCount();
      },
      handleClick (tab, event) {
        this.queryFormData.state = tab.name;
        this.onAdvancedSearch();
      },
      async pendingOrderStateCount () {
        const url = this.apis().pendingOrderStateCount();
        const result = await this.$http.post(url, this.queryFormData);
        if (result['errors']) {
          this.stateCount = {};
          this.$message.error(result['errors'][0].message);
          return;
        }
        if (result.code === 0) {
          this.stateCount = {};
          this.$message.error(result.msg);
          return;
        }
        this.stateCount = result.data;
      },
      tabName (tab) {
        if (this.stateCount.hasOwnProperty(tab.code)) {
          if (tab.code == 'TO_BE_ACCEPTED') {
            return '待接单/待提交(' + this.stateCount[tab.code] +')';
          }
          return tab.name +'('+ this.stateCount[tab.code] +')';  
        }
        return tab.name;
      },
      onSelectOrder (row) {
        this.$emit('setSelectOrder', row);
      }
    },
    data() {
      return {
        activeName: 'AUDIT_PASSED',
        statuses: [{
          code: 'AUDIT_PASSED',
          name: '生产中'
        }, {
          code: 'COMPLETED',
          name: '已完成'
        }],
        queryFormData: {
          keyword: '',
          planLeader: '',
          originCooperator: '',
          state: 'AUDIT_PASSED'
        },
        stateCount: {}
      }
    },
    created() {
      this.onAdvancedSearch();
    }
  }

</script>

<style scoped>
  .sales-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .sales-divider {
    margin: 5px
  }

</style>
