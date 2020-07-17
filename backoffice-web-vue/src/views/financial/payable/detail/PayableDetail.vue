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
      <financial-order-info :payPlan="payPlan" :formData="formData"/>
      <financial-invoice-info :formData="formData" @callback="callback" />
      <financial-reconciliation-table />
      <financial-record-list :belongTo="'PAYABLE_PAGE'" :formData="formData" 
                              @onConfirmReceipt="onConfirmReceipt"/>
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
      payPlan: function () {
        return this.payPlanData;
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
        this.payPlan.name = payPlan.name;
        this.payPlan.isHaveDeposit = payPlan.isHaveDeposit;
        this.payPlan.payPlanType = payPlan.payPlanType;
        payPlan.payPlanItems.forEach((item) => {
          switch (item.moneyType) {
            case 'PHASEONE':
              this.payPlan.balance1.percent = item.payPercent * 100;
              this.payPlan.balance1.event = item.triggerEvent;
              this.payPlan.balance1.time = item.triggerDays;
              this.payPlan.balance1.range = item.triggerType;
              break;
            case 'PHASETWO':
              this.payPlan.balance2.percent = item.payPercent * 100;
              this.payPlan.balance2.event = item.triggerEvent;
              this.payPlan.balance2.time = item.triggerDays;
              this.payPlan.balance2.range = item.triggerType;
              break;
            case 'DEPOSIT':
              this.payPlan.deposit.percent = item.payPercent * 100;
              this.payPlan.deposit.event = item.triggerEvent;
              this.payPlan.deposit.time = item.triggerDays;
              this.payPlan.deposit.range = item.triggerType;
              break;
            case 'MONTHLY_SETTLEMENT':
              this.payPlan.monthBalance.event = item.triggerEvent;
              this.payPlan.monthBalance.time = item.triggerDays;
              break;
          }
        });
      }
    },
    data () {
      return {
        formData: {
          productionOrder: {
            productionLeader: {},
            originCooperator: {},
            targetCooperator: {},
            merchandiser: {}
          },
          productionTaskList: []
        },
        payPlanData: {
          deposit: {},
          balance1: {},
          balance2: {},
          monthBalance: {}
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