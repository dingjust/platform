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
      <reconciliation-manage-page mode="export" :page="page" :queryFormData="queryFormData" @onSearch="onSearch"
        @onSelect="onSelect" :statusMap="statusMap" @onAdvancedSearch="onAdvancedSearch" @handleClick="onHandleClick"
        :dataQuery="dataQuery" @onResetQuery="onResetQuery" />
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
    'ExportReconciliationManageModule'
  );

  import ReconciliationManagePage from '../../reconciliation-manage/ReconciliationManagePage'
  export default {
    name: 'ExportReconciliationManagePage',
    components: {
      ReconciliationManagePage
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

        let query = Object.assign({}, this.queryFormData);
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
      onSelect(val) {
        this.$set(this, 'selectData', val);
      },
      onResetQuery() {
        this.queryFormData = JSON.parse(JSON.stringify(Object.assign(this.queryFormData, this.dataQuery)));
      }
    },
    data() {
      return {
        currentUser: this.$store.getters.currentUser,
        searchUrl: this.apis().receiptOrderList(),
        queryFormData: {
          keyword: '',
          cooperatorName: '',
          merchandiserName: '',
          createdDateFrom: '',
          createdDateTo: '',
          states: 'PENDING_RECONCILED'
        },
        selectData: [],
        statusMap: {
          PENDING_RECONCILED: {
            status: 'PENDING_RECONCILED',
            label: '待对账',
            columns: [{
              key: 'select',
              isMulti: true,
              //选择项是否可选函数
              selectable: (row, index) => {
                //无对应生产单不可选
                if (row.productionTaskOrder == null) {
                  return false;
                }
                if (this.selectData.length == 0) {
                  return true;
                } else {
                  var orderCode = this.selectData[0].productionTaskOrder.code;
                  if (orderCode == null) {
                    return true;
                  }
                  if (row.productionTaskOrder != null && row.productionTaskOrder.code != null) {
                    return row.productionTaskOrder.code == orderCode;
                  } else {
                    return false;
                  }
                }
              }
            }, {
              key: '收货单'
            }, {
              key: '产品名称'
            }, {
              key: '关联订单',
              props: {
                label: '关联生产工单'
              }
            }, {
              key: '收货供应商'
            }, {
              key: '发货收货数v2'
            }, {
              key: '收货跟单员'
            }, {
              key: '收货日期v2'
            }, {
              key: '发货单状态'
            }, {
              key: '收货操作'
            }],
            url: this.apis().receiptOrderList()
          },
          PENDING_APPROVAL: {
            status: 'PENDING_APPROVAL',
            label: '待审核',
            columns: [{
              key: '对账单号'
            }, {
              key: '关联订单',
              props: {
                label: '关联生产工单'
              }
            }, {
              key: '发货供应商'
            }, {
              key: '收货跟单员'
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
          PENDING_CONFIRM: {
            status: 'PENDING_CONFIRM',
            label: '对账中',
            columns: [{
              key: '对账单号'
            }, {
              key: '关联订单',
              props: {
                label: '关联生产工单'
              }
            }, {
              key: '发货供应商'
            }, {
              key: '收货跟单员'
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
          APPROVAL_RETURN: {
            status: 'APPROVAL_RETURN',
            label: '审批驳回',
            columns: [{
              key: '对账单号'
            }, {
              key: '关联订单',
              props: {
                label: '关联生产工单'
              }
            }, {
              key: '发货供应商'
            }, {
              key: '收货跟单员'
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
              key: '关联订单',
              props: {
                label: '关联生产工单'
              }
            }, {
              key: '发货供应商'
            }, {
              key: '收货跟单员'
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
              key: '关联订单',
              props: {
                label: '关联生产工单'
              }
            }, {
              key: '发货供应商'
            }, {
              key: '收货跟单员'
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
      this.dataQuery = this.getDataPerQuery('RECONCILIATION_SHEET_OUT');
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
