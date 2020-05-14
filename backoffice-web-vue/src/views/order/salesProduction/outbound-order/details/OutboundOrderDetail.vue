<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="6">
          <div class="outbound-list-title">
            <h6>外发订单详情</h6>
          </div>
        </el-col>
      </el-row>
<!--      <div class="pt-2"></div>-->
      <outbound-order-top-info :slotData="form"/>
      <outbound-order-center-table :page="form"/>
      <el-row v-if="isFactory()">
        <outbound-order-receipt-info :slotData="form"/>
      </el-row>
      <el-row v-if="isBrand()">
        <outbound-order-payment-info :slot-data="form"/>
      </el-row>
      <el-row class="basic-form-row" type="flex" align="middle">
        <h6>备注及附件</h6>
      </el-row>
      <el-row type="flex" style="padding-left: 20px">
        <el-col>
          <el-input type="textarea" autosize v-model="form.textarea" :autosize="{ minRows: 4, maxRows: 6 }"/>
        </el-col>
      </el-row>
    </el-card>
  </div>
</template>

<script>
  import OutboundOrderTopInfo from '../form/OutboundOrderTopInfo';
  import OutboundOrderCenterTable from '../form/OutboundOrderCenterTable';
  import OutboundOrderReceiptInfo from '../form/OutboundOrderReceiptInfo';
  import OutboundOrderPaymentInfo from '../form/OutboundOrderPaymentInfo';
  export default {
    name: 'OutboundOrderDetail',
    components: {
      OutboundOrderPaymentInfo,
      OutboundOrderReceiptInfo,
      OutboundOrderCenterTable,
      OutboundOrderTopInfo
    },
    props: ['code'],
    data () {
      return {
        form: {
          remarks: '',
          code: 'CO0000000001',
          machiningType: 'LABOR_AND_MATERIAL',
          curNeedVoice: true,
          productionTotal: 100000000,
          priceTotal: 10000000.00,
          address: '甲方指定的仓库',
          cooperateFactory: '上海二加二零售批发商',
          contactPerson: '而加尔',
          contactPhone: '13746821943',
          factoryQC: '三家三',
          factoryQCPhone: '13894653728',
          brandQC: '四五六',
          brandQCPhone: '19832765429',
          contract: {
            name: '1233123'
          },
          number: 0,
          size: 10,
          totalPages: 100,
          totalElements: 1000,
          content: [{
            name: '产品名称',
            code: 'CO00000001',
            category: {
              name: '棉衣'
            },
            quantity: 120000000,
            price: 20.00,
            totalPrice: 12000000.00,
            deliveryTime: 1589362828,
            production: 'CO00000002',
            purchase: 'CO00000003',
            progress: '准备面料'
          }],
          payPlan: {
            payPlanType: 'PHASETWO',
            isHaveDeposit: true,
            paidAmount: 0,
            receiptAmount: 0,
            payPlanItems: [{
              payPercent: 0.3,
              triggerEvent: 'ORDER_CONFIRMED',
              triggerDays: 5,
              moneyType: 'DEPOSIT',
              triggerType: 'INSIDE',
              paymentOrders: [],
              receiptOrders: [],
              receiptStatus: 'UNPAID',
              remainingUnReceiptAmount: 147.6,
              remainingUnpaidAmount: 147.6,
              isCurrentItem: true
            }, {
              payPercent: 0.3,
              triggerEvent: 'ORDER_CONFIRMED',
              triggerDays: 5,
              moneyType: 'PHASEONE',
              triggerType: 'INSIDE',
              receiptOrders: [],
              paymentOrders: [],
              receiptStatus: 'UNPAID',
              remainingUnReceiptAmount: 147.6,
              remainingUnpaidAmount: 147.6
            }, {
              payPercent: 0.39999999999999997,
              triggerEvent: 'ORDER_CONFIRMED',
              triggerDays: 5,
              moneyType: 'PHASETWO',
              triggerType: 'INSIDE',
              receiptOrders: [],
              paymentOrders: [],
              receiptStatus: 'UNPAID',
              remainingUnReceiptAmount: 196.79999999999998,
              remainingUnpaidAmount: 196.79999999999998
            }]
          }
        }
      }
    }
  }
</script>

<style scoped>
  .outbound-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .basic-form-row {
    padding-left: 10px;
  }
</style>
