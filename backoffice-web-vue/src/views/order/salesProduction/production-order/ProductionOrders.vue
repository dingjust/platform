<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col>
          <div class="orders-list-title">
            <h6>生产工单列表</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <production-order-toolbar @onSearch="onSearch" @onAdvancedSearch="onAdvancedSearch" @onAllocating="onAllocating"
        @onCreate="onCreate" :queryFormData="queryFormData" :isAllocating="isAllocating" :dataQuery="dataQuery"
        @onResetQuery="onResetQuery" />
      <div>
        <div class="tag-container" :class="tagPosition ? 'tag-position' : ''">
          <el-row ref="tag" type="flex" justify="end" align="middle" v-if="!isAllocating">
            <h6 style="margin-bottom: 0px">标签：</h6>
            <el-button class="type-btn" :style="allBtnColor" @click="setQueryOrderType('')">全部
            </el-button>
            <el-button class="type-btn" :style="outBtnColor" @click="setQueryOrderType('FOUNDRY_PRODUCTION')">外发
            </el-button>
            <el-button class="type-btn" :style="selfBtnColor" @click="setQueryOrderType('SELF_PRODUCED')">自产
            </el-button>
            <authorized :permission="['OUT_ORDER_CREATE']">
              <el-button v-if="!isAllocating" type="primary" class="create-button" @click="onCreate">创建外发订单
              </el-button>
            </authorized>
          </el-row>
          <el-row type="flex" justify="end" align="middle" v-else>
            <authorized :permission="['PRODUCTION_TASK_ASSIGN']">
              <el-button v-if="isAllocating" type="primary" class="create-button" @click="onAllocating">去分配</el-button>
            </authorized>
          </el-row>
        </div>
        <!-- <div class="tag-container tag-position" style="right: 96px" v-else>
          <el-row type="flex" justify="end" align="middle">
            <el-col :span="6">
              <authorized :permission="['PRODUCTION_TASK_ASSIGN']">
                <el-button v-if="isAllocating" type="primary" class="create-button" @click="onAllocating">去分配</el-button>
              </authorized>
            </el-col>
          </el-row>
        </div> -->
        <el-tabs ref="tabs" v-model="activeStatus" @tab-click="handleClick">
          <template v-for="(item, index) in statues">
            <el-tab-pane ref="pane" :name="item.code" :key="index" :label="tabName(item)">
              <production-order-list :page="page" @onSearch="onSearch" @onAdvancedSearch="onAdvancedSearch"
                :vSelectRow.sync="selectRow" :isAllocating="isAllocating" />
            </el-tab-pane>
          </template>
        </el-tabs>
      </div>
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
    'ProductionOrdersModule'
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
      }),
      allBtnColor: function () {
        return this.queryFormData.type == '' ? 'color: #409EFF' : '#303133';
      },
      outBtnColor: function () {
        if (this.queryFormData.type == '') {
          return 'color: #303133';
        }
        return this.queryFormData.type == 'FOUNDRY_PRODUCTION' ? 'color: #409EFF' : '#303133';
      },
      selfBtnColor: function () {
        if (this.queryFormData.type == '') {
          return 'color: #303133';
        }
        return this.queryFormData.type == 'SELF_PRODUCED' ? 'color: #409EFF' : '#303133';
      },
      isAllocating: function () {
        return this.queryFormData.state === 'TO_BE_ALLOCATED';
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
      async onSearch(page, size) {
        const keyword = this.keyword;
        const statuses = this.statuses;
        const url = this.apis().getProductionOrders();
        this.setIsAdvancedSearch(false);
        await this.search({
          url,
          keyword,
          statuses,
          page,
          size
        });
      },
      async onAdvancedSearch(page, size) {
        if (this.queryFormData.users.length <= 0 && this.queryFormData.depts.length <= 0) {
          this.onResetQuery();
        }
        this.setIsAdvancedSearch(true);
        const query = this.queryFormData;
        const url = this.apis().getProductionOrders();
        await this.searchAdvanced({
          url,
          query,
          page,
          size
        });
        this.productionOrderStateCount();
      },
      async productionOrderStateCount() {
        const url = this.apis().productionOrderStateCount();
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
        this.statues.forEach(item => {
          if (item.code === '') {
            count += document.getElementById("tab-" + (this.statues.length - 1)).scrollWidth
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
      handleClick(tab, event) {
        if (tab.name == '') {
          this.queryFormData.excludeState = 'TO_BE_ALLOCATED';
          this.queryFormData.state = null;
        } else {
          this.queryFormData.state = tab.name;
        }
        this.onAdvancedSearch();
      },
      setQueryOrderType(flag) {
        this.queryFormData.type = flag;
        this.onAdvancedSearch();
      },
      // 分配跟单员
      onAllocating() {
        if (this.selectRow.length <= 0) {
          this.$message.warning('请选择要进行分配操作的工单');
          return;
        }
        this.allocatingVisible = true;
      },
      onCallback(flag) {
        if (flag) {
          this.onAdvancedSearch(0, 10);
        }
        this.allocatingVisible = false;
      },
      onCreate() {
        let form = null;
        if (this.selectRow.length > 0) {
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
              deliveryDate: item.deliveryDate,
              shippingAddress: item.shippingAddress,
              product: item.product,
              progressPlan: progressPlan,
              colorSizeEntries: item.colorSizeEntries
            })
          })
          this.formData.taskOrderEntries = row;
          // this.outboundOrderTypeSelect = true;
          form = this.formData;
        }
        this.$router.push({
          name: '创建外发订单',
          params: {
            formData: form
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
      },
      onResetQuery() {
        this.queryFormData = JSON.parse(JSON.stringify(Object.assign(this.queryFormData, this.dataQuery)));
      }
    },
    data() {
      return {
        activeStatus: 'TO_BE_PRODUCED',
        statues: Object.assign([], this.$store.state.EnumsModule.ProductionTaskOrderState),
        outboundOrderTypeSelect: false,
        selectRow: [],
        allocatingVisible: false,
        queryFormData: {
          createdDateFrom: null,
          createdDateTo: null,
          keyword: '',
          categories: [],
          state: 'TO_BE_PRODUCED',
          type: ''
        },
        tagPosition: true,
        tagWidth: 0,
        formData: {
          id: null,
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
          freightPayer: 'PARTYB',
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
        stateCount: {
        },
        dataQuery: {}
      };
    },
    created() {
      this.dataQuery = this.getDataPerQuery('PRODUCTION_TASK_ORDER');
      this.onResetQuery();
      this.onAdvancedSearch();
      this.statues.push({
        code: '',
        name: '全部'
      })
    },
    mounted() {
      let that = this;
      window.addEventListener('resize', function () {
        that.$nextTick(() => {
          that.changeTagPosition();
        })
      })
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

  .tag-position {
    position: absolute;
  }

  .tag-container {
    right: 35px;
    margin-top: 4px;
    z-index: 999;
  }

  .type-btn {
    color: #303133;
    padding-left: 20px;
  }

  .type-btn:focus {
    outline: 0;
  }

  .create-button {
    background-color: #ffd60c;
    border-color: #DCDFE6;
    width: 100px;
    color: #606266;
  }

  .create-button:hover {
    background-color: #ffd60c;
    border-color: #DCDFE6;
    width: 100px;
    color: #606266;
  }

</style>
