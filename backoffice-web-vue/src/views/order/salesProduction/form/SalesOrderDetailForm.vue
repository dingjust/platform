<template>
  <div>
    <div class="sales-plan-box">
      <el-row type="flex">
        <el-col :span="10">
          <!-- <MTAVAT v-if="modifyType" :machiningTypes.sync="form.cooperationMode" :needVoice.sync="form.invoiceNeeded"
            :tax.sync="form.invoiceTaxPoint" :layoutScale="mtavatLayoutScale" class="basic-form-row" /> -->
          <el-row type="flex" justify="start" class="basic-form-row">
            <el-col :span="8">
              <el-row type="flex" align="middle">
                <h6 class="sales-plan-h6"><span class="info-title">单号：</span>{{form.code}}
                </h6>
              </el-row>
            </el-col>
            <el-col :span="8">
              <el-row type="flex" align="middle">
                <h6 class="sales-plan-h6"><span
                    class="info-title">合作方式：</span>{{getEnum('cooperationModes', form.cooperationMode)}}
                </h6>
              </el-row>
            </el-col>
            <el-col :span="8">
              <el-row type="flex" align="middle">
                <h6 class="sales-plan-h6"><span class="info-title">是否开发票：</span>{{form.invoiceNeeded ? '开发票' : '不开发票'}}
                </h6>
              </el-row>
            </el-col>
          </el-row>
          <el-row type="flex" justify="start" class="basic-form-row">
            <el-col :span="8">
              <el-row type="flex" align="middle">
                <h6 class="sales-plan-h6"><span class="info-title">生产总数：</span>{{totalAmount}}</h6>
              </el-row>
            </el-col>
            <el-col :span="8">
              <el-row type="flex" align="middle">
                <h6 class="sales-plan-h6"><span class="info-title">生产总价：</span>{{totalPrice}}元</h6>
              </el-row>
            </el-col>
          </el-row>
          <el-row type="flex" justify="start" class="basic-form-row" v-if=" form.type == 'SALES_ORDER'"
            v-popover:popover>
            <h6 class="sales-plan-h6"><span class="info-title">财务</span></h6>
          </el-row>
          <el-row type="flex" justify="start" class="basic-form-row" v-if="form.type == 'SALES_ORDER'"
            v-popover:popover>
            <el-col :span="8">
              <h6 class="sales-plan-h6"><span
                  class="info-title">有无定金：</span>{{form.payPlan.isHaveDeposit ? '有定金' : '无定金'}}</h6>
            </el-col>
            <el-col :span="8">
              <h6 class="sales-plan-h6"><span class="info-title">尾款期数：</span>{{payPlanType[form.payPlan.payPlanType]}}
              </h6>
            </el-col>
          </el-row>
        </el-col>
        <el-divider direction="vertical"></el-divider>
        <el-col :span="8">
          <template v-if="form.type==='SALES_ORDER'">
            <el-row type="flex" justify="start" class="basic-form-row">
              <el-col :span="24">
                <h6 class="sales-plan-h6"><span class="info-title">合作商：</span>{{cooperator.name}}</h6>
              </el-col>
            </el-row>
            <el-row type="flex" justify="start" class="basic-form-row">
              <el-col :span="12">
                <h6 class="sales-plan-h6"><span class="info-title">联系人：</span>{{cooperator.contactPerson}}</h6>
              </el-col>
              <el-col :span="12">
                <h6 class="sales-plan-h6"><span class="info-title">联系电话：</span>
                  {{cooperator.contactPhone}}</h6>
              </el-col>
            </el-row>
          </template>
          <el-row type="flex" justify="start" class="basic-form-row" style="margin-top:10px">
            <h6 class="info-title">人员设置</h6>
          </el-row>
          <el-row type="flex" justify="start" class="basic-form-row">
            <el-col :span="12">
              <h6 class="sales-plan-h6"><span class="info-title">创建人：</span>{{form.creator!=null?form.creator.name:''}}
              </h6>
            </el-col>
            <el-col :span="12">
              <h6 class="sales-plan-h6"><span class="info-title">审批负责人：</span>
                {{(form.approvers!=null&&form.approvers[0]!=null)?form.approvers[0].name:''}}</h6>
            </el-col>
          </el-row>
          <el-row type="flex" justify="start" class="basic-form-row">
            <el-row type="flex" align="middle">
              <h6 class="sales-plan-h6"><span class="info-title">生产负责人：</span>
                {{form.productionLeader!=null?form.productionLeader.name:''}}</h6>
            </el-row>
          </el-row>
        </el-col>
        <el-divider direction="vertical"></el-divider>
        <el-col :span="6">
          <contract-com v-if="form.type == 'SALES_ORDER'" :slotData="form" :contracts="contracts" :canSign="canSign" />
        </el-col>
      </el-row>
    </div>
    <el-popover ref="popover" placement="top-start" width="500" trigger="hover" v-if="form.type == 'SALES_ORDER'">
      <pay-plan-info :form="payPlan"></pay-plan-info>
    </el-popover>
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
  import ContractCom from '../contract/ContractCom';
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
        let total = 0;
        if (this.form.taskOrderEntries != null) {
          this.form.taskOrderEntries.forEach(element => {
            let num = parseFloat(getEntryTotalPrice(element));
            if (num != null && (!Number.isNaN(num))) {
              total += num;
            }
          });
        }
        return total;
      },
      // 已签的合同列表
      contracts: function () {
        return this.form.agreements ? this.form.agreements : [];
      },
      // 判断是否能签署合同
      canSign: function () {
        // 未签合同 && 账号为productionleader && 审核状态为 PASSED
        if (this.form.productionLeader != null) {
          return this.form.agreements.length <= 0 &&
            this.$store.getters.currentUser.uid == this.form.productionLeader.uid &&
            this.form.auditState == 'PASSED' &&
            this.form.acceptState == 'ACCEPTED';
        } else {
          return false;
        }
      }
    },
    components: {
      ContractCom,
      MTAVAT,
      PurchaseOrderInfoContract,
      PersonnelSelection,
      PayPlanInfo
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
    created() {}
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
    margin-top: 1px;
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
    padding-top: 8px;
    font-size: 12px;
  }

  .sales-plan-box>>>.el-input__inner {
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

  .sales-plan-box>>>.el-form-item--mini.el-form-item,
  .el-form-item--small.el-form-item {
    margin-bottom: 5px;
  }

  .sales-plan-box>>>.el-divider--vertical {
    height: auto;
  }

</style>
