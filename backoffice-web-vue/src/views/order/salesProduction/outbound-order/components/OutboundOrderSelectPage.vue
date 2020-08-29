<template>
  <div>
    <outbound-order-toolbar @onAdvancedSearch="onAdvancedSearch" @createOutboundOrder="createOutboundOrder"
      :queryFormData="queryFormData" :isSelect="true"/>
    <div>
      <el-tabs v-model="activeName" @tab-click="handleClick">
        <template v-for="item in statuses">
          <el-tab-pane :label="tabName(item)" :name="item.code" :key="item.code">
            <outbound-order-list :page="page" @onAdvancedSearch="onAdvancedSearch" :isSelect="true"
                                  @onModify="onModify" @setSelectOrder="setSelectOrder"/>
          </el-tab-pane>
        </template>
      </el-tabs>
    </div>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';

  const {
    mapGetters,
    mapActions,
    mapMutations
  } = createNamespacedHelpers(
    'OutboundOrderModule'
  );

  import OutboundOrderToolbar from '../toolbar/OutboundOrderToolbar';
  import OutboundOrderList from '../list/OutboundOrderList';
  import OutboundOrderTypeSelectForm from '../form/OutboundOrderTypeSelectForm';
  export default {
    name: 'OutboundOrderPage',
    components: {
      OutboundOrderTypeSelectForm,
      OutboundOrderList,
      OutboundOrderToolbar
    },
    computed: {
      ...mapGetters({
        page: 'page',
        keyword: 'keyword'
      }),
      outBtnColor: function () {
        if (this.queryFormData.hasContact == '') {
          return 'color: #303133';
        }
        return this.queryFormData.hasContact == 'hasContact' ? 'color: #409EFF' : '#303133';
      },
      selfBtnColor: function () {
        if (this.queryFormData.hasContact == '') {
          return 'color: #303133';
        }
        return this.queryFormData.hasContact == 'notHasContact' ? 'color: #409EFF' : '#303133';
      }
    },
    methods: {
      ...mapActions({
        search: 'search',
        searchAdvanced: 'searchAdvanced'
      }),
      ...mapMutations({
        setIsAdvancedSearch: 'isAdvancedSearch',
        setDetailData: 'detailData'
      }),
      onSearch(page, size) {
        const keyword = this.keyword;
        const url = this.apis().getoutboundOrdersList();
        this.setIsAdvancedSearch(false);
        this.search({
          url,
          keyword,
          page,
          size
        });
      },
      onAdvancedSearch(page, size) {
        const query = this.queryFormData;
        const url = this.apis().getoutboundOrdersList();
        this.setIsAdvancedSearch(true);
        this.searchAdvanced({
          url,
          query,
          page,
          size
        });
        this.outboundOrderStateCount();
      },
      createOutboundOrder() {
        // this.outboundOrderTypeSelect = true;
        this.$router.push({
          name: '创建外发订单',
          params: {
            formData: Object.assign({}, this.formData)
          }
        });
      },
      async outboundOrderStateCount() {
        const url = this.apis().outboundOrderStateCount();
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
      handleClick(tab, event) {
        this.queryFormData.state = tab.name;
        this.onAdvancedSearch();
      },
      setQuery(flag) {
        if (flag) {
          this.queryFormData.hasContact = 'hasContact';
        } else {
          this.queryFormData.hasContact = 'notHasContact';
        }
      },
      async onModify(id) {
        const url = this.apis().getoutboundOrderDetail(id);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        let formData = this.setFormData(result.data);
        await this.$router.push({
          name: '创建外发订单',
          params: {
            formData: formData
          }
        });
      },
      setFormData (data) {
        let formData = {
          id: data.id,
          managementMode: data.managementMode,
          outboundCompanyName: data.targetCooperator.type == 'ONLINE' ? data.targetCooperator.partner.name : data.targetCooperator.name,
          outboundContactPerson: data.targetCooperator.type == 'ONLINE' ? data.targetCooperator.partner.contactPerson : data.targetCooperator.contactPerson,
          outboundContactPhone: data.targetCooperator.type == 'ONLINE' ? data.targetCooperator.partner.contactPhone : data.targetCooperator.contactPhone,
          targetCooperator: {
            id: data.targetCooperator.id
          },
          taskOrderEntries: data.taskOrderEntries,
          cooperationMode: data.cooperationMode,
          invoiceNeeded: data.invoiceNeeded,
          invoiceTaxPoint: data.invoiceTaxPoint,
          freightPayer: data.freightPayer,
          remarks: data.remarks,
          sendAuditNeeded: data.sendAuditNeeded,
          payPlan: data.payPlan,
          attachments: data.attachments ? data.attachments : [],
          sendApprovers: data.sendApprovers,
          merchandiser: data.merchandiser
        }
        return formData;
      },
      setSelectOrder (row) {
        this.$emit('setSelectOrder', row);
      }
    },
    data() {
      return {
        outboundOrderTypeSelect: false,
        activeName: 'AUDIT_PASSED',
        statuses: [{
          code: 'AUDIT_PASSED',
          name: '生产中'
        }, {
          code: 'COMPLETED',
          name: '已完成'
        }],
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
        queryFormData: {
          keyword: '',
          targetCooperator: '',
          merchandiser: '',
          state: 'AUDIT_PASSED',
          name: '',
          merchandiserPk: 'isMyself'
        },
        stateCount: {}
      }
    },
    created() {
      this.onAdvancedSearch();
    },
    mounted() {

    },
    destroyed() {}
  };

</script>

<style scoped>
  .outbound-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
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
