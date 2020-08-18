<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="4">
          <div class="title">
            <h6>对账管理</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <reconciliation-manage-page mode="import" :page="page" :queryFormData="queryFormData" @onSearch="onSearch"
        :statusMap="statusMap" @onAdvancedSearch="onAdvancedSearch" @handleClick="onHandleClick" 
        :dataQuery="dataQuery" @onResetQuery="onResetQuery"/>
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
    'ImportReconciliationManageModule'
  );

  import ReconciliationManagePage from '../../reconciliation-manage/ReconciliationManagePage'
  export default {
    name: 'ImportShippingReceiptPage',
    components: {
      ReconciliationManagePage
    },
    computed: {
      ...mapGetters({
        keyword: 'keyword',
        page: 'page',
        formData: 'formData'
      }),
    },
    methods: {
      ...mapActions({
        search: 'search',
        searchAdvanced: 'searchAdvanced'
      }),
      onHandleClick(val) {
        this.searchUrl = val.searchUrl;
        this.queryFormData.states = val.status;
        this.onAdvancedSearch(0, 10);
      },
      onSearch(page, size) {
        const keyword = this.keyword;
        const url = this.searchUrl;
        const companyCode = this.currentUser.companyCode;
        this.search({
          url,
          keyword,
          page,
          size,
          companyCode
        });
      },
      onAdvancedSearch(page, size) {
        if (this.queryFormData.users.length <= 0 && this.queryFormData.depts.length <= 0) {
          this.onResetQuery();
        }
        
        let query;
        //针对发货方的确认审核状态处理
        if (this.queryFormData.states == 'PENDING_APPROVAL') {
          query = Object.assign({}, this.queryFormData);
          query['states'] = 'PENDING_CONFIRM';
          query['auditStates'] = 'AUDITING';
        } else if (this.queryFormData.states == 'REJECTED') {
          query = Object.assign({}, this.queryFormData);
          query['states'] = 'PENDING_CONFIRM';
          query['auditStates'] = 'AUDITED_FAILED';
        } else {
          query = Object.assign({}, this.queryFormData);
          this.$delete(query, 'auditStates');
        }
        const url = this.searchUrl;
        const companyCode = this.currentUser.companyCode;
        this.searchAdvanced({
          url,
          query,
          page,
          size,
          companyCode
        });
      },
      onResetQuery () {
        this.queryFormData = JSON.parse(JSON.stringify(Object.assign(this.queryFormData, this.dataQuery)));
      }
    },
    data() {
      return {
        currentUser: this.$store.getters.currentUser,
        searchUrl: this.apis().shippingOrderList(),
        queryFormData: {
          keyword: '',
          cooperatorName: '',
          merchandiserName: '',
          createdDateFrom: '',
          createdDateTo: '',
          states: 'PENDING_RECONCILED'
        },
        statusMap: {
          PENDING_RECONCILED: {
            status: 'PENDING_RECONCILED',
            label: '待对账',
            columns: [{
              key: '发货单号'
            }, {
              key: '产品名称'
            }, {
              key: '关联订单'
            }, {
              key: '收货供应商'
            }, {
              key: '发货收货数'
            }, {
              key: '跟单员'
            }, {
              key: '收货日期'
            }, {
              key: '发货单状态'
            }, {
              key: '发货操作'
            }],
            url: this.apis().shippingOrderList()
          },
          PENDING_CONFIRM: {
            status: 'PENDING_CONFIRM',
            label: '对账中',
            columns: [{
              key: '对账单号'
            }, {
              key: '关联订单'
            }, {
              key: '收货供应商'
            }, {
              key: '跟单员'
            }, {
              key: '账单金额'
            }, {
              key: '对账日期',
            }, {
              key: '对账状态',
            }, {
              key: '对账详情'
            }],
            url: this.apis().reconciliationList()
          },
          PENDING_APPROVAL: {
            status: 'PENDING_APPROVAL',
            isAuditStates: true,
            label: '待审核',
            columns: [{
              key: '对账单号'
            }, {
              key: '关联订单'
            }, {
              key: '收货供应商'
            }, {
              key: '跟单员'
            }, {
              key: '账单金额'
            }, {
              key: '对账日期',
            }, {
              key: '对账状态',
            }, {
              key: '对账详情'
            }],
            url: this.apis().reconciliationList()
          },
          REJECTED: {
            status: 'REJECTED',
            label: '已驳回',
            columns: [{
              key: '对账单号'
            }, {
              key: '关联订单'
            }, {
              key: '收货供应商'
            }, {
              key: '跟单员'
            }, {
              key: '账单金额'
            }, {
              key: '对账日期',
            }, {
              key: '对账状态',
            }, {
              key: '对账详情'
            }],
            url: this.apis().reconciliationList()
          },
          CONFIRMED: {
            status: 'CONFIRMED',
            label: '已确认',
            columns: [{
              key: '对账单号'
            }, {
              key: '关联订单'
            }, {
              key: '收货供应商'
            }, {
              key: '跟单员'
            }, {
              key: '账单金额'
            }, {
              key: '对账日期',
            }, {
              key: '对账状态',
            }, {
              key: '对账详情'
            }],
            url: this.apis().reconciliationList()
          },
        },
        dataQuery: {}
      }
    },
    created() {
      this.dataQuery = this.getDataPerQuery('RECONCILIATION_SHEET');
      this.onResetQuery();
      this.onAdvancedSearch(0, 10);
    },
  }

</script>

<style scoped>
  .title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

</style>
