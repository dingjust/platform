<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <div class="approval-list-title">
          <h6>待我审批</h6>
        </div>
      </el-row>
      <div class="pt-2"></div>
      <el-tabs v-model="activeName" type="card" @tab-click="handleClick">
        <el-tab-pane label="订单任务" name="ORDER_TASK">
          <div class="tab-basic-row">
            <task-approval-toolbar :queryFormData="queryFormData" @onReset="onReset" :dataQuery="dataQuery"
              @onAdvancedSearch="onAdvancedSearch" @onResetQuery="onResetQuery"/>
            <el-tabs v-model="activeStatus" @tab-click="handleClick">
              <template v-for="item in statuses">
                <el-tab-pane :name="item.code" :label="item.name" :key="item.code">
                  <task-approval-list :page="page" @onAdvancedSearch="onAdvancedSearch" @onDetail="onDetail"
                    @onApproval="onApproval" @onRefuse="onRefuse" />
                </el-tab-pane>
              </template>
            </el-tabs>
          </div>
        </el-tab-pane>
        <!-- <el-tab-pane label="采购任务" name="PURCHASE_TASK">
          <div class="tab-basic-row">
            <task-approval-toolbar :queryFormData="queryFormData" @onReset="onReset"
              @onAdvancedSearch="onAdvancedSearch" />
            <el-tabs v-model="activeStatus" @tab-click="handleClick">
              <template v-for="item in statuses">
                <el-tab-pane :name="item.code" :label="item.name" :key="item.code">
                  <task-approval-list :page="page" @onAdvancedSearch="onAdvancedSearch" @onDetail="onDetail"
                    @onApproval="onApproval" />
                </el-tab-pane>
              </template>
            </el-tabs>
          </div>
        </el-tab-pane> -->
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
    components: {
      TaskApprovalList,
      TaskApprovalToolbar,
    },
    props: [],
    computed: {
      ...mapGetters({
        page: 'page'
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
        searchAdvanced: 'searchAdvanced'
      }),
      onAdvancedSearch(page, size) {
        if (this.queryFormData.users.length <= 0 && this.queryFormData.depts.length <= 0) {
          this.onResetQuery();
        }
        let query = Object.assign({}, this.queryFormData);
        if (this.queryFormData.searchType === 'AUDITING') {
          query.state = 'AUDITING'
        }

        const url = this.apis().getAuditList();
        this.searchAdvanced({
          url,
          query,
          page,
          size
        });
      },
      onResetQuery () {
        this.queryFormData = JSON.parse(JSON.stringify(Object.assign(this.queryFormData, this.dataQuery)));
      },
      onReset() {},
      handleClick(tab, event) {
        this.onReset();
        this.queryFormData.searchType = tab.name;
        this.onAdvancedSearch();
      },
      onDetail(row) {
        switch (row.type) {
          case 'SalesOrder':
            this.$router.push('/sales/order/' + row.auditModel.id);
            break;
          case 'OutboundOrder':
            this.$router.push('/sales/outboundOrder/' + row.auditModel.id);
            break;
          case 'ReconciliationSheet':
            this.$router.push('/reconciliation/orders/' + row.auditModel.id);
            break;
          case 'OriginReconciliationSheet':
            this.$router.push('/reconciliation/orders/' + row.auditModel.id);
            break;
          case 'PaymentRequestTask':
            this.$router.push('/financial/merchandiser/paymentRequest/' + row.auditModel.id);
            break;
          case 'PurchaseTask':
            this.$router.push('/purchase/requirement/' + row.auditModel.id);
            break;
          case 'ProductionPurchaseOrder':
            this.$router.push('/purchase/order/' + row.auditModel.id);
            break;
          case 'FastReconciliationSheet':
            this.$router.push('/order/reconciliation/' + row.auditModel.id);
        }
      },
      onApproval(row) {
        this.$confirm('是否确认进行审批?', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this._onApproval(row);
        });
      },
      onRefuse(row) {
        this.$confirm('是否确认进行拒绝?', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this._onRefuse(row);
        });
      },
      async _onApproval(row) {
        let formData = {
          id: row.id,
          auditMsg: '',
          state: 'PASSED'
        };
        const url = this.apis().taskAudit();
        const result = await this.$http.post(url, formData);
        if (result.code == 0) {
          this.$message.error(result.msg);
          return
        }
        this.$message.success('审批成功');
        this.onAdvancedSearch(this.page.number);
      },
      async _onRefuse(row) {
        let formData = {
          id: row.id,
          auditMsg: '',
          state: 'AUDITED_FAILED'
        };
        const url = this.apis().taskAudit();
        const result = await this.$http.post(url, formData);
        if (result.code == 0) {
          this.$message.error(result.msg);
          return
        }
        this.$message.success('拒绝成功');
        this.onAdvancedSearch(this.page.number);
      }
    },
    data() {
      return {
        orderDetail: '',
        detailVisible: false,
        activeName: 'ORDER_TASK',
        activeStatus: 'AUDITING',
        queryFormData: {
          keyword: '',
          // state: '',
          searchType: 'AUDITING'
        },
        statuses: [{
          code: 'AUDITING',
          name: '待审批'
        }, {
          code: 'PASSED',
          name: '已审批'
        }, {
          code: 'AUDITED_FAILED',
          name: '已驳回'
        }, {
          code: '',
          name: '全部'
        }],
        dataQuery: {},
        purchaseOrderId: ''
      }
    },
    created() {
      this.dataQuery = this.getDataPerQuery('AUDIT_TASK');
      this.onResetQuery();
      this.onAdvancedSearch(0, 10);
    },
    mounted() {

    }
  }

</script>

<style scoped>
  .approval-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

</style>
