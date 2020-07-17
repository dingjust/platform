<template>
  <div>
    <shipping-tasks-toolbar :queryFormData="queryFormData" 
                              @onAdvancedSearch="onAdvancedSearch"/>
    <el-tabs v-model="activeName" @tab-click="handleClick">
      <template v-for="item in statuses">
        <el-tab-pane :label="tabName(item)" :name="item.code" :key="item.code">
          <shipping-tasks-list :mode="mode" :page="page" @onAdvancedSearch="onAdvancedSearch" @onDetail="onDetail"/>
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
  import ShippingTasksToolbar from './toolbar/ShippingTasksToolbar'
  import ShippingTasksList from './list/ShippingTasksList'

  export default {
    name: 'ShippingTasksPage',
    props: {
      page: {
        type: Object,
        required: true
      },
      queryFormData: {
        type: Object,
        required: true
      },
      mode: {
        type: String,
        default: 'import'
      }
    },
    components: {
     ShippingTasksToolbar,
     ShippingTasksList 
    },
    computed: {
      
    },
    methods: {
      onSearch (page, size) {
        this.$emit('onSearch');
      },
      onAdvancedSearch (page, size) {
        this.$emit('onAdvancedSearch');
        this.receivedispatchStateCount();
      },
      async receivedispatchStateCount() {
        let query = Object.assign({}, this.queryFormData);
        query.states = '';
        if (this.mode == 'import') {
          query['shipParty'] = this.$store.getters.currentUser.companyCode;
        } else {
          query['receiveParty'] = this.$store.getters.currentUser.companyCode;
        }

        const url = this.apis().receivedispatchStateCount();
        const result = await this.$http.post(url, query);
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
      tabName(tab) {
        if (this.stateCount.hasOwnProperty(tab.code)) {
          return tab.name + '(' + this.stateCount[tab.code] + ')';
        }
        return tab.name;
      },
      handleClick (tab, event) {
        this.queryFormData.states = tab.name;
        this.$emit('onAdvancedSearch');
        // this.receivedispatchStateCount();
      },
      onDetail (row) {
        this.$router.push('/shipping/tasks/' + row.id);
      },
    },
    data() {
      return {
        stateCount: {},
        activeName: 'PENDING_DELIVERY',
        statuses: this.$store.state.EnumsModule.ReceiveDispatchTaskState
      }
    },
    created() {
      this.receivedispatchStateCount();
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
