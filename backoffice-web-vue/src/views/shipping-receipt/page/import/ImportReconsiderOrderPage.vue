<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="4">
          <div class="title">
            <h6>差异复议</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <reconsider-orders-page mode="import" :page="page" :queryFormData="queryFormData" @onSearch="onSearch"
        @onAdvancedSearch="onAdvancedSearch" @handleClick="onHandleClick" :statusMap="statusMap" 
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
    'ImportReconsiderOrderModule'
  );

  import ReconsiderOrdersPage from '../../reconsider-order/ReconsiderOrdersPage'
  export default {
    name: 'ImportReconsiderOrderPage',
    components: {
      ReconsiderOrdersPage
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
        this.queryFormData.states = val.states;
        this.onAdvancedSearch(0, 10);
      },
      onSearch(page, size) {
        // TODO 查询自身的收发任务
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
          states: 'PENDING_RECONSIDER'
        },
        statusMap: {
          PENDING_RECONSIDER: {
            states: "PENDING_RECONSIDER",
            columns: [{
                key: "多选"
              },
              {
                key: "发货单号"
              },
              {
                key: "产品名称"
              },
              {
                key: "关联订单"
              },
              {
                key: "发货收货数"
              },
              {
                key: "退货收货数"
              },
              {
                key: "收货日期"
              },
              {
                key: "差异数"
              },
              {
                key: "发货单状态"
              },
              {
                key: "发货操作",
                props: {
                  operationName: '复议'
                }
              }
            ],
            url: this.apis().shippingOrderList()
          },
          IN_RECONSIDER: {
            states: "IN_RECONSIDER",
            columns: [{
                key: "多选"
              },
              {
                key: "复议单号"
              },
              {
                key: "产品名称"
              },
              {
                key: '关联发货单',
                props: {
                  code: 'logisticsSheet.code',
                  id: 'logisticsSheet.id'
                }
              },
              {
                key: "关联订单"
              },
              {
                key: "发货收货数",
                props: {
                  shipProp: 'logisticsSheet.totalQuantity',
                  receSheetProp: 'logisticsSheet.receiptSheets'
                }
              },
              {
                key: "退货收货数",
                props: {
                  prop: 'logisticsSheet.returnSheets'
                }
              },
              {
                key: "收货日期",
                props: {
                  prop: 'logisticsSheet.receiptSheets'
                }
              },
              {
                key: '差异-复议',
                props: {
                  diffProp: "logisticsSheet.diffQuantity",
                }
              },
              {
                key: "发货单状态"
              },
              {
                key: "复议单操作"
              }
            ],
            url: this.apis().reconsiderOrderList()
          },
          RECONSIDER_SUCCESS: {
            states: "RECONSIDER_SUCCESS",
            columns: [{
                key: "多选"
              },
              {
                key: "复议单号"
              },
              {
                key: "产品名称"
              },
              {
                key: '关联发货单',
                props: {
                  code: 'logisticsSheet.code',
                  id: 'logisticsSheet.id'
                }
              },
              {
                key: "关联订单"
              },
              {
                key: "发货收货数",
                props: {
                  shipProp: 'logisticsSheet.totalQuantity',
                  receSheetProp: 'logisticsSheet.receiptSheets'
                }
              },
              {
                key: "退货收货数"
              },
              {
                key: "收货日期",
                props: {
                  prop: 'logisticsSheet.receiptSheets'
                }
              },
              {
                key: '差异-复议',
                props: {
                  diffProp: "logisticsSheet.diffQuantity",
                }
              },
              {
                key: "发货单状态"
              },
              {
                key: "复议单操作"
              }
            ],
            url: this.apis().reconsiderOrderList()
          },
          RECONSIDER_FAIL: {
            states: "RECONSIDER_FAIL",
            columns: [{
                key: "多选"
              },
              {
                key: "复议单号"
              },
              {
                key: "产品名称"
              },
              {
                key: '关联发货单',
                props: {
                  code: 'logisticsSheet.code',
                  id: 'logisticsSheet.id'
                }
              },
              {
                key: "关联订单"
              },
              {
                key: "发货收货数",
                props: {
                  shipProp: 'logisticsSheet.totalQuantity',
                  receSheetProp: 'logisticsSheet.receiptSheets'
                }
              },
              {
                key: "退货收货数"
              },
              {
                key: "收货日期",
                props: {
                  prop: 'logisticsSheet.receiptSheets'
                }
              },
              {
                key: '差异-复议',
                props: {
                  diffProp: "logisticsSheet.diffQuantity",
                }
              },
              {
                key: "发货单状态"
              },
              {
                key: "复议单操作"
              }
            ],
            url: this.apis().reconsiderOrderList()
          },
          RECONSIDER_EXPIRED: {
            states: "RECONSIDER_EXPIRED",
            columns: [{
                key: "多选"
              },
              {
                key: "发货单号"
              },
              {
                key: "产品名称"
              },
              {
                key: "关联订单"
              },
              {
                key: "发货收货数",
                props: {
                  shipProp: 'logisticsSheet.totalQuantity',
                  receSheetProp: 'logisticsSheet.receiptSheets'
                }
              },
              {
                key: "退货收货数"
              },
              {
                key: "收货日期",
                props: {
                  prop: 'logisticsSheet.receiptSheets'
                }
              },
              {
                key: "差异数",
                props: {
                  prop: "logisticsSheet.diffQuantity"
                }
              },
              {
                key: "发货单状态"
              },
              {
                key: "发货操作"
              }
            ],
            url: this.apis().shippingOrderList()
          }
        },
        dataQuery: {}
      }
    },
    created() {
      this.dataQuery = this.getDataPerQuery('RECONSIDER_SHEET');
      this.onResetQuery();
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
