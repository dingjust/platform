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
      <production-order-toolbar @onSearch="onSearch" @onAdvancedSearch="onAdvancedSearch" @onCreate="onCreate"/>
      <el-tabs v-model="activeStatus" @tab-click="handleClick">
        <template v-for="(item, index) in statues">
          <el-tab-pane :name="item.code" :key="index" :label="item.name">
            <production-order-list :page="page" @onSearch="onSearch" @onAdvancedSearch="onAdvancedSearch" :vSelectRow.sync="selectRow"/>
          </el-tab-pane>
        </template>
      </el-tabs>
    </el-card>
    <el-dialog :visible.sync="outboundOrderTypeSelect" width="60%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <outbound-order-type-select-form v-if="outboundOrderTypeSelect" :formData="formData"/>
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
        queryFormData: 'queryFormData',
        contentData: 'detailData'
      })
    },
    methods: {
      ...mapActions({
        search: 'search',
        searchAdvanced: 'searchAdvanced',
        clearQueryFormData: 'clearQueryFormData'
      }),
      ...mapMutations({
        setIsAdvancedSearch: 'isAdvancedSearch',
        setDetailData: 'detailData'
      }),
      onSearch(page, size) {
        const keyword = this.keyword;
        const statuses = this.statuses;
        const url = this.apis().getProductionOrders();
        // const url = this.apis().getPurchaseOrders();
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
        // const url = this.apis().getPurchaseOrders();
        this.searchAdvanced({
          url,
          query,
          page,
          size
        });
      },
      handleClick(tab, event) {
        // console.log(tab.name);
        if (tab.name == 'ALL') {
          this.queryFormData.statuses = [];
          this.onAdvancedSearch();
        } else {
          this.queryFormData.statuses = [tab.name];
          this.onAdvancedSearch();
        }
      },
      onCreate () {
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
            originOrder: {id: item.id},
            unitPrice: '',
            deliveryDate: '',
            shippingAddress: item.shippingAddress,
            product: item.product,
            progressPlan: progressPlan,
            colorSizeEntries: item.colorSizeEntries
          })
        })
        this.formData.taskOrderEntries = row;
        this.outboundOrderTypeSelect = true;
      },
      copyProgressPlan (val) {
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
        activeStatus: 'ALL',
        statues: [{
          code: 'ALL',
          name: '全部'
        }],
        outboundOrderTypeSelect: false,
        selectRow: [],
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
      };
    },
    created() {
      this.$store.state.EnumsModule.purchaseOrderStatuses.forEach(element => {
        this.statues.push(element);
      });
      this.onSearch();
    },
    mounted() {

    },
    destroyed() {
      this.clearQueryFormData();
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

</style>
