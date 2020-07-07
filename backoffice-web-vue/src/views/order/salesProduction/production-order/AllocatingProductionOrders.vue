<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="4">
          <div class="orders-list-title">
            <!--            待分配列表-->
            <h6>待分配列表</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <production-order-toolbar @onSearch="onSearch" @onAdvancedSearch="onAdvancedSearch" @onCreate="onCreate"
        @onAllocating="onAllocating" :isAllocating="true" :queryFormData="queryFormData"/>
      <el-tabs v-model="activeStatus" @tab-click="handleClick">
        <template v-for="(item, index) in statues">
          <el-tab-pane :name="item.code" :key="index" :label="item.name">
            <production-order-list :page="page" @onSearch="onSearch" @onAdvancedSearch="onAdvancedSearch"
              :vSelectRow.sync="selectRow" :isAllocating="true"/>
          </el-tab-pane>
        </template>
      </el-tabs>
    </el-card>
    <el-dialog :visible.sync="outboundOrderTypeSelect" width="60%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <outbound-order-type-select-form v-if="outboundOrderTypeSelect" :formData="formData" />
    </el-dialog>
    <el-dialog :visible.sync="allocatingVisible" width="40%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <allocating-form v-if="allocatingVisible" :slotData="selectRow" @onCallback="onCallback"></allocating-form>  
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
  import AllocatingForm from './components/AllocatingForm'

  export default {
    name: 'ProductionOrders',
    components: {
      ProductionOrderList,
      ProductionOrderToolbar,
      OutboundOrderTypeSelectForm,
      AllocatingForm
    },
    computed: {
      ...mapGetters({
        page: 'page',
        keyword: 'keyword',
        contentData: 'detailData'
      })
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
      },
      handleClick(tab, event) {
        this.queryFormData.state = [tab.name];
        this.onAdvancedSearch();
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
        this.outboundOrderTypeSelect = true;
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
      },
      // 分配跟单员
      onAllocating () {
        if (this.selectRow.length <= 0) {
          this.$message.warning('请选择要进行分配操作的工单');
          return;
        }
        this.allocatingVisible = true;
      },
      onCallback (flag) {
        if (flag) {
          this.onAdvancedSearch(0, 10);
        }
        this.allocatingVisible = false;
      }
    },
    data() {
      return {
        activeStatus: 'TO_BE_ALLOCATED',
        statues: [{
          code: 'TO_BE_ALLOCATED',
          name: '待分配'
        }],
        outboundOrderTypeSelect: false,
        allocatingVisible: false,
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
          state: 'TO_BE_ALLOCATED'
        }
      };
    },
    created() {
      this.onAdvancedSearch();
    },
    mounted() {

    },
    destroyed() {}
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
