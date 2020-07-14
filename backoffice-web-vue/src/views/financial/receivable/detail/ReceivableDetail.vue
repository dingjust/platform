<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="6">
          <div class="financial-list-title">
            <h6>应收账款详情</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <financial-order-info :payPlan="payPlan"/>
      <financial-reconciliation-table :formData="form"/>
      <financial-record-list :belongTo="'RECEIVABLE_PAGE'" :formData="form" 
                              @onConfirmReceipt="onConfirmReceipt"/>
    </el-card>
  </div>
</template>

<script>
  import {
    FinancialOrderInfo, 
    FinancialReconciliationTable,
    FinancialRecordList
  } from '../../index.js'
  export default {
    name: 'ReceivableDetail',
    props: ['id'],
    components: {
      FinancialOrderInfo,
      FinancialReconciliationTable,
      FinancialRecordList
    },
    computed: {
    },
    methods: {
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
      },
      onConfirmReceipt (row) {
        this.$message('确认收款');
      }
    },
    data () {
      return {
        form: {
          payPlan: {
          "id": 8802909289737,
          "name": "",
          "payPlanType": "PHASEONE",
          "isHaveDeposit": false,
          "payPlanItems": [{
              "id": 8802679913748,
              "creationtime": 1594262932000,
              "modifiedtime": 1594262932000,
              "payPercent": 1,
              "triggerEvent": "ORDER_CONFIRMED",
              "triggerDays": 5,
              "moneyType": "PHASEONE",
              "triggerType": "INSIDE"
            }
          ]},
          productionOrder: [{
            id: 1,
            code: 'KY00001-01',
            reconciliationOrder: [{
              id: 101,
              code: 'KY00001-01-01',
              amount: 12000,
              deposit: 6000,
              paymentReceived: 9000
            }, {
              id: 102,
              code: 'KY00001-01-02',
              amount: 12000,
              deposit: 6000,
              paymentReceived: 9000
            }]
          }, {
            id: 2,
            code: 'KY00001-01',
            reconciliationOrder: [{
              id: 201,
              code: 'KY00001-02-01',
              amount: 12000,
              deposit: 6000,
              paymentReceived: 9000
            }, {
              id: 202,
              code: 'KY00001-02-02',
              amount: 12000,
              deposit: 6000,
              paymentReceived: 9000
            }]
          }]
        },
        payPlan: {
          deposit: {},
          balance1: {},
          balance2: {},
          monthBalance: {}
        }
      }
    },
    created () {
      this.$message(this.id);
      this.setPayPlan(this.form.payPlan);
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