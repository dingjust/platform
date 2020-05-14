<template>
  <div style="margin-top: 20px">
    <el-row type="flex" justify="start">
      <el-col :span="16">
        <el-row type="flex" justify="start">
          <el-col :span="12">
            <div class="outbound-list-title">
              <h6><span>财务</span><span style="color: #909399">(当前选用'森马'财务方案)</span></h6>
            </div>
          </el-col>
        </el-row>
        <el-row class="info-basic-row" type="flex" justify="space-between" align="middle" style="background-color: #f5f5f5;height: 32px">
          <el-col :span="2">
            <h6 style="margin-bottom: 0px">进度</h6>
          </el-col>
          <el-col :span="4">
            <el-button class="material-btn" @click="financeReceiptVisible=!financeReceiptVisible">财务详情</el-button>
          </el-col>
        </el-row>
        <el-row style="margin-top: 10px">
          <el-timeline>
            <el-timeline-item placement="bottom" v-for="(payPlanItem, index) in payPlanItems" :key="index"
                              :color="index==0?'#FFD60C':'#E4E7ED'" :hide-timestamp="true">
              <el-row type="flex" justify="space-between" align="middle">
                <el-col :span="2">
                  <h6 class="info-log-content">{{payPlanItem.moneyType | enumTranslate('PayMoneyType')}}</h6>
                </el-col>
                <el-col :span="10">
                  <h6 class="finance-log-content" v-if="payPlanItem.isLastItem === true">
                    {{payPlanItem.triggerEvent | enumTranslate('TriggerEvent')}}后
                    <span v-if="payPlanItem.moneyType === 'MONTHLY_SETTLEMENT'">
                  次月{{payPlanItem.triggerDays == null || payPlanItem.triggerDays <0 ? '月底' : payPlanItem.triggerDays + '号'}}支付剩余全部款项
                </span>
                    <span v-else>
                  {{payPlanItem.triggerDays}}天 {{payPlanItem.triggerType | enumTranslate('TriggerType')}}支付剩余全部款项
                </span>
                  </h6>
                  <h6 class="finance-log-content" v-else>
                    {{payPlanItem.triggerEvent | enumTranslate('TriggerEvent')}}后{{payPlanItem.triggerDays}}天
                    以内完成付款
                    {{payPlanItem.payPercent * 100}}%作为{{payPlanItem.moneyType | enumTranslate('PayMoneyType')}}</h6>
                </el-col>
                <el-col :span="2">
                  <img v-if="payPlanItem.payStatus === 'ARREARS'" width="40px" height="15px" src="static/img/arrears.png" />
                  <img v-if="payPlanItem.payStatus === 'PAID'" width="40px" height="15px" src="static/img/paid.png" />
                </el-col>
                <el-col :span="4">
                  <h6 class="info-log-content" style="color: red" v-if="payPlanItem.remainingUnpaidAmount != 0">
                    剩余未付￥{{payPlanItem.remainingUnpaidAmount.toFixed(2)}}</h6>
                </el-col>
                <el-col :span="8">
                  <el-row type="flex" justify="end" align="middle" v-if="payPlanItem.isCurrentItem === true && !isTenant()">
                    <authorized :authority="permission.purchaseOrderPayplanOp">
                      <el-button class="receipts-btn" @click="onPayment(payPlanItem)">付款
                      </el-button>
                    </authorized>
                  </el-row>
                </el-col>
              </el-row>
            </el-timeline-item>
          </el-timeline>
        </el-row>
      </el-col>
      <el-divider direction="vertical"></el-divider>
    </el-row>
    <el-dialog :visible.sync="financePaymentFormVisible" width="60%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <purchase-order-finance-payment-form :payPlanItem="itemData" :slotData="slotData" :form="formData"
                                           @close="onClose" @refreshItem="refreshItem" :paymentOrders="paymentOrders" @refreshData="refreshData"
                                           @clearFormData="clearFormData" />
    </el-dialog>
    <el-dialog :visible.sync="financePaymentVisible" width="60%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <purchase-order-info-payment :paymentOrders="paymentOrders" @refreshItem="refreshItem"
                                   @refreshData="refreshData" />
    </el-dialog>
  </div>
</template>

<script>
  import PurchaseOrderFinancePaymentForm from '../../../purchase/info/PurchaseOrderFinancePaymentForm';
  import PurchaseOrderInfoPayment from '../../../purchase/info/PurchaseOrderInfoPayment';
  export default {
    name: 'OutboundOrderReceiptInfo',
    components: {PurchaseOrderInfoPayment, PurchaseOrderFinancePaymentForm},
    props: ['slotData'],
    computed: {
      payPlanItems: function () {
        var result = [];
        if (this.slotData.payPlan.payPlanItems != null) {
          result = this.slotData.payPlan.payPlanItems;
        }
        if (result != null && result.length > 0) {
          result[result.length - 1].isLastItem = true;
        }
        return result;
      },
      paymentOrders: function () {
        var result = [];
        for (var payPlanItem of this.slotData.payPlan.payPlanItems) {
          for (var receipt of payPlanItem.paymentOrders) {
            result.push(receipt);
          }
        }

        if (result.length > 0) {
          result[result.length - 1].deletable = true;
        }
        return result;
      }
    },
    methods: {
      async refreshData() {
        const url = this.apis().getPurchaseOrder(this.slotData.code);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$set(this.slotData, 'payPlan', result.payPlan);
      },
      async refreshItem() {
        const url = this.apis().getPurchaseOrder(this.slotData.code);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.$set(this.slotData, 'payPlan', result.payPlan);

        if (result.payPlan.isCompleted === true) {
          this.financePaymentFormVisible = false;
          return;
        }

        for (var payPlanItem of result.payPlan.payPlanItems) {
          if (payPlanItem.isCurrentItem === true) {
            this.$set(this.itemData, 'remainingUnpaidAmount', payPlanItem.remainingUnpaidAmount);
            this.$set(this.itemData, 'lastItemAmount', payPlanItem.lastItemAmount);
            this.$set(this.itemData, 'payStatus', payPlanItem.payStatus);
            this.$set(this.itemData, 'moneyType', payPlanItem.moneyType);
            this.$set(this.itemData, 'payPercent', payPlanItem.payPercent);
            this.$set(this.itemData, 'id', payPlanItem.id);
            return;
          }
        }
      },
      onClose() {
        this.financePaymentFormVisible = false;
        this.refreshData();
      },
      clearFormData() {
        this.formData.paymentType = '';
        this.formData.amount = '';
        this.formData.payCertificate = '';
        this.formData.remarks = '';
      },
      onPayment(payPlanItem) {
        this.financePaymentFormVisible = !this.financePaymentFormVisible;
        this.itemData = payPlanItem;
      }
    },
    data () {
      return {
        financePaymentFormVisible: false,
        financePaymentVisible: false,
        itemData: {},
        formData: {
          paymentType: '',
          amount: '',
          payCertificate: '',
          remarks: ''
        }
      }
    },
    created () {},
    watch: {
      // 关闭弹窗时清空表单数据
      financePaymentFormVisible: {
        handler (val, oldVal) {
          if (val === false) {
            this.formData.paymentType = '';
            this.formData.amount = '';
            this.formData.payCertificate = '';
            this.formData.remarks = '';
          }
        },
        deep: true
      }
    }
  }
</script>

<style scoped>
  .outbound-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .material-btn {
    background-color: #ffd60c;
    border-color: #ffd60c;
    color: #000;
    width: 80px;
    height: 25px;
    line-height: 0px;
  }

  .receipts-btn {
    background-color: #ffd60c;
    border-color: #ffd60c;
    color: #000;
    width: 60px;
    height: 20px;
    line-height: 0px;
  }

  .info-basic-row {
    padding-left: 20px;
  }

  .el-divider--vertical{
    height: auto;
  }

  .info-finance-logistics_info-btn3 {
    /* width: 60px; */
    height: 20px;
    background: #FFD60C;
    font-weight: 400;
    color: rgba(0, 0, 0, 0.85);
    font-size: 10px;
    border-radius: 0px;
    text-align: center;
    border: 0px solid #FFD60C;
    padding-bottom: 15px;
  }

  .info-log-content {
    font-size: 10px;
    margin-top: 10px;
  }

  .finance-log-content {
    font-weight: 500;
    color: rgba(0, 0, 0, 0.45);
    font-size: 10px;
    margin-top: 10px;
  }
</style>
