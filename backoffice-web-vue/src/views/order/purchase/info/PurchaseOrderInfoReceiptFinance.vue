<template>
  <div class="info-finance-body">
    <el-row type="flex" justify="space-between" align="middle" class="info-finance-body-title-row">
      <div class="info-title">
        <h6 class="info-title_text">账务（当前选用“森马”账务方案）</h6>
      </div>
    </el-row>
    <el-row type="flex" justify="space-between" align="middle" class="info-finance-body-title-row2">
      <h6 class="info-title_text2">进度</h6>
      <el-button class="info-finance-logistics_info-btn1" @click="financeReceiptVisible=!financeReceiptVisible">
        查看收款单</el-button>
    </el-row>
    <el-row style="margin-top:10px;">
      <el-timeline>
        <el-timeline-item placement="bottom" v-for="(payPlanItem, index) in slotData.payPlan.payPlanItems" :key="index"
                          :color="index==0?'#FFD60C':'#E4E7ED'"  hide-timestamp="true">
          <el-row type="flex" justify="space-between" align="middle">
            <el-col :span="2">
              <h6 class="info-log-content">{{payPlanItem.moneyType | enumTranslate('PayMoneyType')}}</h6>
            </el-col>
            <el-col :span="10">
              <h6 class="finance-log-content">签署后{{payPlanItem.triggerDays}}天
                {{payPlanItem.triggerType | enumTranslate('TriggerType')}}完成付款
                {{payPlanItem.payPercent * 100}}%作为{{payPlanItem.moneyType | enumTranslate('PayMoneyType')}}</h6>
            </el-col>
            <el-col :span="2">
              <img v-if="payPlanItem.receiptStatus === 'ARREARS'" width="40px" height="15px" src="static/img/arrears.png" />
              <img v-if="payPlanItem.receiptStatus === 'PAID'" width="40px" height="15px" src="static/img/paid.png" />
            </el-col>
            <el-col :span="4">
              <h6 class="info-log-content" style="color: red" v-if="payPlanItem.remainingUnReceiptAmount != 0">剩余未收￥{{payPlanItem.remainingUnReceiptAmount,2 | floatFormat}}</h6>
            </el-col>
            <el-col :span="8">
              <el-row type="flex" justify="end" align="middle">
                <el-button class="info-finance-logistics_info-btn3" @click="onReceipt(payPlanItem)">收款
                </el-button>
                <el-button type="text" style="font-size:10px;">发送催款通知</el-button>
              </el-row>
            </el-col>
          </el-row>
        </el-timeline-item>
      </el-timeline>
    </el-row>

    <el-dialog :visible.sync="financeReceiptFormVisible" width="60%" class="purchase-dialog" append-to-body>
      <purchase-order-finance-receipt-form :payPlanItem="itemData" :slotData="slotData" :form="formData"
                                           @close="onClose" @refreshItem="refreshItem" :receiptOrders="receiptOrders()"
                                            @refreshData="refreshData"/>
    </el-dialog>

    <el-dialog :visible.sync="financeReceiptVisible" width="60%" class="purchase-dialog" append-to-body>
      <purchase-order-info-receipt :receiptOrders="receiptOrders()" @refreshItem="refreshItem"
                                   @refreshData="refreshData"/>
    </el-dialog>
  </div>
</template>

<script>
  import PurchaseOrderFinanceReceiptForm from './PurchaseOrderFinanceReceiptForm';
  import PurchaseOrderInfoReceipt from './PurchaseOrderInfoReceipt';

  export default {
    name: 'PurchaseOrderInfoReceiptFinance',
    props: ['slotData'],
    components: {
      PurchaseOrderInfoReceipt,
      PurchaseOrderFinanceReceiptForm
    },
    mixins: [],
    computed: {
      // receiptOrders: function () {
      //   let result = [];
      //   for (var payPlanItem of this.slotData.payPlan.payPlanItems) {
      //     for (var receipt of payPlanItem.receiptOrders) {
      //       result.push(receipt);
      //     }
      //   }
      //
      //   if (result.length > 0) {
      //     result[result.length - 1].deletable = true;
      //   }
      //
      //   return result;
      // }
    },
    methods: {
      receiptOrders () {
        let result = [];
        for (var payPlanItem of this.slotData.payPlan.payPlanItems) {
          for (var receipt of payPlanItem.receiptOrders) {
            result.push(receipt);
          }
        }

        if (result.length > 0) {
          result[result.length - 1].deletable = true;
        }

        return result;
      },
      async refreshData () {
        const url = this.apis().getPurchaseOrder(this.slotData.code);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$set(this.slotData, 'payPlan', result.payPlan);
      },
      async refreshItem () {
        const url = this.apis().getPurchaseOrder(this.slotData.code);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$set(this.slotData, 'payPlan', result.payPlan);
        this.receiptOrders();
        for (var payPlanItem of result.payPlan.payPlanItems) {
          if (payPlanItem.id === this.itemData.id) {
            this.$set(this.itemData, 'remainingUnReceiptAmount', payPlanItem.remainingUnReceiptAmount);
            this.$set(this.itemData, 'receiptStatus', payPlanItem.receiptStatus);
          }
        }
      },
      onClose () {
        this.financeReceiptFormVisible = false;
        this.refreshData();
      },
      onReceipt (payPlanItem) {
        this.financeReceiptFormVisible = !this.financeReceiptFormVisible;
        this.itemData = payPlanItem;
      }
    },
    data () {
      return {
        financeReceiptFormVisible: false,
        financeReceiptVisible: false,
        itemData: {},
        formData: {
          paymentType: '',
          amount: '',
          payCertificate: '',
          remarks: ''
        }
      }
    },
    created () {
    },
    watch: {
      // 关闭弹窗时清空表单数据
      financeReceiptFormVisible: {
        handler (val, oldVal) {
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
