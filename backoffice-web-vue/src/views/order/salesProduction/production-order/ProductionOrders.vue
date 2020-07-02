<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="4">
          <div class="orders-list-title">
            <!--            生产工单列表-->
            <h6>订单列表</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <production-order-toolbar @onSearch="onSearch" @onAdvancedSearch="onAdvancedSearch" @onCreate="onCreate" :queryFormData="queryFormData"/>
      <div>
        <div class="tag-container">
          <el-row type="flex" justify="start" align="middle">
            <h6 style="margin-bottom: 0px">标签：</h6>
            <el-button type="text" class="type-btn" :style="outBtnColor" @click="setQueryOrderType(true)">外发
            </el-button>
            <el-button type="text" class="type-btn" :style="selfBtnColor"
              @click="setQueryOrderType(false)">自产</el-button>
          </el-row>
        </div>
        <el-tabs v-model="activeStatus" @tab-click="handleClick">
          <template v-for="(item, index) in statues">
            <el-tab-pane :name="item.code" :key="index" :label="tabName(item)">
              <production-order-list :page="page" @onSearch="onSearch" @onAdvancedSearch="onAdvancedSearch"
                :vSelectRow.sync="selectRow" />
            </el-tab-pane>
          </template>
        </el-tabs>
      </div>
    </el-card>
    <el-dialog :visible.sync="outboundOrderTypeSelect" width="60%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <outbound-order-type-select-form v-if="outboundOrderTypeSelect" :formData="formData" />
    </el-dialog>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from "vuex";
  import Bus from '@/common/js/bus.js';

  const {
    mapGetters,
    mapActions,
    mapMutations
  } = createNamespacedHelpers(
    'ProductionOrderModule'
  );

  import ProductionOrderList from './list/ProductionOrderList';
  import ProductionOrderToolbar from './toolbar/ProductionOrderToolbar';
  import OutboundOrderTypeSelectForm from '../outbound-order/form/OutboundOrderTypeSelectForm'

  export default {
    name: 'ProductionOrders',
    components: {
      ProductionOrderList,
      ProductionOrderToolbar,
      OutboundOrderTypeSelectForm
    },
    computed: {
      ...mapGetters({
        page: 'page',
        keyword: 'keyword',
        contentData: 'detailData'
      }),
      outBtnColor: function () {
        if (this.queryFormData.orderType == '') {
          return 'color: #303133';
        }
        return this.queryFormData.orderType == 'OUTBOUND' ? 'color: #409EFF' : '#303133';
      },
      selfBtnColor: function () {
        if (this.queryFormData.orderType == '') {
          return 'color: #303133';
        }
        return this.queryFormData.orderType == 'SELF_PRODUCTION' ? 'color: #409EFF' : '#303133';
      }
    },
    methods: {
      ...mapActions({
        search: 'search',
        searchAdvanced: 'searchAdvanced',
      }),
      ...mapMutations({
        setIsAdvancedSearch: 'isAdvancedSearch',
        setDetailData: 'detailData'
      }),
      onSearch(page, size) {
        const keyword = this.keyword;
        const statuses = this.statuses;
        const url = this.apis().getProductionOrders();
        this.setIsAdvancedSearch(false);
        this.search({
          url,
          keyword,
          statuses,
          page,
          size
        });
      },
      onAdvancedSearch(page, size) {
        this.setIsAdvancedSearch(true);
        const query = this.queryFormData;
        const url = this.apis().getProductionOrders();
        this.searchAdvanced({
          url,
          query,
          page,
          size
        });
        this.productionOrderStateCount();
      },
      async productionOrderStateCount () {
        const url = this.apis().productionOrderStateCount();
        const result = await this.$http.get(url);
        this.stateCount = result.data;
      },
      tabName (tab) {
        if (this.stateCount.hasOwnProperty(tab.code)) {
          return tab.name +'('+ this.stateCount[tab.code] +')';  
        }
        return tab.name;
      },
      handleClick(tab, event) {
        if (tab.name == '') {
          this.queryFormData.excludeState = 'TO_BE_ALLOCATED';
          this.queryFormData.state = null;
        } else {
          this.queryFormData.state = tab.name;
        }
        this.onAdvancedSearch();
      },
      setQueryOrderType (flag) {
        if (flag) {
          this.queryFormData.orderType = 'OUTBOUND';
        } else {
          this.queryFormData.orderType = 'SELF_PRODUCTION';
        } 
      },
      onCreate() {
        let row = [];
        this.selectRow.forEach(item => {
          let progressPlan = {
            name: '',
            remarks: '',
            productionProgresses: []
          }
          if (item.progressWorkSheet) {
            progressPlan = this.copyProgressPlan({
              name: '节点方案1',
              remarks: '',
              productionProgresses: item.progressWorkSheet.progresses
            })
            progressPlan.isFromOrder = true;
          }
          row.push({
            originOrder: {
              id: item.id
            },
            unitPrice: '',
            deliveryDate: '',
            shippingAddress: item.shippingAddress,
            product: item.product,
            progressPlan: progressPlan,
            colorSizeEntries: item.colorSizeEntries
          })
        })
        this.formData.taskOrderEntries = row;
        // this.outboundOrderTypeSelect = true;
        this.$router.push({
          name: '创建外发订单',
          params: {
            formData: Object.assign({}, this.formData)
          }
        });
      },
      copyProgressPlan(val) {
        let row = {
          name: val.name,
          remarks: val.remarks,
          productionProgresses: []
        }
        val.productionProgresses.forEach(item => {
          row.productionProgresses.push({
            progressPhase: item.progressPhase,
            warningDays: item.warningDays,
            medias: item.medias,
            completeAmount: item.completeAmount,
            productionProgressOrders: item.productionProgressOrders,
            quantity: item.quantity,
            sequence: item.sequence,
            isCannotRemove: true
          })
        })
        return row;
      }
    },
    data() {
      return {
        activeStatus: 'TO_BE_PRODUCED',
        statues: Object.assign([], this.$store.state.EnumsModule.ProductionTaskOrderState),
        outboundOrderTypeSelect: false,
        selectRow: [],
        queryFormData: {
          code: '',
          requirementOrderCode: '',
          skuID: '',
          expectedDeliveryDateFrom: null,
          expectedDeliveryDateTo: null,
          createdDateFrom: null,
          createdDateTo: null,
          keyword: '',
          categories: [],
          state: 'TO_BE_PRODUCED'
        },
        formData: {
          id: null,
          managementMode: 'COLLABORATION',
          outboundCompanyName: '',
          outboundContactPerson: '',
          outboundContactPhone: '',
          targetCooperator: {
            id: ''
          },
          taskOrderEntries: [{
            originOrder: {
              id: ''
            },
            unitPrice: '',
            deliveryDate: '',
            shippingAddress: {},
            product: {

            },
            progressPlan: {
              name: ''
            },
            colorSizeEntries: []
          }],
          cooperationMode: 'LABOR_AND_MATERIAL',
          invoiceNeeded: false,
          invoiceTaxPoint: 0.03,
          freightPayer: 'PARTYA',
          remarks: '',
          sendAuditNeeded: false,
          payPlan: {
            name: '',
            isHaveDeposit: false,
            payPlanType: 'PHASEONE',
            payPlanItems: [{
              moneyType: 'PHASEONE',
              payPercent: 0.003,
              triggerDays: 5,
              triggerEvent: 'ORDER_CONFIRMED',
              triggerType: 'INSIDE'
            }]
          },
          attachments: [],
          sendApprovers: [{
            id: ''
          }]
        },
        stateCount: {}
      };
    },
    created() {
      this.onAdvancedSearch();
      this.statues.push({
        code: '',
        name: '全部'
      })
    },
    mounted() {

    },
    destroyed() {
    }
  };

</script>
<style>
  .report {
    margin-bottom: 10px;
  }

  .orders-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .purchase-dialog .el-dialog {
    border-radius: 10px !important;
  }

  .purchase-dialog-header {
    padding: 0px !important;
  }

  .purchase-dialog .el-dialog__header {
    padding: 0px !important;
  }

  .tag-container {
    position: absolute;
    right: 150px;
    margin-top: 4px;
    z-index: 999;
  }

  .type-btn {
    font-size: 14px;
    color: #303133;
    padding-left: 20px;
  }

  .type-btn:focus {
    outline: 0;
  }

</style>
