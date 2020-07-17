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
        :statusMap="statusMap" @onAdvancedSearch="onAdvancedSearch" @handleClick="onHandleClick" />
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
    name: 'ImportShippingReceiptPage',
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
        const query = this.queryFormData;
        const url = this.searchUrl;
        const companyCode = this.currentUser.companyCode;
        this.searchAdvanced({
          url,
          query,
          page,
          size,
          companyCode
        });
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
          states: 'PENDING_RECEIVED'
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
              key: '单价'
            }, {
              key: '发货数'
            }, {
              key: '关联收货单'
            }, {
              key: '收货数'
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
              key: '对账发货单'
            }, {
              key: '单价',
            }, {
              key: '对账数量',
            }, {
              key: '对账总额',
            }, {
              key: '扣款金额',
            }, {
              key: '增款金额',
            }, {
              key: '对账日期',
            }, {
              key: '对账状态',
            }, ],
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
              key: '对账发货单'
            }, {
              key: '单价',
            }, {
              key: '对账数量',
            }, {
              key: '对账总额',
            }, {
              key: '扣款金额',
            }, {
              key: '增款金额',
            }, {
              key: '对账日期',
            }, {
              key: '对账状态',
            }, ],
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
              key: '对账发货单'
            }, {
              key: '单价',
            }, {
              key: '对账数量',
            }, {
              key: '对账总额',
            }, {
              key: '扣款金额',
            }, {
              key: '增款金额',
            }, {
              key: '对账日期',
            }, {
              key: '对账状态',
            }, ],
            url: this.apis().reconciliationList()
          },
        }
      }
    },
    created() {
      this.onAdvancedSearch();
    },
  }

</script>

<style scoped>
  .title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

</style>
