<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="4">
          <div class="title">
            <h6>收货管理</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <shipping-receipt-page mode="export" :page="page" :queryFormData="queryFormData" @onSearch="onSearch"
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
    'ExportShippingReceiptModule'
  );

  import ShippingReceiptPage from '../../shipping-receipt-sheet/ShippingReceiptPage'
  export default {
    name: 'ExportShippingReceiptPage',
    components: {
      ShippingReceiptPage
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
          states: 'PENDING_RECEIVED'
        },
        statusMap: {
          PENDING_RECEIVED: {
            status: 'PENDING_RECEIVED',
            columns: [{
              key: '发货单号'
            }, {
              key: '产品名称'
            }, {
              key: '关联订单-收货'
            }, {
              key: '合作商-收货'
            }, {
              key: '收货跟单员'
            }, {
              key: '发货数'
            }, {
              key: '发货日期'
            }, {
              key: '发货操作'
            }],
            url: this.apis().shippingOrderList()
          },
          PENDING_RETURNED: {
            status: 'PENDING_RETURNED',
            columns: [{
              key: '发货单号'
            }, {
              key: '产品名称'
            }, {
              key: '关联订单-收货'
            }, {
              key: '合作商-收货'
            }, {
              key: '收货跟单员'
            }, {
              key: '发货收货数'
            }, {
              key: '发货操作'
            }],
            url: this.apis().shippingOrderList()
          },
          RETURN_TO_BE_RECEIVED: {
            status: 'RETURN_TO_BE_RECEIVED',
            columns: [{
              key: '退货单'
            }, , {
              key: '产品名称'
            }, {
              key: '关联发货单',
              props: {
                code: 'logisticsSheet.code',
                id: 'logisticsSheet.id'
              }
            }, {
              key: '合作商-收货'
            }, {
              key: '收货跟单员'
            }, {
              key: '退货数',
              props: {
                prop: 'totalQuantity'
              }
            }, {
              key: '退货操作'
            }],
            url: this.apis().returnOrderList()
          },
          PENDING_RECONSIDER: {
            status: 'PENDING_RECONSIDER',
            columns: [{
              key: '发货单号'
            }, {
              key: '产品名称'
            }, {
              key: '关联订单-收货'
            }, {
              key: '合作商-收货'
            }, {
              key: '收货跟单员'
            }, {
              key: '发货收货数'
            }, {
              key: '退货收货数'
            }, {
              key: '差异数'
            }, {
              key: '发货操作'
            }],
            url: this.apis().shippingOrderList()
          },
          IN_RECONSIDER: {
            status: 'IN_RECONSIDER',
            columns: [{
                key: '复议单号'
              },
              {
                key: '产品名称'
              }, {
                key: '关联订单-收货'
              }, {
                key: '合作商-收货'
              }, {
                key: '收货跟单员'
              }, {
                key: '发货收货数'
              }, {
                key: '退货收货数'
              }, {
                key: '差异-复议'
              }, {
                key: '复议单操作'
              }
            ],
            url: this.apis().reconsiderOrderList()
          },
          // PENDING_RECONCILED: {
          //   status: 'PENDING_RECONCILED',
          //   columns: [{
          //     key: '发货单号'
          //   }, {
          //     key: '产品名称'
          //   }, {
          //     key: '关联订单'
          //   }, {
          //     key: '发货数'
          //   }, {
          //     key: '关联收货单'
          //   }, {
          //     key: '收货数',
          //     props: {
          //       prop: 'receiptSheets'
          //     }
          //   }, {
          //     key: '关联退货单'
          //   }, {
          //     key: '退货数'
          //   }, {
          //     key: '差异数'
          //   }, {
          //     key: '关联复议单'
          //   }, {
          //     key: '复议数'
          //   }, {
          //     key: '发货操作'
          //   }],
          //   url: this.apis().shippingOrderList()
          // },
          // RECONCILED: {
          //   status: 'RECONCILED',
          //   columns: [{
          //     key: '发货单号'
          //   }, {
          //     key: '产品名称'
          //   }, {
          //     key: '关联订单'
          //   }, {
          //     key: '发货数'
          //   }, {
          //     key: '关联收货单'
          //   }, {
          //     key: '收货数',
          //     props: {
          //       prop: 'receiptSheets'
          //     }
          //   }, {
          //     key: '关联退货单'
          //   }, {
          //     key: '退货数'
          //   }, {
          //     key: '差异数'
          //   }, {
          //     key: '关联复议单'
          //   }, {
          //     key: '复议数'
          //   }, {
          //     key: '发货操作'
          //   }],
          //   url: this.apis().shippingOrderList()
          // },
          COMPLETED: {
            status: 'COMPLETED',
            columns: [{
              key: '发货单号'
            }, {
              key: '产品名称'
            }, {
              key: '关联订单-收货'
            }, {
              key: '合作商-收货'
            }, {
              key: '收货跟单员'
            }, {
              key: '发货收货数'
            }, {
              key: '退货收货数'
            }, {
              key: '差异-复议-通过'
            }, {
              key: '发货操作'
            }],
            url: this.apis().shippingOrderList()
          }
        },
        dataQuery: {}
      }
    },
    created() {
      this.dataQuery = this.getDataPerQuery('RECEIPT_SHEET');
      this.onResetQuery();
      this.onAdvancedSearch();
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
