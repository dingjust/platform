<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col>
          <div class="financial-list-title">
            <h6>付款申请单</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <payment-request-toolbar @onAdvancedSearch="onAdvancedSearch" :queryFormData="queryFormData" 
                               :dataQuery="dataQuery" @onResetQuery="onResetQuery"/>
      <div>
        <div :class="tagPosition ? 'tag-position' : ''">
          <el-row ref="tag" type="flex" justify="end" align="middle" >
            <Authorized :permission="['PAYMENT_REQUEST_CREATE']">
              <el-button class="pr-create-btn" @click="onCreate">创建付款申请单</el-button>
            </Authorized>
          </el-row>
        </div>
        <el-tabs ref="tabs" v-model="pageInfo[userRole].activeName" @tab-click="handleClick">
          <template v-for="item in pageInfo[userRole].status">
            <el-tab-pane :label="tabName(item)" :name="item.code" :key="item.code">
              <payment-request-list :page="page" @onAdvancedSearch="onAdvancedSearch" @onDetail="onDetail"/>
            </el-tab-pane>
          </template>
        </el-tabs>
      </div>
    </el-card>
    <el-dialog :visible.sync="typeVisible" width="40%" append-to-body :close-on-click-modal="false">
      <payment-request-type-select v-if="typeVisible" />
    </el-dialog>
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
  import PaymentRequestTypeSelect from '@/views/financial/components/PaymentRequestTypeSelect'

  export default {
    name: 'PaymentRequestMerchandiserPage',
    props: {

    },
    components: {
      PaymentRequestToolbar,
      PaymentRequestList,
      PaymentRequestTypeSelect
    },
    computed: {
      ...mapGetters({
        page: 'page',
      }),
      userRole: function () {
        return 'MERCHANDISER';
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

        this.$nextTick(() => {
          this.changeTagPosition();
        })
      },
      changeTagPosition () {
        let count = 20;
        this.pageInfo['MERCHANDISER'].status.forEach(item => {
          if (item.code === '') {
            count += document.getElementById("tab-" + (this.pageInfo['MERCHANDISER'].status.length - 1)).scrollWidth
          } else {
            count += document.getElementById("tab-" + item.code).scrollWidth
          }
        })
        if (this.tagWidth === 0) {
          this.tagWidth = this.$refs.tag.$el.scrollWidth
        }
        this.tagPosition = this.tagWidth + count < this.$refs.tabs.$el.scrollWidth;
      },
      tabName(tab) {
        if (this.stateCount.hasOwnProperty(tab.code)) {
          return tab.name + '(' + this.stateCount[tab.code] + ')';
        }
        return tab.name;
      },
      onDetail (row) {
        this.$router.push('/financial/merchandiser/paymentRequest/' + row.id);
      },
      onCreate () {
        this.typeVisible = true;
        // this.$router.push('/financial/create/paymentRequest');
      },
      onResetQuery () {
        this.queryFormData = JSON.parse(JSON.stringify(Object.assign(this.queryFormData, this.dataQuery)));
      }
    },
    data () {
      return {
        typeVisible: false,
        stateCount: {},
        queryFormData: {
          keyword: '',
          merchandiserName: '',
          payableName: '',
          createdDateFrom: '',
          createdDateTo: '',
          state: 'AUDITING'
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
            }, {
              code: '',
              name: '全部'
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
            }, {
              code: '',
              name: '全部'
            }]
          }
        },
        dataQuery: {},
        tagPosition: true,
        tagWidth: 0,
      }
    },
    created () {
      this.dataQuery = this.getDataPerQuery('PAYMENT_REQUEST');
      this.onResetQuery();
      this.onAdvancedSearch(0, 10);
    },
    mounted() {
      let that = this;
      window.addEventListener('resize', function () {
        that.$nextTick(() => {
          that.changeTagPosition();
        })
      })
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

  .tag-position {
    position: absolute;
    right: 21px;
    z-index: 999;
  }

  .pr-create-btn {
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

  /deep/ .el-dialog__header {
    padding: 0px;
  }
</style>
