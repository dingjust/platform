<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="6">
          <div class="financial-list-title">
            <h6>应付账款详情</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <financial-order-info belongTo="PAYABLE_PAGE" :payPlan="payPlanData" :formData="formData"/>
      <financial-invoice-info belongTo="PAYABLE_PAGE" :formData="formData" @callback="callback" />
      <financial-reconciliation-table belongTo="PAYABLE_PAGE" :formData="formData"/>
      <financial-record-list belongTo="PAYABLE_PAGE" :content="formData.requestList" />
    </el-card>
  </div>
</template>

<script>
  import {
    FinancialOrderInfo, 
    FinancialReconciliationTable,
    FinancialRecordList,
    FinancialInvoiceInfo
  } from '../../index.js'

  export default {
    name: 'PayableDetail',
    props: ['id'],
    components: {
      FinancialOrderInfo,
      FinancialReconciliationTable,
      FinancialRecordList,
      FinancialInvoiceInfo
    },
    computed: {
      payPlanData: function () {
        return this.setPayPlan(this.formData.productionOrder.payPlan);
      }
    },
    methods: {
      async getDetail () {
        const url = this.apis().getPaymentDetail(this.id);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        this.formData = result.data;
      },
      callback () {
        this.getDetail();
      },
      onConfirmReceipt (row) {
        this.$message('确认收款');
      },
      setPayPlan (payPlan) {
        let data = {
          name: payPlan.name,
          isHaveDeposit: payPlan.isHaveDeposit,
          payPlanType: payPlan.payPlanType,
          balance1: {},
          balance2: {},
          deposit: {},
          monthBalance: {}
        };
        payPlan.payPlanItems.forEach((item) => {
          switch (item.moneyType) {
            case 'PHASEONE':
              data.balance1.percent = item.payPercent * 100;
              data.balance1.event = item.triggerEvent;
              data.balance1.time = item.triggerDays;
              data.balance1.range = item.triggerType;
              break;
            case 'PHASETWO':
              data.balance2.percent = item.payPercent * 100;
              data.balance2.event = item.triggerEvent;
              data.balance2.time = item.triggerDays;
              data.balance2.range = item.triggerType;
              break;
            case 'DEPOSIT':
              data.deposit.percent = item.payPercent * 100;
              data.deposit.event = item.triggerEvent;
              data.deposit.time = item.triggerDays;
              data.deposit.range = item.triggerType;
              break;
            case 'MONTHLY_SETTLEMENT':
              data.monthBalance.event = item.triggerEvent;
              data.monthBalance.time = item.triggerDays;
              break;
          }
        });
        return data;
      }
    },
    data () {
      return {
        formData: {
          productionOrder: {
            productionLeader: {},
            originCooperator: {},
            targetCooperator: {},
            merchandiser: {},
            payPlan: {
              payPlanItems: []
            }
          },
          productionTaskList: []
        }
      }
    },
    created () {
      this.getDetail();
    },
    destroyed () {
      
    }
  }
</script>

<style scoped>
  .financial-list-title {
    border-left: 2px solid #ffd500;
    padding-left: 10px;
  }
</style>