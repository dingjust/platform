<template>
  <div class="info-finance-body">
    <el-row type="flex" justify="space-between" align="middle" class="info-finance-body-title-row">
      <div class="info-title">
        <h6 class="info-title_text">账务（当前选用“森马”账务方案）</h6>
      </div>
    </el-row>
    <el-row type="flex" justify="space-between" align="middle" class="info-finance-body-title-row2">
      <h6 class="info-title_text2">进度</h6>
      <el-button class="info-finance-logistics_info-btn1" @click="financePaymentVisible=!financePaymentVisible">
        查看付款单</el-button>
    </el-row>
    <el-row style="margin-top:10px;">
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
                  次月{{payPlanItem.triggerDays}}号支付剩余全部款项
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
                剩余未付￥{{(payPlanItem.remainingUnpaidAmount,2)|floatFormat}}</h6>
            </el-col>
            <el-col :span="8">
              <el-row type="flex" justify="end" align="middle" v-if="payPlanItem.isCurrentItem === true">
                <el-button class="info-finance-logistics_info-btn3" @click="onPayment(payPlanItem)">付款
                </el-button>
              </el-row>
            </el-col>
          </el-row>

        </el-timeline-item>
      </el-timeline>
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
  import PurchaseOrderFinancePaymentForm from './PurchaseOrderFinancePaymentForm';
  import PurchaseOrderInfoPayment from './PurchaseOrderInfoPayment';

  export default {
    name: 'PurchaseOrderInfoPaymentFinance',
    props: ['slotData'],
    components: {
      PurchaseOrderInfoPayment,
      PurchaseOrderFinancePaymentForm
    },
    mixins: [],
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
    data() {
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
    created() {},
    watch: {
      // 关闭弹窗时清空表单数据
      financePaymentFormVisible: {
        handler(val, oldVal) {
          if (val === false) {
            this.formData.paymentType = '',
              this.formData.amount = '',
              this.formData.payCertificate = '',
              this.formData.remarks = ''
          }
        },
        deep: true
      }
    }
  }

</script>
<style>
  .info-finance-body {
    width: 100%;
    margin-top: 20px;
  }

  .finance-log-content {
    font-weight: 500;
    color: rgba(0, 0, 0, 0.45);
    font-size: 10px;
    margin-top: 10px;
  }

  .info-finance-btn {
    width: 50px;
    height: 25px;
    text-align: center;
    white-space: nowrap;
    cursor: pointer;
    background: #FFF;
    border: 1px solid #DCDFE6;
    color: #606266;
    -webkit-appearance: none;
    box-sizing: border-box;
    outline: 0;
    margin: 0;
    -webkit-transition: .1s;
    transition: .1s;
    font-weight: 500;
    border-radius: 4px;
    font-size: 10px;
  }

  .info-title_text2 {
    margin-top: 5px;
    margin-left: 10px;
    font-size: 10px;
    font-weight: 400;
    color: rgba(0, 0, 0, 0.85);
  }

  .info-finance-body-title-row2 {
    background-color: rgba(0, 0, 0, 0.02);
    text-align: center;
  }

  .info-finance-btn:focus,
  .info-finance-btn:hover {
    color: #409EFF;
    border-color: #c6e2ff;
    background-color: #ecf5ff;
  }

  .info-finance-logistics_info-btn1 {
    /* width: 50px; */
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

</style>
