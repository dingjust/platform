<template>
  <div>
    <el-row type="flex" :gutter="10">
      <el-col :span="18">
        <el-row type="flex" justify="start" style="margin-left: 15px;">
          <h6>订单基本信息</h6>
        </el-row>
        <el-row type="flex" justify="start" style="margin-left: 24px;">
          <el-col :span="9">
            <h6 class="sales-plan-h6"><span class="info-title">合作商：</span>{{cooperator.name}}</h6>
          </el-col>
          <el-col :span="5">
            <h6 class="sales-plan-h6"><span
              class="info-title">合作方式：</span>{{getEnum('cooperationModes', form.cooperationMode)}}
            </h6>
          </el-col>
          <el-col :span="6">
            <h6 class="sales-plan-h6"><span
              class="info-title">是否开票：</span>{{form.invoiceNeeded ? '开发票' : '不开发票'}}
              <span style="margin-left:5px" v-if="form.invoiceNeeded">{{form.invoiceTaxPoint * 100}}%</span>
            </h6>
          </el-col>
          <el-col :span="4">
            <h6 class="sales-plan-h6"><span class="info-title">订单数量：</span>{{totalAmount}}</h6>
          </el-col>
        </el-row>
        <el-row type="flex" justify="start" style="margin-left: 24px;">
          <el-col :span="9">
            <h6 class="sales-plan-h6"><span class="info-title">订单金额：</span>{{totalPrice.toFixed(2)}}元</h6>
          </el-col>
          <el-col :span="5">
            <h6 class="sales-plan-h6-hide">
              <span class="info-title">创建人：</span>
              <span :title="form.creator!=null?form.creator.name:''">
                  {{form.creator!=null?form.creator.name:''}}
                </span>
            </h6>
          </el-col>
          <el-col :span="6">
            <h6 class="sales-plan-h6-hide">
              <span class="info-title">跟单员：</span>
              <span :title="form.productionLeader!=null?form.productionLeader.name:''">
                    {{form.productionLeader!=null?form.productionLeader.name:''}}
                  </span>
            </h6>
          </el-col>
          <el-col :span="4">
            <h6 class="sales-plan-h6-hide">
              <span class="info-title">审批人：</span>
              <span :title="(form.approvers!=null&&form.approvers[0]!=null)?form.approvers[0].name:''">
                  {{(form.approvers!=null&&form.approvers[0]!=null)?form.approvers[0].name:''}}
                </span>
            </h6>
          </el-col>
        </el-row>
        <template v-if="form.type == 'SALES_ORDER'">
          <el-row type="flex" justify="start" style="margin-left: 24px;">
            <el-col :span="12">
              <h6 class="sales-plan-h6" style="display: inline-block;" v-popover:popover><span
                class="info-title">定金：</span>{{form.payPlan.isHaveDeposit ? '有定金' : '无定金'}} + {{getEnum('PayPlanType', form.payPlan.payPlanType)}}</h6>
            </el-col>
          </el-row>
          <el-popover ref="popover" placement="top-start" width="600" trigger="hover">
            <h6 v-html="getHtmlText(form.payPlan.previewText)"></h6>
          </el-popover>
        </template>
      </el-col>
      <el-col :span="6">
        <div class="info-box">
          <production-contract :slotData="form" :contracts="contracts" :canSign="canSign"
                               :isSignedPaper="isSignedPaper" @callback="callback"/>
        </div>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  import {
    accMul
  } from '@/common/js/number';

  import {
    getEntryTotalAmount,
    getEntryTotalPrice,
    getEntryTotalCost,
    getEntryProfit,
    getEntryProfitPercent
  } from '../js/accounting.js';

  import MTAVAT from '@/components/custom/order-form/MTAVAT';
  import PurchaseOrderInfoContract from '@/views/order/purchase/info/PurchaseOrderInfoContract';
  import PersonnelSelection from '@/components/custom/PersonnelSelection';
  import ProductionContract from '@/views/order/salesProduction/components/ProductionContract'
  import {
    PayPlanInfo
  } from '@/components/'

  export default {
    name: 'SalesOrderDetailForm',
    computed: {
      cooperator: function () {
        if (this.form.originCooperator != null) {
          if (this.form.originCooperator.type == 'ONLINE') {
            return Object.assign({}, this.form.originCooperator.partner);
          } else {
            return Object.assign({}, this.form.originCooperator);
          }
        } else {
          return {
            name: '',
            contactPerson: '',
            contactPhone: ''
          }
        }
      },
      // 总数量
      totalAmount: function () {
        let total = 0;
        if (this.form.taskOrderEntries != null) {
          this.form.taskOrderEntries.forEach(element => {
            let num = parseFloat(getEntryTotalAmount(element));
            if (num != null && (!Number.isNaN(num))) {
              total += num;
            }
          });
        }
        return total;
      },
      // 销售总价
      totalPrice: function () {
        if (this.form.totalAmount) {
          return this.form.totalAmount;
        }
        let total = 0;
        if (this.form.taskOrderEntries != null) {
          this.form.taskOrderEntries.forEach(element => {
            let num = element.totalPrimeCost ? element.totalPrimeCost : parseFloat(getEntryTotalPrice(element));
            if (num != null && (!Number.isNaN(num))) {
              total += num;
            }
          });
        }
        return total;
      },
      // 已签的合同列表
      contracts: function () {
        if (this.form.agreements) {
          return this.form.agreements.filter(item => item.state !== 'INVALID');
        }
        return [];
      },
      // 判断是否能创建合同
      canSign: function () {
        if (this.contracts.length > 0) {
          return false;
        }

        if (!this.form.creator) {
          return false
        }

        // 销售计划没有上流，随意可以添加纸质合同
        if (!this.form.originCompany && (this.$store.getters.currentUser.uid === this.form.creator.uid)) {
          return true;
        } else {
          return (this.form.state === 'AUDIT_PASSED' || this.form.state === 'COMPLETED') &&
                   this.$store.getters.currentUser.uid === this.form.creator.uid;
        }
      },
      isSignedPaper: function () {
        if (this.form.originCompany) {
          return false;
        }
        // 没有来源公司，只能签署纸质合同
        return true;
      }
    },
    components: {
      MTAVAT,
      PurchaseOrderInfoContract,
      PersonnelSelection,
      PayPlanInfo,
      ProductionContract
    },
    props: {
      form: {
        type: Object
      },
      modifyType: {
        type: Boolean,
        default: false
      },
      payPlan: {
        type: Object
      }
    },
    methods: {
      callback() {
        this.$emit('callback');
      },
      getHtmlText(text) {
        if (text === undefined) {
          return '';
        }
        return text.replace(/\n/g, '</br></br>');
      }
    },
    data() {
      return {
        machiningTypes: this.$store.state.EnumsModule.cooperationModes,
        mtavatLayoutScale: [9, 9, 6],
        options: [{
          label: this.$store.getters.currentUser.username,
          value: {
            id: this.$store.getters.currentUser.id,
            name: this.$store.getters.currentUser.username
          }
        }],
        payPlanType: {
          'PHASEONE': '一期尾款',
          'PHASETWO': '二期尾款',
          'MONTHLY_SETTLEMENT': '月结'
        }
      }
    },
    created() {
    }
  }

</script>

<style scoped>
  .info-title {
    font-weight: bold;
    font-size: 14px;
    border: none
  }

  .sales-plan-box {
    display: table;
    margin: 0 auto;
    width: 100%;
  }

  .sales-plan-one {
    width: 100%;
    display: table-cell;
  }

  .sales-plan-three {
    width: 1%;
    display: table-cell;
  }

  .sales-plan-two {
    width: 100%;
    display: table-cell;
    z-index: 100;
  }

  .sales-plan-triangle_box {
    /* margin-top: 1px; */
    position: absolute;
    right: 0;
    top: 0;
  }

  .sales-plan-triangle {
    width: 0;
    height: 0;
    border-right: 70px solid white;
    border-bottom: 70px solid transparent;
    z-index: 0;
  }

  .sales-plan-triangle_text {
    width: 80px;
    padding-top: 10px;
    padding-left: 30px;
    transform: rotateZ(45deg);
  }

  .sales-border-container {
    /* border: 1px solid #DCDFE6;
    border-radius: 5px; */
    width: 100%;
    padding-top: 10px;
  }

  .basic-form-row {
    width: 100%;
    padding-left: 10px;
  }

  .material-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    width: 90px;
    height: 35px;
  }

  .sales-plan-h6 {
    white-space: nowrap;
    padding-top: 8px;
    font-size: 12px;
  }

  .sales-plan-h6-hide {
    padding-top: 8px;
    font-size: 12px;
    text-overflow: ellipsis;
    overflow: hidden;
    white-space: nowrap;
  }

  .sales-plan-box >>> .el-input__inner {
    height: 24px;
    line-height: 24px;
    border-radius: 2px;
    padding: 0px;
  }

  .sales-radio {
    margin-top: 8px
  }

  .over-tabs {
    position: absolute;
    z-index: 100;
    right: 30px;
    margin-top: 2px;
  }

  .sales-plan-box >>> .el-form-item--mini.el-form-item,
  .el-form-item--small.el-form-item {
    margin-bottom: 5px;
  }

  .sales-plan-box >>> .el-divider--vertical {
    height: auto;
  }

  .info-box {
    width: 100%;
    height: 100%;
    border: 1px solid #dcdfe6;
    border-radius: 10px;
    padding: 5px 0px 0px 5px;
  }

</style>
