<!--
* @Description: 平台端查看所有外接外发订单的详情页面
* @Date 2021/07/02 15:34
* @Author L.G.Y
-->
<template>
  <div class="animated fadeIn content pend-out-detail">
    <el-card>
      <template v-if="detail">
        <div class="pend-out-header">
          <div class="orders-list-title">
            <h6>订单详情</h6>
          </div>
          <h6>订单号：{{detail.code}}</h6>
          <h6>创建时间：{{detail.creationtime | timestampToTime}}</h6>
          <h6>状态：{{getEnum('SalesProductionOrderState', detail.state)}}</h6>
        </div>
        <div class="pt-2"></div>
        <el-row style="padding: 8px 0px;">
          <el-col :xs="24" :sm="18" class="info-cell">
            <el-row v-if="detail.title" style="margin-bottom: 12px;">
              <h6>标题：{{detail.title}}</h6>
            </el-row>
            <el-row type="flex" justify="space-between" align="center" style="margin-bottom: 12px;">
              <el-col>
                <h6>甲方公司：{{detail.originCooperator ? detail.originCooperator.name : '' }}</h6>
              </el-col>
              <el-col>
                <h6>乙方公司：{{detail.belongTo ? detail.belongTo.name : '' }}</h6>
              </el-col>
            </el-row>
            <el-row type="flex" justify="space-between" align="center" style="margin-bottom: 12px;">
              <el-col>
                <h6>生产总数：{{detail.totalQuantity}}</h6>
              </el-col>
              <el-col>
                <h6>生产总价：{{totalAmount.toFixed(2)}}元</h6>
              </el-col>
              <el-col v-if="detail.serviceFeePercent">
                <h6>服务费比例：{{(detail.serviceFeePercent * 100).toFixed(2)}}</h6>
              </el-col>
            </el-row>
            <el-row type="flex" justify="space-between" align="center" style="margin-bottom: 12px;">
              <el-col>
                <h6>合作方式：{{getEnum('machiningTypes', detail.cooperationMode)}}</h6>
              </el-col>
              <el-col>
                <h6>是否开票：{{detail.invoiceNeeded ? '是' : '否'}}<span style="margin-left:5px"
                    v-if="detail.invoiceNeeded">{{detail.invoiceTaxPoint * 100}}%</span></h6>
              </el-col>
              <el-col>
                <h6 style="display: inline-block;" v-popover:popover>
                  有无定金：{{detail.payPlan.isHaveDeposit ? '有定金' : '无定金'}} + {{payPlanType[detail.payPlan.payPlanType]}}
                </h6>
              </el-col>
            </el-row>
            <el-row type="flex" justify="space-between" align="center" style="margin-bottom: 12px;">
              <h6 class="preview-text">{{resultPreview}}</h6>
            </el-row>
            <el-row type="flex" justify="space-between" align="center" style="margin-bottom: 12px;">
              <el-col>
                <h6>创建人：{{detail.creator ? detail.creator.name : detail.sendBy.name}}</h6>
              </el-col>
              <el-col>
                <h6>创建人uid：{{detail.creator ? detail.creator.uid : detail.sendBy.uid}}</h6>
              </el-col>
            </el-row>
          </el-col>
          <el-col :xs="24" :sm="6">
            <div class="info-box" style="padding: 5px 0px 0px 5px;">
              <production-contract :slotData="detail" :contracts="contracts" :canSign="false" :readOnly="true"/>
            </div>
          </el-col>
        </el-row>
        <sales-production-tabs :canChangeProduct="false" :canUpdate="false" :form="detail" :fromOut="false" :readOnly="true" :fromDetail="true"/>
      </template>
    </el-card>
  </div>
</template>

<script>
import ProductionContract from '@/views/order/salesProduction/components/ProductionContract'
import SalesProductionTabs from '@/views/order/salesProduction/components/SalesProductionTabs'

export default {
  name: 'PendOutDetail',
  components: {
    ProductionContract,
    SalesProductionTabs,
  },
  props: ['id'],
  computed: {
    totalAmount: function () {
      if (this.detail.totalPrimeCost !== 0) {
        return this.detail.totalPrimeCost;
      }
      let totalAmount = 0;
      this.detail.taskOrderEntries.forEach(item => {
        totalAmount += (item.unitPrice * item.quantity);
      })
      return totalAmount;
    },
    // 已签合同列表
    contracts: function () {
      if (this.detail.agreements) {
        return this.detail.agreements.filter(item => item.state !== 'INVALID');
      }
      return [];
    },
    resultPreview: function () {
      var result = '';

      if (this.detail.payPlan.payPlanItems.length <= 0) {
        return result;
      }

      this.detail.payPlan.payPlanItems.forEach((payPlanItem) => {
        if (!(payPlanItem.moneyType == 'MONTHLY_SETTLEMENT_TWO' && payPlanItem.isRange == true)) {
          result += this.getEnum('PayMoneyType', payPlanItem.moneyType);
        }

        switch (payPlanItem.moneyType) {
          case 'DEPOSIT':
            result += '：在双方' + this.getEnum('TriggerEvent', payPlanItem.triggerEvent) + '后' + payPlanItem
              .triggerDays +
              '天以内，甲方应向乙方支付订单总金额的' + (payPlanItem.payPercent * 100).toFixed(0) + '%为定金\n';
            break;
          case 'PHASEONE':
          case 'PHASETWO':
          case 'PHASETHREE':
            result += '：在双方' + this.getEnum('TriggerEvent', payPlanItem.triggerEvent) + '后' + payPlanItem
              .triggerDays + '天以内，';
            if (payPlanItem.isLast) {
              result += '甲方应向乙方支付合同剩余部分款项（以上所有款项金额以双方对账金额为准）';
            } else {
              result += '甲方应向乙方支付合同总额的' + (payPlanItem.payPercent * 100).toFixed(0) + '%货款\n';
            }
            break;
          case 'MONTHLY_SETTLEMENT_ONE':
          case 'MONTHLY_SETTLEMENT_TWO':
            if (payPlanItem.isRange) {
              result += '，' + (payPlanItem.monthlyStartDayNum ?
                  (payPlanItem.monthlyStartDayNum == -1 ? '月底' : payPlanItem.monthlyStartDayNum + '号') : '*') +
                '后至' + (payPlanItem.monthlyEndDayNum ?
                  (payPlanItem.monthlyEndDayNum == -1 ? '月底' : payPlanItem.monthlyEndDayNum + '号') : '*') +
                '前完成' + (payPlanItem.triggerEvent ? this.getEnum('TriggerEvent', payPlanItem.triggerEvent) :
                  '****') +
                '后于' + (payPlanItem.monthType ? this.getEnum('MonthType', payPlanItem.monthType) : '**') +
                (payPlanItem.payDayNum ? (payPlanItem.payDayNum == -1 ? '月底' : payPlanItem.payDayNum + '号') :
                  ' *') + '支付相应款项';
              result += '（以上所有款项金额以双方对账金额为准）';
            } else {
              result += '：每月' + (payPlanItem.monthlyEndDayNum ?
                  (payPlanItem.monthlyEndDayNum == -1 ? '月底' : payPlanItem.monthlyEndDayNum + '号') : '*') +
                '前完成' + (payPlanItem.triggerEvent ? this.getEnum('TriggerEvent', payPlanItem.triggerEvent) :
                  '****') +
                '后于' + (payPlanItem.monthType ? this.getEnum('MonthType', payPlanItem.monthType) : '**') +
                (payPlanItem.payDayNum ? (payPlanItem.payDayNum == -1 ? '月底' : payPlanItem.payDayNum + '号') :
                  ' *') + '支付相应款项';
              if (payPlanItem.moneyType === 'MONTHLY_SETTLEMENT_ONE') {
                result += '（以上所有款项金额以双方对账金额为准）';
              }
            }
            break;
        }
      });

      return result;
    }
  },
  methods: {
    async getDetails() {
      const url = this.apis().getSalesProductionOrderDetails(this.id);
      const result = await this.$http.get(url);

      if (result.code === 1) {
        this.$set(this, 'detail', result.data)
      }
    },
    getHtmlText(text) {
      if (text === undefined) {
        return '';
      }
      return text.replace(/\n/g, '</br></br>');
    }
  },
  data () {
    return {
      detail: null,
      payPlanType: {
        'PHASEONE': '一期尾款',
        'PHASETWO': '二期尾款',
        'PHASETHREE': '三期尾款',
        'MONTHLY_SETTLEMENT': '月结',
        'MONTHLY_SETTLEMENT_ONE': '一月一结',
        'MONTHLY_SETTLEMENT_TWO': '一月两结',
      },
      triggerEvent: {
        'ORDER_CONFIRMED': '确认订单',
        'CONTRACT_SIGNED': '签署合同',
        'DELIVERY_CONFIRMED': '确认收货',
        'RECONCILIATION_CONFIRMED': '确认对账',
        'INVOICE_RECEIVED': '收到发票'
      },
      triggerType: {
        'INSIDE': '以内',
        'OUTSIDE': '以外'
      }
    }
  },
  created () {
    this.getDetails()
  }
}
</script>

<style scoped>
  .pend-out-header {
    display: flex;
    flex-wrap: wrap;
    justify-content: space-between;
    align-items: center;
  }

  .pend-out-detail h6 {
    margin: 0px
  }

  .info-box {
    width: 100%;
    height: 100%;
    border: 1px solid #dcdfe6;
    border-radius: 10px;
    padding-right: 10px;
  }

  .info-cell {
    padding: 0px 16px;
  }

  .preview-text {
    white-space: pre-line;
    line-height: 24px;
  }
</style>