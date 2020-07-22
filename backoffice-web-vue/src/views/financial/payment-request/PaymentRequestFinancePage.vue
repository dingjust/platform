<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="4">
          <div class="financial-list-title">
            <h6>付款申请单</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <payment-request-toolbar @onAdvancedSearch="onAdvancedSearch" :queryFormData="queryFormData" />
      <div>
        <!-- <el-button class="pr-create-btn" v-if="userRole == 'MERCHANDISER'" @click="onCreate">创建付款申请单</el-button> -->
        <!-- <el-button class="pr-create-btn" v-if="userRole == 'FINANCE'" @click="onCreate">去付款</el-button> -->
        <el-tabs v-model="pageInfo[userRole].activeName" @tab-click="handleClick">
          <template v-for="item in pageInfo[userRole].status">
            <el-tab-pane :label="tabName(item)" :name="item.code" :key="item.code">
              <payment-request-list :page="page" @onAdvancedSearch="onAdvancedSearch" @onDetail="onDetail"/>
            </el-tab-pane>
          </template>
        </el-tabs>
      </div>
    </el-card>
  </div>
</template>

<script>
  import { createNamespacedHelpers } from 'vuex';
  const {
    mapGetters,
    mapActions
  } = createNamespacedHelpers(
    'PaymentRequestModule'
  );
  import PaymentRequestToolbar from './toolbar/PaymentRequestToolbar'
  import PaymentRequestList from './list/PaymentRequestList'

  export default {
    name: 'PaymentRequestFinancePage',
    props: {

    },
    components: {
      PaymentRequestToolbar,
      PaymentRequestList
    },
    computed: {
      ...mapGetters({
        page: 'page',
      }),
      userRole: function () {
        return 'FINANCE';
      }
    },
    methods: {
      ...mapActions({
        search: 'search',
        searchAdvanced: 'searchAdvanced'
      }),
      onSearch (page, size) {
        const keyword = this.keyword;
        const url = this.pageInfo[this.userRole].listUrl;
        this.search({url, keyword, page, size});
      },
      onAdvancedSearch (page, size, isTab) {
        const query = this.queryFormData;
        const url = this.pageInfo[this.userRole].listUrl;
        this.searchAdvanced({url, query, page, size});

        if (!isTab) {
          this.getPaymentCount();
        }
      },
      handleClick (tab, event) {
        this.queryFormData.state = tab.name;
        this.onAdvancedSearch(0, 10, true);
      },
      async getPaymentCount() {
        const url = this.pageInfo[this.userRole].countUrl;
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
      tabName(tab) {
        if (this.stateCount.hasOwnProperty(tab.code)) {
          return tab.name + '(' + this.stateCount[tab.code] + ')';
        }
        return tab.name;
      },
      onDetail (row) {
        this.$router.push('/financial/finance/paymentRequest/' + row.id);
      },
      onCreate () {
        this.$router.push('/financial/create/paymentRequest');
      }
    },
    data () {
      return {
        stateCount: {},
        queryFormData: {
          keyword: '',
          merchandiserName: '',
          belongToName: '',
          createdDateFrom: '',
          createdDateTo: '',
          state: 'WAIT_TO_PAY'
        },
        pageInfo: {
          MERCHANDISER: {
            activeName: 'AUDITING',
            listUrl: '/b2b/payment/request/search',
            countUrl: '/b2b/payment/request/state/count',
            status: [{
              code: 'AUDITING',
              name: '待审核',
            }, {
              code: 'AUDIT_FAIL',
              name: '已驳回'
            }, {
              code: 'WAIT_TO_PAY',
              name: '待付款'
            }, {
              code: 'PAID',
              name: '已付款'
            }]
          },
          FINANCE: {
            activeName: 'WAIT_TO_PAY',
            listUrl: '/b2b/payment/request/finance/search',
            countUrl: '/b2b/payment/request/finance/state/count',
            status: [{
              code: 'WAIT_TO_PAY',
              name: '待付款'
            }, {
              code: 'PAID',
              name: '已付款'
            }]
          }
        }
      }
    },
    created () {
      this.onAdvancedSearch(0, 10);
    },
    destroyed () {
      
    }
  }
</script>

<style scoped>
  .financial-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .pr-create-btn {
    position: absolute;
    right: 21px;
    z-index: 999;
    background-color: #ffd60c;
  } 

  .pr-create-btn:focus {
    background: #ffd60c;
    color: #606266;
  }

  .pr-create-btn:hover {
    background: #ffd60c;
    color: #606266;
  }
</style>