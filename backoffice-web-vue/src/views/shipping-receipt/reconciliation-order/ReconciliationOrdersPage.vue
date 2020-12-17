<!-- 
 * @description: 对账单
 * @fileName: ReconciliationOrdersPage.vue 
 * @author: yj 
 * @date: 2020-06-22 15:09:48
 * @version: V1.0.0 
!-->
<template>
  <div class="animated fadeIn">
    <el-row>
      <el-col :span="4">
        <div class="title">
          <h6>对账单列表</h6>
        </div>
      </el-col>
    </el-row>
    <div class="pt-2"></div>
    <reconciliation-orders-toolbar :queryFormData="queryFormData" @onAdvancedSearch="onAdvancedSearch" 
                                    :dataQuery="dataQuery" @onResetQuery="onResetQuery"/>
    <el-tabs v-model="activeName" @tab-click="handleClick">
      <template v-for="item in statuses">
        <el-tab-pane :label="tabName(item)" :name="item.code" :key="item.code">
          <reconciliation-orders-list :page="page" @onAdvancedSearch="onAdvancedSearch" @onDetail="onDetail" />
        </el-tab-pane>
      </template>
    </el-tabs>
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
    'ReconciliationOrdersModule'
  );

  import ReconciliationOrdersToolbar from './toolbar/ReconciliationOrdersToolbar'
  import ReconciliationOrdersList from './list/ReconciliationOrdersList'
  export default {
    name: 'ReconciliationOrdersPage',
    props: {
      mode: {
        type: String,
        default: 'import'
      }
    },
    components: {
      ReconciliationOrdersToolbar,
      ReconciliationOrdersList
    },
    computed: {
      ...mapGetters({
        keyword: 'keyword',
        page: 'page',
        formData: 'formData'
      })
    },
    methods: {
      ...mapActions({
        search: 'search',
        searchAdvanced: 'searchAdvanced'
      }),
      onAdvancedSearch(page, size) {
        if (this.queryFormData.users.length <= 0 && this.queryFormData.depts.length <= 0) {
          this.onResetQuery();
        }
        const query = this.queryFormData;
        const url = this.apis().reconciliationList();
        const mode = this.mode;
        const companyCode = this.currentUser.companyCode;
        this.searchAdvanced({
          url,
          query,
          page,
          size,
          mode,
          companyCode
        });
      },
      handleClick(tab, event) {
        if (this.mode == 'export') {
          this.queryFormData.states = tab.name;
        }
        //收货方，状态查询处理
        else if (this.mode == 'import') {
          switch (tab.name) {
            case 'PENDING_APPROVAL':
              this.queryFormData.auditStates = 'AUDITING';
              this.queryFormData.states = 'PENDING_CONFIRM';
              break
            case 'APPROVAL_RETURN':
              this.queryFormData.auditStates = 'AUDITED_FAILED';
              this.queryFormData.states = 'PENDING_CONFIRM';
              break;
            default:
              this.$delete(this.queryFormData, 'auditStates');
              this.queryFormData.states = tab.name;
              break
          }
        }
        this.onAdvancedSearch(0, 10);
      },
      onDetail(row) {
        this.$router.push('/reconciliation/orders/' + row.id);
      },
      // 查询对账单状态统计
      async reconciliationStateCount() {
        let query = Object.assign({}, this.queryFormData);
        query.states = '';
        if (this.mode == 'import') {
          // query['shipParty'] = this.$store.getters.currentUser.companyCode;
          query['partyType'] = 'PARTYB';
        } else {
          // query['receiveParty'] = this.$store.getters.currentUser.companyCode;
          query['partyType'] = 'PARTYA';
        }

        const url = this.apis().reconciliationSheetStateCount();
        const result = await this.$http.post(url, query);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        this.$set(this, 'stateCount', result.data);
      },
      tabName(map) {
        let tabName = this.getEnum('ReconciliationOrderState', map.code);
        if (!this.stateCount.hasOwnProperty(map.code)) {
          return tabName;
        }
        tabName = this.getEnum('ReconciliationOrderState', map.code) + '(' + this.stateCount[map.code] +
          ')';
        return tabName;
      },
      onResetQuery () {
        this.queryFormData = JSON.parse(JSON.stringify(Object.assign(this.queryFormData, this.dataQuery)));
      }
    },
    data() {
      return {
        activeName: 'PENDING_CONFIRM',
        statuses: this.$store.state.EnumsModule.ReconciliationOrderState,
        currentUser: this.$store.getters.currentUser,
        stateCount: {},
        queryFormData: {
          keyword: '',
          productionLeaderName: '',
          operatorName: '',
          creationtimeStart: '',
          creationtimeEnd: '',
          states: 'PENDING_CONFIRM'
        },
        dataQuery: {}
      }
    },
    created() {
      const pageSign = this.mode === 'import' ? 'RECONCILIATION_SHEET' : 'RECONCILIATION_SHEET_OUT';
      this.dataQuery = this.getDataPerQuery(pageSign);
      this.onResetQuery();
      this.onAdvancedSearch();
      this.reconciliationStateCount();
    },
  }

</script>

<style scoped>
  .title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

</style>
