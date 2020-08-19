<!--suppress ALL -->
<template>
  <div class="animated fadeIn">
    <el-dialog :visible.sync="payPlanSelectDialogVisible" width="50%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <pay-plan-select @onSelect="onPayPlanSelect" v-if="payPlanSelectDialogVisible" />
    </el-dialog>
    <el-dialog title="保存账务方案" :visible.sync="dialogPayPlanFormVisible" :close-on-click-modal="false">
      <el-form :model="payPlanForm">
        <el-form-item label="方案名称">
          <el-input v-model="payPlanForm.name"></el-input>
        </el-form-item>
        <el-form-item label="备注">
          <el-input type="textarea" :rows="3" placeholder="请输入备注留言..." v-model="payPlanForm.remarks" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogPayPlanFormVisible = false">取 消</el-button>
        <el-button type="primary" @click="onPayPlanSave">确 定</el-button>
      </div>
    </el-dialog>
    <el-row type="flex" v-if="isUseForOrder" justify="end" class="info-order-row">
      <h6 class="form-plane-name">{{formData.name!=undefined?'当前选中方案：'+formData.name:'当前未选择账务方案'}}</h6>
      <el-button @click="payPlanSelectDialogVisible=true" type="primary" plain size="mini">选用账务方案</el-button>
      <Authorized :permission="['PAY_PLAN_OPERATE']">
        <el-button @click="dialogPayPlanFormVisible=true" type="success" plain size="mini">保存账务方案</el-button>
      </Authorized>
    </el-row>
    <el-form :model="formData" ref="payPlanForm">
      <el-row class="info-order-row" type="flex" justify="start" align="middle" :gutter="35">
        <el-col :span="8">
          <el-form-item label="有无定金" label-width="120">
            <el-radio :label="true" v-model="formData.isHaveDeposit">有定金</el-radio>
            <el-radio :label="false" v-model="formData.isHaveDeposit">无定金</el-radio>
          </el-form-item>
        </el-col>
        <el-col :span="16">
          <el-form-item label="尾款期数" label-width="120">
            <template v-for="item in payPlanTypes">
              <el-radio :label="item.code" :key="item.code" v-model="formData.payPlanType">{{item.name}}</el-radio>
            </template>
          </el-form-item>
        </el-col>
      </el-row>
      <div v-for="(item,index) in payPlanItems" :key="'item'+index">
        <el-row v-if="!(item.moneyType === 'MONTHLY_SETTLEMENT_ONE' || item.moneyType === 'MONTHLY_SETTLEMENT_TWO')"
          class="info-order-row" type="flex" justify="start" align="middle" :gutter="10">
          <el-col :span="7" align="middle">
            <el-row type="flex" align="middle">
              <h6 class="info-input-prepend" style="width: 60px;">{{getEnum('PayMoneyType',item.moneyType)}}</h6>
              <h6 class="info-input-prepend2" style="width:30px;">事件</h6>
              <el-select v-model="item.triggerEvent" filterable @change="$forceUpdate()" placeholder="请选择">
                <el-option v-for="event in triggerEvents" :label="event.name" :value="event.code"
                  :key="'event'+event.code"></el-option>
              </el-select>
            </el-row>
          </el-col>
          <el-col :span="4" v-if="!item.isLast || item.isLast">
            <el-row type="flex" align="middle" justify="start">
              <h6 class="info-input-prepend2" style="width:50px;">后时长</h6>
              <el-input-number v-model="item.triggerDays" :precision="0" :step="1" :min="1" size="mini">
              </el-input-number>
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
                  <el-option v-for="percent in 99" :value="percent*0.01" :label="percent+'%'" :key="'percent'+percent">
                  </el-option>
                </el-select>
              </el-col>
            </el-row>
          </el-col>
        </el-row>
        <el-row v-else type="flex" class="info-order-row" align="top">
          <el-col :span="2">
            <h6 class="info-input-prepend" style="width: 60px;padding-top:8px"
              v-if="!(item.moneyType == 'MONTHLY_SETTLEMENT_TWO' && item.isRange == true)">
              {{getEnum('PayMoneyType',item.moneyType)}}：
            </h6>
          </el-col>
          <el-col :span="22">
            <el-row v-if="item.isRange" type="flex">
              <el-form-item label="当月" label-width="55px">
                <el-select v-model="item.monthlyStartDayNum" placeholder="请选择" class="number-select" :disabled="true"
                  @change="startDayNumChange(item,index)">
                  <template v-for="val in 28">
                    <el-option :label="val+'号'" :value="val" :key="val"></el-option>
                  </template>
                  <el-option label="月底" :value="-1" :key="-1"></el-option>
                </el-select>
              </el-form-item>
              <el-form-item label="至" label-width="40px" style="margin-left:10px" prop="payPlanItems.1.monthlyEndDayNum"
                :rules="[{ required: true, message: '请选择', trigger: 'change'}]">
                <el-select v-model="item.monthlyEndDayNum" placeholder="请选择" class="number-select"
                  @change="endDayNumChange(item,index)">
                  <template v-if="item.monthlyStartDayNum">
                    <template v-for="val in 28">
                      <el-option v-if="item.monthlyStartDayNum != -1 && val > item.monthlyStartDayNum" :label="val+'号'"
                        :value="val" :key="val"></el-option>
                    </template>
                  </template>
                  <template v-else>
                    <el-option v-for="val in 28" :label="val+'号'" :value="val" :key="val"></el-option>
                  </template>
                  <el-option label="月底" :value="-1" :key="-1"></el-option>
                </el-select>
              </el-form-item>
              <el-form-item label="前完成事件" label-width="100px" style="margin-left:10px">
                <el-select v-model="item.triggerEvent" filterable placeholder="请选择" class="form-event-select"
                  :disabled="true">
                  <el-option v-for="event in triggerEventsV2" :label="event.name" :value="event.code" :key="event.code">
                  </el-option>
                </el-select>
              </el-form-item>
              <el-form-item label="后于" label-width="55px" prop="payPlanItems.1.monthType"
                :rules="[{ required: true, message: '请选择', trigger: 'change'}]">
                <el-select v-model="item.monthType" placeholder="请选择" class="number-select">
                  <template v-for="val in monthTypes">
                    <el-option :label="val.name" :value="val.code" :key="val.code"></el-option>
                  </template>
                </el-select>
              </el-form-item>
              <el-form-item label="" label-width="10px" prop="payPlanItems.1.payDayNum"
                :rules="[{ required: true, message: '请选择', trigger: 'change'}]">
                <el-select v-model="item.payDayNum" placeholder="请选择" class="number-select">
                  <template v-if="item.monthType == 'CURRENT_MONTH' && item.monthlyEndDayNum">
                    <template v-for="val in 28">
                      <el-option v-if="item.monthlyEndDayNum != -1 && val >= item.monthlyEndDayNum" :label="val+'号'"
                        :value="val" :key="val"></el-option>
                    </template>
                  </template>
                  <template v-else>
                    <el-option v-for="val in 28" :label="val+'号'" :value="val" :key="val"></el-option>
                  </template>
                  <el-option label="月底" :value="-1" :key="-1"></el-option>
                </el-select>
              </el-form-item>
              <h6 class="end-text">支付相应款项</h6>
            </el-row>
            <el-row v-else type="flex">
              <el-form-item label="每月" label-width="55px" prop="payPlanItems.0.monthlyEndDayNum"
                :rules="[{ required: true, message: '请选择', trigger: 'change'}]">
                <el-select v-model="item.monthlyEndDayNum" placeholder="请选择" class="number-select"
                  @change="endDayNumChange(item,index)">
                  <template v-for="val in 28">
                    <el-option :label="val+'号'" :value="val" :key="val"></el-option>
                  </template>
                  <el-option label="月底" :value="-1" :key="-1"></el-option>
                </el-select>
              </el-form-item>
              <el-form-item label="前完成事件" label-width="100px" style="margin-left:10px;"
                prop="payPlanItems.0.triggerEvent" :rules="[{ required: true, message: '请选择', trigger: 'change'}]">
                <el-select v-model="item.triggerEvent" filterable placeholder="请选择" class="form-event-select"
                  @change="triggerEventChange(item,index)">
                  <el-option v-for="event in triggerEventsV2" :label="event.name" :value="event.code" :key="event.code">
                  </el-option>
                </el-select>
              </el-form-item>
              <el-form-item label="后于" label-width="55px" prop="payPlanItems.0.monthType"
                :rules="[{ required: true, message: '请选择', trigger: 'change'}]">
                <el-select v-model="item.monthType" placeholder="请选择" class="number-select"
                  @change="monthTypeChange(item,index)">
                  <template v-for="val in monthTypes">
                    <el-option :label="val.name" :value="val.code" :key="val.code"></el-option>
                  </template>
                </el-select>
              </el-form-item>
              <el-form-item label="" label-width="10px" prop="payPlanItems.0.payDayNum"
                :rules="[{ required: true, message: '请选择', trigger: 'change'}]">
                <el-select v-model="item.payDayNum" placeholder="请选择" class="number-select">
                  <template v-if="item.monthType == 'CURRENT_MONTH' && item.monthlyEndDayNum">
                    <template v-for="val in 28">
                      <el-option v-if="item.monthlyEndDayNum != -1 && val >= item.monthlyEndDayNum" :label="val+'号'"
                        :value="val" :key="val"></el-option>
                    </template>
                  </template>
                  <template v-else>
                    <el-option v-for="val in 28" :label="val+'号'" :value="val" :key="val"></el-option>
                  </template>
                  <el-option label="月底" :value="-1" :key="-1"></el-option>
                </el-select>
              </el-form-item>
              <h6 class="end-text">支付相应款项</h6>
            </el-row>
          </el-col>
        </el-row>
      </div>
    </el-form>

    <el-row class="info-order-row" type="flex" justify="start" align="middle" :gutter="10">
      <el-col :span="24">
        <el-row type="flex" align="middle">
          <h6 class="info-input-prepend" style="width:60px">结果预览</h6>
          <el-input type="textarea" autosize v-model="resultPreview" />
        </el-row>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';
  import PayPlanSelect from "./PayPlanSelect";

  const {
    mapGetters
  } = createNamespacedHelpers('PayPlanModule');

  export default {
    name: 'PayPlanForm',
    components: {
      PayPlanSelect
    },
    props: {
      isUseForOrder: {
        type: Boolean,
        default: false
      },
      formData: {
        type: Object,
      }
    },
    computed: {
      ...mapGetters({}),
      payPlanItems: function () {
        let result = [];
        if (this.formData.isHaveDeposit) {
          var index0 = this.formData.payPlanItems.findIndex((data) => data.moneyType === 'DEPOSIT');
          if (index0 > -1) {
            result.push(this.formData.payPlanItems[index0]);
          } else {
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
            var index0 = this.formData.payPlanItems.findIndex((data) => data.moneyType === 'PHASEONE');
            if (index0 > -1) {
              this.formData.payPlanItems[index0].isLast = true;
              result.push(this.formData.payPlanItems[index0]);
            } else {
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
            var index0 = this.formData.payPlanItems.findIndex((data) => data.moneyType === 'PHASEONE');
            if (index0 > -1) {
              this.formData.payPlanItems[index0].isLast = false;
              result.push(this.formData.payPlanItems[index0]);
            } else {
              result.push({
                payPercent: 0.3,
                triggerEvent: 'ORDER_CONFIRMED',
                triggerDays: 5,
                moneyType: 'PHASEONE',
                triggerType: 'INSIDE',
                isLast: false
              });
            }
            index0 = this.formData.payPlanItems.findIndex((data) => data.moneyType === 'PHASETWO');
            if (index0 > -1) {
              this.formData.payPlanItems[index0].isLast = true;
              result.push(this.formData.payPlanItems[index0]);
            } else {
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
          case 'PHASETHREE':
            var index0 = this.formData.payPlanItems.findIndex((data) => data.moneyType === 'PHASEONE');
            if (index0 > -1) {
              this.formData.payPlanItems[index0].isLast = false;
              result.push(this.formData.payPlanItems[index0]);
            } else {
              result.push({
                payPercent: 0.3,
                triggerEvent: 'ORDER_CONFIRMED',
                triggerDays: 5,
                moneyType: 'PHASEONE',
                triggerType: 'INSIDE',
                isLast: false
              });
            }
            index0 = this.formData.payPlanItems.findIndex((data) => data.moneyType === 'PHASETWO');
            if (index0 > -1) {
              this.formData.payPlanItems[index0].isLast = false;
              result.push(this.formData.payPlanItems[index0]);
            } else {
              result.push({
                payPercent: 0.3,
                triggerEvent: 'ORDER_CONFIRMED',
                triggerDays: 5,
                moneyType: 'PHASETWO',
                triggerType: 'INSIDE',
                isLast: false
              });
            }
            index0 = this.formData.payPlanItems.findIndex((data) => data.moneyType === 'PHASETHREE');
            if (index0 > -1) {
              this.formData.payPlanItems[index0].isLast = true;
              result.push(this.formData.payPlanItems[index0]);
            } else {
              result.push({
                payPercent: 0.3,
                triggerEvent: 'ORDER_CONFIRMED',
                triggerDays: 5,
                moneyType: 'PHASETHREE',
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
          case 'MONTHLY_SETTLEMENT_ONE':
            var index0 = this.formData.payPlanItems.findIndex((data) => data.moneyType === 'MONTHLY_SETTLEMENT_ONE');
            if (index0 > -1) {
              result.push(this.formData.payPlanItems[index0]);
              break;
            }
            var index = this.formData.payPlanItems.findIndex((data) => data.moneyType === 'MONTHLY_SETTLEMENT_TWO' &&
              !data.isRange);
            if (index > -1) {
              this.formData.payPlanItems[index].isLast = true;
              this.formData.payPlanItems[index].moneyType = 'MONTHLY_SETTLEMENT_ONE';
              result.push(this.formData.payPlanItems[index]);
            } else {
              result.push({
                isRange: false,
                moneyType: 'MONTHLY_SETTLEMENT_ONE',
                triggerType: 'INSIDE',
                isLast: true
              });
            }
            break;
          case 'MONTHLY_SETTLEMENT_TWO':
            var index0 = this.formData.payPlanItems.findIndex((data) => data.moneyType === 'MONTHLY_SETTLEMENT_TWO' &&
              !data.isRange);
            var data_one;
            var index1;
            if (index0 > -1) {
              this.formData.payPlanItems[index0].isLast = false;
              result.push(this.formData.payPlanItems[index0]);
            } else {
              index1 = this.formData.payPlanItems.findIndex((data) => data.moneyType === 'MONTHLY_SETTLEMENT_ONE');
              if (index1 > -1) {
                this.formData.payPlanItems[index1].isLast = false;
                this.formData.payPlanItems[index1].moneyType = 'MONTHLY_SETTLEMENT_TWO';
                result.push(this.formData.payPlanItems[index1]);
              } else {
                data_one = {
                  isRange: false,
                  moneyType: 'MONTHLY_SETTLEMENT_TWO',
                  triggerType: 'INSIDE',
                  isLast: false,
                  triggerEvent: '',
                  monthlyEndDayNum: ''
                };
                result.push(data_one);
              }
            }
            var index00 = this.formData.payPlanItems.findIndex((data) => data.moneyType ===
              'MONTHLY_SETTLEMENT_TWO' && data.isRange);
            if (index00 > -1) {
              this.formData.payPlanItems[index00].triggerEvent = this.formData.payPlanItems[index0].triggerEvent;
              this.formData.payPlanItems[index00].monthlyStartDayNum = this.formData.payPlanItems[index0]
                .monthlyEndDayNum;
              result.push(this.formData.payPlanItems[index00]);
            } else {
              var d = {
                isRange: true,
                moneyType: 'MONTHLY_SETTLEMENT_TWO',
                triggerType: 'INSIDE',
                isLast: true,
              };
              if (index1 > -1) {
                d.triggerEvent = this.formData.payPlanItems[index1].triggerEvent;
                d.monthlyStartDayNum = this.formData.payPlanItems[index1].monthlyEndDayNum;
              } else {
                d.triggerEvent = data_one.triggerEvent;
                d.monthlyStartDayNum = data_one.monthlyEndDayNum;
              }
              result.push(d);
            }

            break;
        }

        this.formData.payPlanItems = result;
        return result;
      },
      resultPreview: function () {
        var result = '';

        if (this.formData.payPlanItems.length <= 0) {
          return result;
        }

        this.payPlanItems.forEach((payPlanItem) => {
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
              } else {
                result += '：每月' + (payPlanItem.monthlyEndDayNum ?
                    (payPlanItem.monthlyEndDayNum == -1 ? '月底' : payPlanItem.monthlyEndDayNum + '号') : '*') +
                  '前完成' + (payPlanItem.triggerEvent ? this.getEnum('TriggerEvent', payPlanItem.triggerEvent) :
                    '****') +
                  '后于' + (payPlanItem.monthType ? this.getEnum('MonthType', payPlanItem.monthType) : '**') +
                  (payPlanItem.payDayNum ? (payPlanItem.payDayNum == -1 ? '月底' : payPlanItem.payDayNum + '号') :
                    ' *') + '支付相应款项';
              }
              break;
          }
        });


        // switch (this.formData.payPlanType) {
        //   case 'PHASEONE':
        //     let data = this.payPlanItems.filter(item => item.moneyType === 'PHASEONE')[0];
        //     result += '甲方收到乙方交付的全部产品并经甲方检验全部产品合格入库，在' +
        //       this.getEnum('TriggerEvent', data.triggerEvent) + '后' + data.triggerDays + '日' +
        //       this.getEnum('TriggerType', data.triggerType) + '未发现任何产品质量问题的则甲方向乙方支付剩余全部款项' +
        //       '（以双方确认的对账单金额为准）。' + '若发现质量问题的，则按甲乙双方对质量的相关条款处理。';
        //     break;
        //   case 'PHASETWO':
        //     let oneData = this.payPlanItems.filter(item => item.moneyType === 'PHASEONE')[0];
        //     let twoData = this.payPlanItems.filter(item => item.moneyType === 'PHASETWO')[0];
        //     result += '甲方收到乙方交付的全部产品并经甲方检验全部产品合格入库，在' +
        //       this.getEnum('TriggerEvent', oneData.triggerEvent) + '后' + oneData.triggerDays + '日' +
        //       this.getEnum('TriggerType', oneData.triggerType) + '支付合同总价的' + oneData.payPercent * 100 + '%。' +
        //       '在产品入库并经甲方检验全部产品合格' + this.getEnum('TriggerEvent', twoData.triggerEvent) + '后' + twoData.triggerDays +
        //       '日' +
        //       this.getEnum('TriggerType', twoData.triggerType) + '未发现任何产品质量问题的' + '，则甲方向乙方支付剩余全部款项' +
        //       '（以双方确认的对账单金额为准）。若发现质量问题的，则按甲乙双方对质量的相关条款处理。';
        //     break;
        //   case 'MONTHLY_SETTLEMENT':
        //     let monthData = this.payPlanItems.filter(item => item.moneyType === 'MONTHLY_SETTLEMENT')[0];
        //     result += ' 甲方收到乙方交付的全部产品并经甲方检验全部产品合格入库,甲方在' +
        //       this.getEnum('TriggerEvent', monthData.triggerEvent) + '完成的次月月底支付剩余全部款项' +
        //       '（以双方确认的对账单金额为准）。若发现质量问题的，则按甲乙双方对质量的相关条款处理。';
        //     break;
        // }
        this.formData.previewText = result;
        return result;
      }
    },
    methods: {
      onPayPlanSelect(item) {
        // 删除原有id
        this.$delete(item, 'id');
        item.payPlanItems.forEach(element => {
          this.$delete(element, 'id');
        });
        this.formData.name = item.name;
        this.formData.previewText = item.previewText;
        this.formData.remarks = item.remarks;
        this.formData.payPlanItems = item.payPlanItems;
        this.formData.payPlanType = item.payPlanType;
        this.formData.isHaveDeposit = item.isHaveDeposit;
        // this.updateCurForm(item);
        this.payPlanSelectDialogVisible = false;
      },
      async onPayPlanSave(item) {
        var payPlanForm = {
          name: this.payPlanForm.name,
          payPlanType: this.formData.payPlanType,
          isHaveDeposit: this.formData.isHaveDeposit,
          payPlanItems: this.formData.payPlanItems,
          remarks: this.payPlanForm.remarks
        }

        // 提交数据
        const url = this.apis().createPayPlan();
        const result = await this.$http.post(url, payPlanForm);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$message.success('创建账务方案成功');
        this.payPlanForm.name = '';
        this.payPlanForm.remarks = '';
        this.dialogPayPlanFormVisible = false;
      },
      startDayNumChange(item, index) {
        let i = this.payPlanItems.findIndex((data) => data.moneyType == 'MONTHLY_SETTLEMENT_TWO' && data.isRange);
        if (i > -1) {
          this.payPlanItems[i].monthlyStartDayNum = item.monthlyStartDayNum;
          if (this.payPlanItems[i].monthlyStartDayNum == -1) {
            if (this.payPlanItems[i].monthlyEndDayNum != -1) {
              delete this.payPlanItems[i].monthlyEndDayNum;
            }
          } else if (this.payPlanItems[i].monthlyStartDayNum > this.payPlanItems[i].monthlyEndDayNum) {
            delete this.payPlanItems[i].monthlyEndDayNum;
          }
        }


      },
      endDayNumChange(item, index) {
        if (!item.isRange) {
          let i = this.payPlanItems.findIndex((data) => data.moneyType == 'MONTHLY_SETTLEMENT_TWO' && data.isRange);
          if (i > -1) {
            this.payPlanItems[i].monthlyStartDayNum = item.monthlyEndDayNum;
            // this.startDayNumChange(this.payPlanItems[i],i);
            if (this.payPlanItems[i].monthlyStartDayNum == -1) {
              if (this.payPlanItems[i].monthlyEndDayNum != -1) {
                delete this.payPlanItems[i].monthlyEndDayNum;
              }
            } else if (this.payPlanItems[i].monthlyEndDayNum != -1 &&
              this.payPlanItems[i].monthlyStartDayNum > this.payPlanItems[i].monthlyEndDayNum) {
              delete this.payPlanItems[i].monthlyEndDayNum;
            }
          }
        }

        if (item.monthType == 'CURRENT_MONTH' && item.payDayNum) {
          if (item.monthlyEndDayNum == -1 && item.payDayNum != -1) {
            delete this.payPlanItems[index].payDayNum;
          } else {
            if (item.payDayNum != -1 && item.monthlyEndDayNum > item.payDayNum) {
              delete this.payPlanItems[index].payDayNum;
            }
          }
        }
      },
      monthTypeChange(item, index) {
        if (item.monthlyEndDayNum == -1 && item.payDayNum != -1) {
          delete this.payPlanItems[index].payDayNum;
        } else {
          if (item.monthType == 'CURRENT_MONTH' && item.payDayNum && item.payDayNum != -1 && item.monthlyEndDayNum >
            item.payDayNum) {
            delete this.payPlanItems[index].payDayNum;
          }
        }
      },
      triggerEventChange(item, index) {
        let i = this.payPlanItems.findIndex((data) => data.moneyType == 'MONTHLY_SETTLEMENT_TWO' && data.isRange);
        if (i > -1) {
          this.payPlanItems[i].triggerEvent = item.triggerEvent;
        }
      },
    },
    watch: {
      'payPlanItems': function (n, o) {
        console.log(o);
        console.log(n);
      }
    },
    data() {
      return {
        payPlanSelectDialogVisible: false,
        dialogPayPlanFormVisible: false,
        monthTypes: this.$store.state.EnumsModule.MonthType,
        payPlanTypes: this.$store.state.EnumsModule.PayPlanTypeV2,
        payMoneyTypes: this.$store.state.EnumsModule.PayMoneyType,
        triggerEvents: this.$store.state.EnumsModule.TriggerEvent,
        triggerEventsV2: this.$store.state.EnumsModule.TriggerEventV2,
        triggerTypes: this.$store.state.EnumsModule.TriggerType,
        triggerDays: [
          5, 7, 15
        ],
        payPlanForm: {
          name: '',
          remarks: ''
        },
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
    width: 100px;
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

  /* .purchase-form-item small.el-form-item {
    margin-bottom: 0px !important;
  }

  .purchase-form-item .el-form-item--mini.el-form-item,
  .el-form-item--small.el-form-item {
    margin-bottom: 0px !important;
  }

  .purchase-form-item .el-form-item__error {
    padding-left: 70px !important;
  } */

  .number-select {
    width: 100px;
    /* margin: 0 5px; */
  }

  .form-plane-name {
    padding-top: 8px;
    margin-right: 10px;
  }

  .end-text {
    padding-top: 7px;
    margin-left: 10px;
  }

  .form-event-select {
    margin: 0 5px;
    width: 120px
  }

</style>
