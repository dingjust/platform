<!--suppress ALL -->
<template>
  <div class="animated fadeIn">

    <el-row class="info-order-row" type="flex" justify="start" align="middle" :gutter="35">
      <el-col :span="6">
        <el-row type="flex" align="middle">
          <h6 class="info-input-prepend">有无定金</h6>
          <el-radio class="info-radio" v-model="formData.isHaveDeposit" :label="true">有定金</el-radio>
          <el-radio class="info-radio" v-model="formData.isHaveDeposit" :label="false">无定金</el-radio>
        </el-row>
      </el-col>
      <el-col :span="8">
        <el-row type="flex" align="middle">
          <h6 class="info-input-prepend">尾款期数</h6>
          <template v-for="item in payPlanTypes">
            <el-radio class="info-radio" v-model="formData.payPlanType" :label="item.code">{{item.name}}</el-radio>
          </template>
        </el-row>
      </el-col>
    </el-row>

    <div v-for="(item,index) in payPlanItems">
      <el-row class="info-order-row" type="flex" justify="start" align="middle" :gutter="10">
        <el-col :span="7">
          <el-row type="flex" align="middle">
            <h6 class="info-input-prepend" style="width: 60px;">{{getEnum('PayMoneyType',item.moneyType)}}</h6>
            <h6 class="info-input-prepend2" style="width:30px;">事件</h6>
            <el-select v-model="item.triggerEvent" filterable @change="$forceUpdate()" placeholder="请选择">
              <el-option v-for="event in triggerEvents" :label="event.name" :value="event.code"></el-option>
            </el-select>
          </el-row>
        </el-col>
        <el-col :span="4" v-if="!item.isLast || item.isLast">
          <el-row type="flex" align="middle" justify="start">
            <el-col :span="6">
              <h6 class="info-input-prepend2" style="width:50px;">后时长</h6>
            </el-col>
            <el-col :span="18">
              <el-input-number v-model="item.triggerDays" :precision="0" :step="1" :min="1" size="mini">
              </el-input-number>
            </el-col>
          </el-row>
        </el-col>
        <h6 v-if="item.isLast && formData.payPlanType == 'MONTHLY_SETTLEMENT'" class="info-input-prepend2"
          style="width: 200px">后, 次月{{item.triggerDays}}号支付剩余全部款项</h6>
        <el-col v-if="!item.isLast || item.isLast && formData.payPlanType != 'MONTHLY_SETTLEMENT'" :span="4">
          <el-row type="flex" align="middle" justify="start">
            <el-col :span="6">
              <h6 class="info-input-prepend2">天付款</h6>
            </el-col>
          </el-row>
        </el-col>
        <h6 v-if="item.isLast && formData.payPlanType != 'MONTHLY_SETTLEMENT'" class="info-input-prepend2"
          style="width: 200px;">剩余全部款项</h6>
        <el-col v-if="!item.isLast" :span="4">
          <el-row v-if="!item.isLast" type="flex" align="middle" justify="start">
            <!-- <el-col :span="6">
              <h6 class="info-input-prepend2" style="width: 40px;">付款</h6>
            </el-col> -->
            <el-col :span="18">
              <el-select v-model="item.payPercent" @change="$forceUpdate()">
                <el-option v-for="percent in 99" :value="percent*0.01" :label="percent+'%'"></el-option>
              </el-select>
            </el-col>
          </el-row>
        </el-col>
      </el-row>
    </div>

    <el-row class="info-order-row" type="flex" justify="start" align="middle" :gutter="10">
      <el-col :span="24">
        <el-row type="flex" align="middle">
          <h6 class="info-input-prepend" style="width:60px">结果预览</h6>
          <el-input type="textarea" autosize v-model="resultPreview" />
          </el-input>
        </el-row>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';

  const {
    mapGetters
  } = createNamespacedHelpers('PayPlanModule');

  export default {
    name: 'PayPlanForm',
    props: ['formData'],
    computed: {
      ...mapGetters({}),
      payPlanItems: function () {
        let result = [];
        if (this.formData.isHaveDeposit) {
          var flag = false;
          for (var item of this.formData.payPlanItems) {
            if (item.moneyType === 'DEPOSIT') {
              result.push(item);
              flag = true;
              break;
            }
          }
          if (!flag) {
            result.push({
              payPercent: 0.3,
              triggerEvent: 'ORDER_CONFIRMED',
              triggerDays: 5,
              moneyType: 'DEPOSIT',
              triggerType: 'INSIDE',
            });
          }
        }

        switch (this.formData.payPlanType) {
          case 'PHASEONE':
            var flag = false;
            for (var item of this.formData.payPlanItems) {
              if (item.moneyType === 'PHASEONE') {
                item.isLast = true;
                result.push(item);
                flag = true;
                break;
              }
            }
            if (!flag) {
              result.push({
                payPercent: 0.3,
                triggerEvent: 'ORDER_CONFIRMED',
                triggerDays: 5,
                moneyType: 'PHASEONE',
                triggerType: 'INSIDE',
                isLast: true
              });
            }
            break;
          case 'PHASETWO':
            var flag = false;
            for (var item of this.formData.payPlanItems) {
              if (item.moneyType === 'PHASEONE') {
                item.isLast = false;
                result.push(item);
                flag = true;
                break;
              }
            }
            if (!flag) {
              result.push({
                payPercent: 0.3,
                triggerEvent: 'ORDER_CONFIRMED',
                triggerDays: 5,
                moneyType: 'PHASEONE',
                triggerType: 'INSIDE',
              });
            }
            flag = false;
            for (var item of this.formData.payPlanItems) {
              if (item.moneyType === 'PHASETWO') {
                item.isLast = true;
                result.push(item);
                flag = true;
                break;
              }
            }
            if (!flag) {
              result.push({
                payPercent: 0.3,
                triggerEvent: 'ORDER_CONFIRMED',
                triggerDays: 5,
                moneyType: 'PHASETWO',
                triggerType: 'INSIDE',
                isLast: true
              });
            }
            break;
          case 'MONTHLY_SETTLEMENT':
            var flag = false;
            for (var item of this.formData.payPlanItems) {
              if (item.moneyType === 'MONTHLY_SETTLEMENT') {
                item.isLast = true;
                result.push(item);
                flag = true;
                break;
              }
            }
            if (!flag) {
              result.push({
                payPercent: 0.3,
                triggerEvent: 'ORDER_CONFIRMED',
                triggerDays: 5,
                moneyType: 'MONTHLY_SETTLEMENT',
                triggerType: 'INSIDE',
                isLast: true
              });
            }
            break;
        }

        this.formData.payPlanItems = result;
        return result;
      },
      percents: function () {
        let result = [
          0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1
        ];

        var percent = 1;
        // for(var item of this.payPlanItems){
        //   percent -= item.payPercent;
        // }

        // for(var i = 0;i<percent;i=i+0.1){
        //   result.push(i);
        // }

        return result;
      },
      resultPreview: function () {
        var result = '';

        if (this.formData.payPlanItems.length <= 0) {
          return result;
        }

        if (this.formData.isHaveDeposit) {
          result += '定金+';
        } else {
          result += '无定金';
        }

        result += this.getEnum('PayPlanType', this.formData.payPlanType) + '\n        ';

        if (this.formData.isHaveDeposit) {
          result += '定金：在双方' + this.getEnum('TriggerEvent', this.formData.payPlanItems[0].triggerEvent) + '后，' +
            '甲方应向乙方支付生效订单总金额的' + this.formData.payPlanItems[0].payPercent * 100 + '%为定金\n        ';
          result += '支付方式：';
        }

        switch (this.formData.payPlanType) {
          case 'PHASEONE':
            let data = this.payPlanItems.filter(item => item.moneyType === 'PHASEONE')[0];
            result += '甲方收到乙方交付的全部产品并经甲方检验全部产品合格入库，在' +
              this.getEnum('TriggerEvent', data.triggerEvent) + '后' + data.triggerDays + '日' +
              this.getEnum('TriggerType', data.triggerType) + '未发现任何产品质量问题的则甲方向乙方支付剩余全部款项' +
              '（以双方确认的对账单金额为准）。' + '若发现质量问题的，则按甲乙双方对质量的相关条款处理。';
            break;
          case 'PHASETWO':
            let oneData = this.payPlanItems.filter(item => item.moneyType === 'PHASEONE')[0];
            let twoData = this.payPlanItems.filter(item => item.moneyType === 'PHASETWO')[0];
            result += '甲方收到乙方交付的全部产品并经甲方检验全部产品合格入库，在' +
              this.getEnum('TriggerEvent', oneData.triggerEvent) + '后' + oneData.triggerDays + '日' +
              this.getEnum('TriggerType', oneData.triggerType) + '支付合同总价的' + oneData.payPercent * 100 + '%。' +
              '在产品入库并经甲方检验全部产品合格' + this.getEnum('TriggerEvent', twoData.triggerEvent) + '后' + twoData.triggerDays +
              '日' +
              this.getEnum('TriggerType', twoData.triggerType) + '未发现任何产品质量问题的' + '，则甲方向乙方支付剩余全部款项' +
              '（以双方确认的对账单金额为准）。若发现质量问题的，则按甲乙双方对质量的相关条款处理。';
            break;
          case 'MONTHLY_SETTLEMENT':
            let monthData = this.payPlanItems.filter(item => item.moneyType === 'MONTHLY_SETTLEMENT')[0];
            result += ' 甲方收到乙方交付的全部产品并经甲方检验全部产品合格入库,甲方在' +
              this.getEnum('TriggerEvent', monthData.triggerEvent) + '完成的次月月底支付剩余全部款项' +
              '（以双方确认的对账单金额为准）。若发现质量问题的，则按甲乙双方对质量的相关条款处理。';
            break;
        }
        return result;
      }
    },
    methods: {},
    data() {
      return {
        payPlanTypes: this.$store.state.EnumsModule.PayPlanType,
        payMoneyTypes: this.$store.state.EnumsModule.PayMoneyType,
        triggerEvents: this.$store.state.EnumsModule.TriggerEvent,
        triggerTypes: this.$store.state.EnumsModule.TriggerType,
        triggerDays: [
          5, 7, 15
        ],
      }
    }
  }

</script>

<style scoped>
  .info-title {
    width: 100%;
    border-left: 2px solid #FFD60C;
    padding-left: 10px;
    height: 14px;
  }

  .info-title_text {
    font-size: 12px;
    font-weight: 500;
    color: rgba(0, 0, 0, 1);
    opacity: 0.65;
  }

  .info-title-row {
    margin-bottom: 20px;
  }

  .info-order-body {
    width: 100%;
    padding: 10px 60px;
  }

  .info-order-row {
    margin-bottom: 20px;
  }

  .info-input-prepend {
    display: inline-block;
    margin: 0 5px;
    width: 60px;
    font-weight: bold;
    font-size: 10px;
  }

  .info-input-prepend2 {
    display: inline-block;
    margin: 0 5px;
    width: 50px;
    font-size: 10px;
    color: rgba(0, 0, 0, 0.45);
  }

  .info-row_width50 {
    width: 50%;
  }

  .checkbox-text .el-checkbox__label {
    font-size: 10px;
    font-weight: 400;
    color: rgba(0, 0, 0, 0.45);
  }

  .order-table {
    /* width: 600px;
    height: 600px; */
    border-collapse: collapse;
    margin-bottom: 20px;

    white-space: nowrap;
    overflow: hidden;
    overflow-x: scroll;
  }

  .order-table-input .el-input__inner {
    /* width: 60px; */
    border: 0px solid #fff;
    padding: 0px;
    text-align: center;
  }

  .order-table-btn {
    padding-left: 10px;
    width: 30px;
  }

  .order-table-info {
    font-size: 10px;
    font-weight: 400;
    color: rgba(0, 0, 0, 0.65);
    margin-left: 20px;
  }

  /* .order-table-btn_add {
    background-color: #FFD60C;
    border-color: #FFD60C;
    color: #000;
  } */

  .order-purchase-table-btn_add {
    width: 100%;
    height: 50px;
    line-height: 50px;
    border: 0.5px dashed rgba(0, 0, 0, 0.15);
    text-align: center;
    align-content: center;
    color: rgba(0, 0, 0, 0.65);
  }

  .order-purchase-table-btn_add:hover {
    background: rgba(247, 247, 247, 1);
    cursor: pointer;
  }

  .info-order-submit {
    background-color: #FFD60C;
    border-color: #FFD60C;
    color: #000;
    width: 150px;
  }

  .purchase-dialog .el-dialog {
    border-radius: 10px !important;
  }

  .purchase-dialog-header {
    padding: 0px !important;
  }

  .purchase-dialog .el-dialog__header {
    padding: 0px !important;
  }

  .purchase-product-img {
    width: 120px;
    height: 120px;
    border-radius: 10px;
    margin-right: 20px;
  }


  .order-table tr td,
  .order-table tr th {
    border: 1px solid rgba(0, 0, 0, 0.15);
    text-align: center;
    height: 30px;
    font-size: 10px;
    color: rgba(0, 0, 0, 0.65);
  }

  .info-radio .el-radio__label {
    font-size: 10px;
  }

  .el-input--small .el-input__inner {
    height: 28px;
    line-height: 32px;
  }

  .el-input.is-disabled .el-input__inner {
    cursor: pointer;
    background-color: #fff;
  }

  .order-purchase-upload {
    margin-left: 50px;
  }

  .order-purchase-upload .el-upload--picture-card {
    width: 100px;
    height: 100px;
    line-height: 100px;
  }

  .order-purchase-upload .el-upload-list--picture-card .el-upload-list__item {
    width: 100px;
    height: 100px;
  }

  .purchase-form-item small.el-form-item {
    margin-bottom: 0px !important;
  }

  .purchase-form-item .el-form-item--mini.el-form-item,
  .el-form-item--small.el-form-item {
    margin-bottom: 0px !important;
  }

  .purchase-form-item .el-form-item__error {
    padding-left: 70px !important;
  }

</style>
