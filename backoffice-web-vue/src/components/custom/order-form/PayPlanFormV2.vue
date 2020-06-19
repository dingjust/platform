<template>
  <div style="margin-top: 10px">
    <el-dialog :visible.sync="payPlanSelectDialogVisible" width="50%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <pay-plan-select @onSelect="onPayPlanSelect" />
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
    <el-form :model="form" :disabled="readOnly">
      <!--    <div>-->
      <!--      <el-row type="flex" justify="start" :gutter="12" class="info-order-row">-->
      <!--        <el-col :span="10">-->
      <!--          <el-row type="flex" align="start" justify="space-between">-->
      <!--            <h6 style="margin-right:5px;margin-bottom: 0px;width:200px;line-height: normal">-->
      <!--              {{form.name!=''?'当前选中方案：'+form.name:'当前未选择账务方案'}}</h6>-->
      <!--            <el-button style="margin-right:20px" @click="payPlanSelectDialogVisible=true" type="primary" plain-->
      <!--              size="mini">选用我的账务方案</el-button>-->
      <!--            <el-button @click="dialogPayPlanFormVisible=true" type="success" plain size="mini">保存账务方案</el-button>-->
      <!--          </el-row>-->
      <!--        </el-col>-->
      <!--      </el-row>-->
      <!--    </div>-->
      <div>
        <el-row type="flex" justify="start" align="middle">
          <el-col :span="6" style="padding-top: 5px;">
            <span class="info-input-prepend">有无定金：</span>
            <el-radio class="info-radio" v-model="form.isHaveDeposit" :label="true">有定金</el-radio>
            <el-radio class="info-radio" v-model="form.isHaveDeposit" :label="false">无定金</el-radio>
          </el-col>
          <el-col :span="8" style="padding-top: 5px;">
            <span class="info-input-prepend">尾款期数：</span>
            <template v-for="(value,key) in payPlanType">
              <el-radio class="info-radio" v-model="form.payPlanType" :label="key">{{value}}</el-radio>
            </template>
          </el-col>
          <el-col :span="9" :offset="1">
            <el-row type="flex" align="start" justify="space-between">
              <h6 style="margin-top: 3px;">{{form.name!=''?'当前选中方案：'+form.name:'当前未选择账务方案'}}</h6>
              <el-button @click="payPlanSelectDialogVisible=true" type="primary" plain
                size="mini">选用账务方案</el-button>
              <el-button @click="dialogPayPlanFormVisible=true" type="success" plain size="mini">保存账务方案</el-button>
            </el-row>
          </el-col>
        </el-row>
      </div>
      <div style="margin-top: 10px">
        <el-row class="info-order-row" v-if="form.isHaveDeposit" type="flex" justify="start" align="middle"
          :gutter="10">
          <el-col :span="8">
            <el-row type="flex" align="middle">
              <h6 style="padding-right: 50px;margin-bottom: 0px">定金</h6>
              <h6 class="info-input-prepend2" style="width:30px;">事件</h6>
              <el-select v-model="form.deposit.event" placeholder="请选择">
                <template v-for="(value,key) in triggerEvent">
                  <el-option :label="value" :value="key" :key="key"></el-option>
                </template>
              </el-select>
            </el-row>
          </el-col>
          <el-col :span="5">
            <el-row type="flex" align="middle" justify="start" :gutter="20">
              <el-col :span="6">
                <h6 class="info-input-prepend2" style="width:50px;">后时长</h6>
              </el-col>
              <el-input-number v-model="form.deposit.time" :precision="0" :step="1" :min="1" size="mini">
              </el-input-number>
              <h6 class="info-input-prepend2">天以内</h6>
            </el-row>
          </el-col>
          <el-col :span="8">
            <el-row type="flex" align="middle" justify="start">
              <el-col :span="4">
                <h6 class="info-input-prepend2" style="width: 40px;">付款</h6>
              </el-col>
              <el-col :span="18">
                <el-input-number v-model="form.deposit.percent" :precision="0" :step="1" :min="1" :max="99" size="mini">
                </el-input-number>
                %
              </el-col>
            </el-row>
          </el-col>
        </el-row>
        <el-row class="info-order-row" v-if="form.payPlanType!='MONTHLY_SETTLEMENT'" type="flex" justify="start"
          align="middle" :gutter="10">
          <el-col :span="8">
            <el-row type="flex" align="middle">
              <h6 style="padding-right: 14px;margin-bottom: 0px">第1期尾款</h6>
              <h6 class="info-input-prepend2" style="width:30px;">事件</h6>
              <el-select v-model="form.balance1.event" placeholder="请选择">
                <template v-for="(value,key) in triggerEvent">
                  <el-option :label="value" :value="key" :key="key"></el-option>
                </template>
              </el-select>
            </el-row>
          </el-col>
          <el-col :span="5">
            <el-row type="flex" align="middle" justify="start" :gutter="20">
              <el-col :span="6">
                <h6 class="info-input-prepend2" style="width:40px;">后时长</h6>
              </el-col>
              <el-input-number v-model="form.balance1.time" :precision="0" :step="1" :min="1" size="mini">
              </el-input-number>
              <h6 class="info-input-prepend2">天以内</h6>
            </el-row>
          </el-col>
          <el-col :span="7" v-if="form.payPlanType=='PHASEONE'">
            <el-row type="flex" align="middle" justify="start">
              <h6 class="info-input-prepend2" style="width: 200px;">支付剩余全部款项</h6>
            </el-row>
          </el-col>
          <el-col :span="8" v-if="form.payPlanType!='PHASEONE'">
            <el-row type="flex" align="middle" justify="start">
              <el-col :span="4">
                <h6 class="info-input-prepend2" style="width: 40px;">付款</h6>
              </el-col>
              <el-col :span="18">
                <el-input-number v-model="form.balance1.percent" :precision="0" :step="1" :min="1" :max="99"
                  size="mini">
                </el-input-number>
                %
              </el-col>
            </el-row>
          </el-col>
        </el-row>
        <el-row class="info-order-row" v-if="form.payPlanType=='PHASETWO'" type="flex" justify="start" align="middle"
          :gutter="10">
          <el-col :span="8">
            <el-row type="flex" align="middle">
              <h6 style="padding-right: 14px;margin-bottom: 0px">第2期尾款</h6>
              <h6 class="info-input-prepend2" style="width:30px;">事件</h6>
              <el-select v-model="form.balance2.event" placeholder="请选择">
                <template v-for="(value,key) in triggerEvent">
                  <el-option :label="value" :value="key" :key="key"></el-option>
                </template>
              </el-select>
            </el-row>
          </el-col>
          <el-col :span="5">
            <el-row type="flex" align="middle" justify="start" :gutter="20">
              <el-col :span="6">
                <h6 class="info-input-prepend2" style="width:40px;">后时长</h6>
              </el-col>
              <el-input-number v-model="form.balance2.time" :precision="0" :step="1" :min="1" size="mini">
              </el-input-number>
              <h6 class="info-input-prepend2">天以内</h6>
            </el-row>
          </el-col>
          <el-col :span="7">
            <el-row type="flex" align="middle" justify="start">
              <h6 class="info-input-prepend2" style="width: 200px;">支付剩余全部款项</h6>
            </el-row>
          </el-col>
        </el-row>
        <el-row class="info-order-row" v-if="form.payPlanType=='MONTHLY_SETTLEMENT'" type="flex" justify="start"
          align="middle" :gutter="10">
          <el-col :span="8">
            <el-row type="flex" align="middle">
              <h6 style="padding-right: 50px;margin-bottom: 0px">月结</h6>
              <h6 class="info-input-prepend2" style="width:30px;">事件</h6>
              <el-select v-model="form.monthBalance.event" placeholder="请选择">
                <template v-for="(value,key) in triggerEvent">
                  <el-option :label="value" :value="key" :key="key"></el-option>
                </template>
              </el-select>
            </el-row>
          </el-col>
          <el-col :span="4">
            <el-row type="flex" align="middle" justify="start">
              <el-row type="flex" align="middle" justify="space-between" :gutter="20">
                <el-col :span="6">
                  <h6 class="info-input-prepend2" style="width:40px;">后</h6>
                </el-col>
                <el-col :span="18">
                  <el-select v-model="form.monthBalance.time" placeholder="请选择">
                    <template v-for="val in 28">
                      <el-option :label="val" :value="val" :key="val"></el-option>
                    </template>
                    <el-option label="月底" :value="-1" :key="-1"></el-option>
                  </el-select>
                </el-col>
              </el-row>
            </el-row>
          </el-col>
          <el-col :span="13">
            <el-row type="flex" align="middle" justify="start">
              <el-col :span="24">
                <h6 class="info-input-prepend2" style="width: 200px;">号支付剩余全部款项</h6>
              </el-col>
            </el-row>
          </el-col>
        </el-row>
        <el-row type="flex" justify="start" align="middle" :gutter="10" style="margin-top: 10px" v-if="showPreview">
          <h6 style="margin-bottom: 0px;line-heigth: 25px;width: 100px;padding: 0px 4px">合同显示预览</h6>
          <el-input type="textarea" autosize v-model="resultPreview"></el-input>
        </el-row>
      </div>
    </el-form>

  </div>
</template>

<script>
  import PayPlanSelect from '../PayPlanSelect';
  export default {
    name: 'PayPlanFormV2',
    props: {
      vPayPlan: {
        type: Object
      },
      readOnly: {
        type: Boolean,
        default: false
      },
      showPreview: {
        type: Boolean,
        default: false
      }
    },
    components: {
      PayPlanSelect
    },
    computed: {
      resultPreview: function () {
        var result;
        var monthTimeStr = '';
        if (this.form.monthBalance.time > 0) {
          monthTimeStr = this.form.monthBalance.time + '号';
        } else {
          monthTimeStr = '月底'
        }
        if (this.form.isHaveDeposit && this.form.payPlanType == 'PHASETWO') {
          result = '定金+2期尾款\n        定金：在双方' + this.triggerEvent[this.form.deposit.event] + '后' + this.form.deposit
            .time +
            '天' + this.triggerType[this.form.deposit.range] + '，甲方应向乙方支付生效订单总金额的' +
            this.form.deposit
              .percent +
            '%为定金\n        支付方式：甲方收到乙方交付的全部产品并经甲方检验全部产品合格入库,在' + this.triggerEvent[this.form.balance1.event] +
            '后' + this.form.balance1
              .time +
            '天' + this.triggerType[this.form.balance1.range] + '支付合同总价的' + this.form.balance1.percent +
            '%。在产品入库并经甲方检验全部产品合格' +
            this.triggerEvent[this.form.balance2.event] + '后' +
            this.form.balance2.time + '天' + this.triggerType[this.form.balance2.range] +
            '未发现任何产品质量问题的，则甲方向乙方支付剩余全部款项（以双方确认的对账单金额为准）。若发现质量问题的，则按甲乙双方对质量的相关条款处理。';
        }
        if (this.form.isHaveDeposit && this.form.payPlanType == 'PHASEONE') {
          result = '定金+1期尾款\n        定金：在双方' + this.triggerEvent[this.form.deposit.event] + '后' + this.form.deposit
            .time +
            '天' + this.triggerType[this.form.deposit.range] + '，甲方应向乙方支付生效订单总金额的' +
            this.form.deposit
              .percent +
            '%为定金\n        支付方式：甲方收到乙方交付的全部产品并经甲方检验全部产品合格入库完成在' + this.triggerEvent[this.form.balance1.event] + '后' +
            this.form.balance1
              .time +
            '天' + this.triggerType[this.form.balance1.range] +
            '未发现任何产品质量问题的则甲方向乙方支付剩余全部款项（以双方确认的对账单金额为准）。若发现质量问题的，则按甲乙双方对质量的相关条款处理。';
        }
        if (!this.form.isHaveDeposit && this.form.payPlanType == 'PHASEONE') {
          result = '无定金1期尾款\n        甲方收到乙方交付的全部产品并经甲方检验全部产品合格入库完成在' + this.triggerEvent[this.form.balance1.event] +
            '后' + this.form
              .balance1.time + '天' +
            this.triggerType[this.form.balance1.range] +
            '未发现任何产品质量问题的则甲方向乙方支付剩余全部款项（以双方确认的对账单金额为准）。若发现质量问题的，则按甲乙双方对质量的相关条款处理。'
        }
        if (!this.form.isHaveDeposit && this.form.payPlanType == 'PHASETWO') {
          result = '无定金2期尾款\n        甲方收到乙方交付的全部产品并经甲方检验全部产品合格入库,在' + this.triggerEvent[this.form.balance1.event] +
            '后' + this.form
              .balance1.time + '天' +
            this.triggerType[this.form.balance1.range] + '支付合同总价的' + this.form.balance1.percent +
            '%。在产品入库并经甲方检验全部产品合格' + this.triggerEvent[this.form.balance2.event] + '后' + this.form.balance2.time +
            '天' + this.triggerType[this.form.balance2.range] +
            '未发现任何产品质量问题的，则甲方向乙方支付剩余全部款项（以双方确认的对账单金额为准）。若发现质量问题的，则按甲乙双方对质量的相关条款处理。';
        }
        if (this.form.isHaveDeposit && this.form.payPlanType == 'MONTHLY_SETTLEMENT') {
          result = '有定金+月结\n        定金：在双方' + this.triggerEvent[this.form.deposit.event] + '后' + this.form.deposit
            .time +
            '天' + this.triggerType[this.form.deposit.range] + '，甲方应向乙方支付生效订单总金额的' + this
              .form.deposit
              .percent +
            '%为定金\n        支付方式：甲方收到乙方交付的全部产品并经甲方检验全部产品合格入库,甲方在' + this.triggerEvent[this.form.monthBalance.event] +
            '完成的次月' + monthTimeStr + '支付剩余全部款项（以双方确认的对账单金额为准）。若发现质量问题的，则按甲乙双方对质量的相关条款处理。';
        }
        if (!this.form.isHaveDeposit && this.form.payPlanType == 'MONTHLY_SETTLEMENT') {
          result = '无定金月结\n        甲方收到乙方交付的全部产品并经甲方检验全部产品合格入库,甲方在' + this.triggerEvent[this.form.monthBalance
            .event] +
            '完成的次月' + monthTimeStr + '支付剩余全部款项（以双方确认的对账单金额为准）。若发现质量问题的，则按甲乙双方对质量的相关条款处理。';
        }

        return result;
      }
    },
    methods: {
      onPayPlanSelect(item) {
        //删除原有id
        this.$delete(item, 'id');
        item.payPlanItems.forEach(element => {
          this.$delete(element, 'id');
        });
        this.updateCurForm(item);
        this.form.name = item.name;
        this.payPlanSelectDialogVisible = false;
      },
      async onPayPlanSave() {
        // 组合账务参数
        var payPlanItems = [];
        if (this.form.isHaveDeposit) {
          payPlanItems.push({
            payPercent: this.form.deposit.percent * 0.01,
            triggerEvent: this.form.deposit.event,
            triggerDays: this.form.deposit.time,
            moneyType: 'DEPOSIT',
            triggerType: this.form.deposit.range
          });
        }
        if (this.form.payPlanType == 'MONTHLY_SETTLEMENT') {
          payPlanItems.push({
            triggerEvent: this.form.monthBalance.event,
            moneyType: 'MONTHLY_SETTLEMENT',
            triggerDays: this.form.monthBalance.time
          });
        } else {
          payPlanItems.push({
            payPercent: this.form.balance1.percent * 0.01,
            triggerEvent: this.form.balance1.event,
            triggerDays: this.form.balance1.time,
            moneyType: 'PHASEONE',
            triggerType: this.form.balance1.range
          });
          if (this.form.payPlanType == 'PHASETWO') {
            payPlanItems.push({
              payPercent: this.form.balance2.percent * 0.01,
              triggerEvent: this.form.balance2.event,
              triggerDays: this.form.balance2.time,
              moneyType: 'PHASETWO',
              triggerType: this.form.balance2.range
            });
          }
        }

        var payPlanForm = {
          name: this.payPlanForm.name,
          payPlanType: this.form.payPlanType,
          isHaveDeposit: this.form.isHaveDeposit,
          payPlanItems: payPlanItems,
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
      updateCurForm(val) {
        console.log(JSON.stringify(val));

        if (val.name != null) {
          this.form.name = val.name;
        }

        if (val.isHaveDeposit != null) {
          this.form.isHaveDeposit = val.isHaveDeposit;
        }
        if (val.payPlanType != null) {
          this.form.payPlanType = val.payPlanType;
        }

        if (val.payPlanItems != null) {
          val.payPlanItems.forEach(item => {
            switch (item.moneyType) {
              case 'DEPOSIT':
                this.form.deposit.event = item.triggerEvent;
                this.form.deposit.time = item.triggerDays;
                this.form.deposit.range = item.triggerType;
                this.form.deposit.percent = item.payPercent * 100;
              case 'PHASEONE':
                this.form.balance1.event = item.triggerEvent;
                this.form.balance1.time = item.triggerDays;
                this.form.balance1.range = item.triggerType;
                this.form.balance1.percent = item.payPercent * 100;
              case 'PHASETWO':
                this.form.balance2.event = item.triggerEvent;
                this.form.balance2.time = item.triggerDays;
                this.form.balance2.range = item.triggerType;
                this.form.balance2.percent = item.payPercent * 100;
              case 'MONTHLY_SETTLEMENT':
                this.form.monthBalance.event = item.triggerEvent;
                this.form.monthBalance.time = item.triggerDays;
            }
          });
          this.form.payPlanItems = val.payPlanItems;
        }
      },
      updateBindingForm() {
        console.log('============');
        console.log(JSON.stringify(newVal));
        // 组合账务参数
        var payPlanItems = [];
        if (newVal.isHaveDeposit) {
          payPlanItems.push({
            payPercent: newVal.deposit.percent * 0.01,
            triggerEvent: newVal.deposit.event,
            triggerDays: newVal.deposit.time,
            moneyType: 'DEPOSIT',
            triggerType: newVal.deposit.range
          });
        }
        if (newVal.payPlanType == 'MONTHLY_SETTLEMENT') {
          payPlanItems.push({
            triggerEvent: newVal.monthBalance.event,
            moneyType: 'MONTHLY_SETTLEMENT',
            triggerDays: newVal.monthBalance.time
          });
        } else {
          payPlanItems.push({
            payPercent: newVal.balance1.percent * 0.01,
            triggerEvent: newVal.balance1.event,
            triggerDays: newVal.balance1.time,
            moneyType: 'PHASEONE',
            triggerType: newVal.balance1.range
          });
          if (newVal.payPlanType == 'PHASETWO') {
            payPlanItems.push({
              payPercent: newVal.balance2.percent * 0.01,
              triggerEvent: newVal.balance2.event,
              triggerDays: newVal.balance2.time,
              moneyType: 'PHASETWO',
              triggerType: newVal.balance2.range
            });
          }
        }

        this.$emit('update:vPayPlan', {
          name: this.form.name,
          payPlanType: newVal.payPlanType,
          isHaveDeposit: newVal.isHaveDeposit,
          payPlanItems: payPlanItems,
        });
      }
    },
    data() {
      return {
        payPlanSelectDialogVisible: false,
        dialogPayPlanFormVisible: false,
        payPlanType: {
          'PHASEONE': '一期尾款',
          'PHASETWO': '二期尾款',
          'MONTHLY_SETTLEMENT': '月结',
          // 'Cash_On_Delivery': '货到付款',
          // 'Payment_To_Delivery': '款到发货'
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
        },
        payPlanForm: {
          name: '',
          remarks: ''
        },
        form: {
          name: '',
          isHaveDeposit: false,
          payPlanType: 'PHASEONE',
          payPlanItems: [],
          deposit: {
            event: 'ORDER_CONFIRMED',
            time: 5,
            range: 'INSIDE',
            percent: 0.3
          },
          balance1: {
            event: 'ORDER_CONFIRMED',
            time: 5,
            range: 'INSIDE',
            percent: 0.3
          },
          balance2: {
            event: 'ORDER_CONFIRMED',
            time: 5,
            range: 'INSIDE',
            percent: 0.3
          },
          monthBalance: {
            event: 'ORDER_CONFIRMED',
            time: 5
          }
        },
      }
    },
    watch: {
      vPayPlan: {
        handler(newVal, oldVal) {
          this.updateCurForm(newVal);
        },
      },
      form: {
        handler(newVal, oldVal) {
          // 组合账务参数
          var payPlanItems = [];
          if (newVal.isHaveDeposit) {
            payPlanItems.push({
              payPercent: newVal.deposit.percent * 0.01,
              triggerEvent: newVal.deposit.event,
              triggerDays: newVal.deposit.time,
              moneyType: 'DEPOSIT',
              triggerType: newVal.deposit.range
            });
          }
          if (newVal.payPlanType == 'MONTHLY_SETTLEMENT') {
            payPlanItems.push({
              triggerEvent: newVal.monthBalance.event,
              moneyType: 'MONTHLY_SETTLEMENT',
              triggerDays: newVal.monthBalance.time
            });
          } else {
            payPlanItems.push({
              payPercent: newVal.balance1.percent * 0.01,
              triggerEvent: newVal.balance1.event,
              triggerDays: newVal.balance1.time,
              moneyType: 'PHASEONE',
              triggerType: newVal.balance1.range
            });
            if (newVal.payPlanType == 'PHASETWO') {
              payPlanItems.push({
                payPercent: newVal.balance2.percent * 0.01,
                triggerEvent: newVal.balance2.event,
                triggerDays: newVal.balance2.time,
                moneyType: 'PHASETWO',
                triggerType: newVal.balance2.range
              });
            }
          }

          this.$set(this.vPayPlan, 'name', this.form.name);
          this.$set(this.vPayPlan, 'payPlanType', newVal.payPlanType);
          this.$set(this.vPayPlan, 'isHaveDeposit', newVal.isHaveDeposit);
          this.$set(this.vPayPlan, 'payPlanItems', payPlanItems);
        },
        deep: true
      }
    },
    created() {
      this.updateCurForm(this.vPayPlan);
    },
    mounted() {

    }
  };

</script>

<style scoped>
  .outbound-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .form-block-content {
    padding-left: 20px;
  }

  .contract-btn {
    background-color: #FFD60C;
    border-color: #FFD60C;
    color: #000;
    width: 90px;
  }

  .info-radio .el-radio__label {
    font-size: 10px;
  }

  .info-input-prepend {
    display: inline-block;
    margin-right: 7px;
  }

  .info-input-prepend2 {
    display: inline-block;
    margin: 0 5px;
    width: 50px;
    font-size: 10px;
    color: rgba(0, 0, 0, 0.45);
  }

  .info-order-row {
    margin-bottom: 20px;
  }

  .material-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    width: 120px;
    height: 40px;
  }

</style>
