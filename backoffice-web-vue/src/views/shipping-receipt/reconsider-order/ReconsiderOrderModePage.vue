<template>
  <div class="reconsider-order-mode-page">
    <el-row>
      <el-col :span="4">
        <div class="title">
          <h6>复议单</h6>
        </div>
      </el-col>
    </el-row>
    <div class="pt-2"></div>
    <reconsider-orders-page :page="page" :queryFormData="queryFormData" @onSearch="onSearch"
      currentState="IN_RECONSIDER" @onAdvancedSearch="onAdvancedSearch" @handleClick="onHandleClick"
      :statusMap="statusMap" />
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
    'ReconsiderOrdersModule'
  );

  import ReconsiderOrdersPage from './ReconsiderOrdersPage'
  export default {
    name: 'ReconsiderOrderModePage',
    components: {
      ReconsiderOrdersPage
    },
    props: {
      mode: {
        type: String,
        default: "import"
      },
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
        const mode = this.mode;
        const companyCode = this.currentUser.companyCode;
        this.search({
          url,
          keyword,
          page,
          size,
          mode,
          companyCode
        });
      },
      onAdvancedSearch(page, size) {
        // TODO 查询自身的收发任务
        const query = this.queryFormData;
        const url = this.searchUrl;
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
      }
    },
    data() {
      return {
        currentUser: this.$store.getters.currentUser,
        searchUrl: this.apis().reconsiderOrderList(),
        queryFormData: {
          keyword: '',
          cooperatorName: '',
          merchandiserName: '',
          createdDateFrom: '',
          createdDateTo: '',
          states: 'IN_RECONSIDER'
        },
        statusMap: {
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
                key: "差异数",
                props: {
                  prop: "logisticsSheet.diffQuantity"
                }
              },
              {
                key: "复议数"
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
                key: "差异数",
                props: {
                  prop: "logisticsSheet.diffQuantity"
                }
              },
              {
                key: "复议数"
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
                key: "差异数",
                props: {
                  prop: "logisticsSheet.diffQuantity"
                }
              },
              {
                key: "复议数"
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
                key: "发货操作"
              }
            ],
            url: this.apis().shippingOrderList()
          }
        },
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

  .reconsider-order-mode-page {}

</style>
