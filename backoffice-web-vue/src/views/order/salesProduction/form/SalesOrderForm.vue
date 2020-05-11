<template>
  <div class="animated fadeIn content">
    <el-dialog :visible.sync="suppliersSelectVisible" width="60%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <supplier-select @onSelect="onSuppliersSelect" />
    </el-dialog>
    <el-dialog :visible.sync="payPlanSelectDialogVisible" width="50%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
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
    <el-card>
      <el-form ref="form" :model="form" label-width="80px">
        <el-row>
          <el-col :span="4">
            <div class="sales-plan-form-title">
              <h6>录入销售订单</h6>
            </div>
          </el-col>
        </el-row>
        <div class="pt-2"></div>
        <el-row type="flex" :gutter="20">
          <el-col :span="8">
            <el-form-item label="计划名称">
              <el-input v-model="form.name" placeholder="请输入"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="4">
            <div style="padding-left: 10px">
              <h6>合作对象</h6>
            </div>
          </el-col>
        </el-row>
        <el-row type="flex" justify="start" :gutter="20">
          <el-col :span="8">
            <el-form-item label="客户">
              <el-input v-model="form.companyOfSeller" :disabled="true" placeholder="请输入"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="6">
            <el-form-item label="联系人">
              <el-input v-model="form.contactPersonOfSeller" :disabled="true" placeholder="请输入"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="6">
            <el-form-item label="联系方式">
              <el-input v-model="form.contactOfSeller" :disabled="true" placeholder="请输入"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="4">
            <el-button @click="suppliersSelectVisible=!suppliersSelectVisible" size="mini">选择供应商
            </el-button>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="4">
            <div style="padding-left: 10px">
              <h6>订单详情</h6>
            </div>
          </el-col>
        </el-row>
        <div class="form-block-content">
          <el-row type="flex">
            <el-col :span="18">
              <MTAVAT :machiningTypes.sync="form.machiningTypes" :needVoice.sync="form.needVoice"
                      :tax.sync="form.tax" />
            </el-col>
          </el-row>
          <my-address-form :vAddress.sync="form.address" />
        </div>
        <el-divider/>
        <el-row type="flex" justify="space-between" align="middle">
          <el-col :span="4">
            <div style="padding-left: 10px">
              <h6>财务设置</h6>
            </div>
          </el-col>
          <el-col :span="4">
            <el-button class="contract-btn">添加合同</el-button>
          </el-col>
        </el-row>
        <div class="form-block-content" style="margin-top: 10px">
          <el-row type="flex" justify="start" :gutter="20" class="info-order-row">
            <el-col :span="10">
              <el-row type="flex" align="middle" justify="space-between">
                <h6 style="margin-right:5px;width:180px">
                  {{currentFinancialPlan!=''?'当前选中方案：'+currentFinancialPlan:'当前未选择账务方案'}}</h6>
                <el-button style="margin-right:20px" @click="payPlanSelectDialogVisible=true" type="primary" plain
                           size="mini">选用我的账务方案</el-button>
                <el-button @click="dialogPayPlanFormVisible=true" type="success" plain size="mini">保存账务方案</el-button>
              </el-row>
            </el-col>
          </el-row>
        </div>
        <div class="form-block-content">
          <el-row type="flex" justify="start">
            <el-col :span="9">
              <span class="info-input-prepend">有无定金：</span>
              <el-radio class="info-radio" v-model="form.isHaveDeposit" :label="true">有定金</el-radio>
              <el-radio class="info-radio" v-model="form.isHaveDeposit" :label="false">无定金</el-radio>
            </el-col>
            <el-col :span="14">
              <span class="info-input-prepend">尾款期数：</span>
              <template v-for="(value,key) in payPlanType">
                <el-radio class="info-radio" v-model="form.payPlanType" :label="key">{{value}}</el-radio>
              </template>
            </el-col>
          </el-row>
        </div>
        <div class="form-block-content" style="margin-top: 10px">
          <el-row class="info-order-row" v-if="form.isHaveDeposit" type="flex" justify="start" align="middle" :gutter="10">
            <el-col :span="7">
              <el-row type="flex" align="middle">
                <h6 style="padding-right: 50px;margin-bottom: 0px">定金</h6>
                  <h6 class="info-input-prepend2" style="width:30px;">事件</h6>
                  <el-select v-model="form.deposit.event" placeholder="请选择">
                    <template v-for="(value,key) in triggerEvent">
                      <el-option :label="value" :value="key"></el-option>
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
                  <el-input-number v-model="form.deposit.percent" :precision="0" :step="1" :min="1" :max="99"
                                   size="mini">
                  </el-input-number>
                  %
                </el-col>
              </el-row>
            </el-col>
          </el-row>
          <el-row class="info-order-row" v-if="form.payPlanType!='MONTHLY_SETTLEMENT'" type="flex" justify="start"
                  align="middle" :gutter="10">
            <el-col :span="7">
              <el-row type="flex" align="middle">
                <h6 style="padding-right: 14px;margin-bottom: 0px">第1期尾款</h6>
                <h6 class="info-input-prepend2" style="width:30px;">事件</h6>
                <el-select v-model="form.balance1.event" placeholder="请选择">
                  <template v-for="(value,key) in triggerEvent">
                    <el-option :label="value" :value="key"></el-option>
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
            <el-col :span="7">
              <el-row type="flex" align="middle">
<!--                <h6 class="info-input-prepend">第2期尾款</h6>-->
                <h6 style="padding-right: 14px;margin-bottom: 0px">第2期尾款</h6>
                <h6 class="info-input-prepend2" style="width:30px;">事件</h6>
                <el-select v-model="form.balance2.event" placeholder="请选择">
                  <template v-for="(value,key) in triggerEvent">
                    <el-option :label="value" :value="key"></el-option>
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
            <el-col :span="7">
              <el-row type="flex" align="middle">
                <h6 style="padding-right: 50px;margin-bottom: 0px">月结</h6>
                <h6 class="info-input-prepend2" style="width:30px;">事件</h6>
                <el-select v-model="form.monthBalance.event" placeholder="请选择">
                  <template v-for="(value,key) in triggerEvent">
                    <el-option :label="value" :value="key"></el-option>
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
        </div>
        <el-row type="flex" justify="space-between" align="middle">
          <el-col :span="4">
            <div style="padding-left: 10px">
              <h6>人员设置</h6>
            </div>
          </el-col>
        </el-row>
        <div class="form-block-content" style="margin-top: 10px">
          <el-row type="flex" justify="start" align="middle" :gutter="20">
            <el-col :span="6">
              <el-form-item label="总负责人" label-width="85px">
                <el-select v-model="form.productionCadre" placeholder="请选择" value-key="value">
                  <el-option
                    v-for="item in options"
                    :key="item.value"
                    :label="item.label"
                    :value="item.value">
                  </el-option>
                </el-select>
              </el-form-item>
            </el-col>
            <el-col :span="6">
              <el-form-item label="总审批人" label-width="85px">
                <el-select v-model="form.productionCadre" placeholder="请选择" value-key="value">
                  <el-option
                    v-for="item in options"
                    :key="item.value"
                    :label="item.label"
                    :value="item.value">
                  </el-option>
                </el-select>
              </el-form-item>
            </el-col>
            <el-col :span="2">
              <el-form-item label="" label-width="5px">
                <el-checkbox v-model="form.noCheck">无需审核</el-checkbox>
              </el-form-item>
            </el-col>
            <el-col :span="5">
              <el-form-item label="生产负责人" label-width="85px">
                <el-select v-model="form.productionCadre" placeholder="请选择" value-key="value">
                  <el-option
                    v-for="item in options"
                    :key="item.value"
                    :label="item.label"
                    :value="item.value">
                  </el-option>
                </el-select>
              </el-form-item>
            </el-col>
            <el-col :span="5">
              <el-form-item label="采购审批人" label-width="85px">
                <el-select v-model="form.productionCadre" placeholder="请选择" value-key="value">
                  <el-option
                    v-for="item in options"
                    :key="item.value"
                    :label="item.label"
                    :value="item.value">
                  </el-option>
                </el-select>
              </el-form-item>
            </el-col>
          </el-row>
        </div>
        <sales-order-products-table @appendProduct="appendProduct"/>
      </el-form>
      <el-row style="margin-top: 20px" type="flex" justify="center" align="middle" :gutter="50">
        <el-col :span="5">
          <el-button class="material-btn">创建保存</el-button>
        </el-col>
        <el-col :span="5">
          <el-button class="material-btn">创建并提交审核</el-button>
        </el-col>
      </el-row>
    </el-card>
    <el-dialog :visible.sync="salesProductAppendVisible" width="80%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <sales-plan-append-product v-if="salesProductAppendVisible" @onAppendProduct="onAppendProduct"/>
    </el-dialog>
  </div>
</template>

<script>
  import SupplierSelect from '@/components/custom/SupplierSelect';
  import MTAVAT from '../../../../components/custom/order-form/MTAVAT';
  import MyAddressForm from '../../../../components/custom/order-form/MyAddressForm';
  import PayPlanSelect from '../../../../components/custom/PayPlanSelect';
  import SalesOrderProductsTable from '../components/SalesOrderProductsTable';
  import SalesPlanAppendProduct from '../components/SalesPlanAppendProduct';

  export default {
    name: 'SalesPlanForm',
    components: {
      SalesPlanAppendProduct,
      SalesOrderProductsTable,
      PayPlanSelect,
      MyAddressForm,
      MTAVAT,
      SupplierSelect
    },
    computed: {

    },
    methods: {
      appendProduct () {
        this.salesProductAppendVisible = true;
      },
      onAppendProduct () {
        this.salesProductAppendVisible = false;
      },
      onSuppliersSelect (val) {
        this.suppliersSelectVisible = false;
        this.form.companyOfSeller = val.name;
        this.form.contactPersonOfSeller = val.person;
        this.form.contactOfSeller = val.phone;
        this.form.cooperator.id = val.id;
        if (val.payPlan != null) {
          this.setPayPlan(val.payPlan);
          this.$message.success('已关联选择合作商绑定账务方案：' + val.payPlan.name);
        }
      },
      onPayPlanSelect (item) {
        this.setPayPlan(item);
        this.currentFinancialPlan = item.name;
        this.payPlanSelectDialogVisible = false;
      },
      async onPayPlanSave () {
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
      setPayPlan (payPlan) {
        this.form.isHaveDeposit = payPlan.isHaveDeposit;
        this.form.payPlanType = payPlan.payPlanType;
        payPlan.payPlanItems.forEach((item) => {
          switch (item.moneyType) {
            case 'PHASEONE':
              this.form.balance1.percent = item.payPercent * 100;
              this.form.balance1.event = item.triggerEvent;
              this.form.balance1.time = item.triggerDays;
              this.form.balance1.range = item.triggerType;
              break;
            case 'PHASETWO':
              this.form.balance2.percent = item.payPercent * 100;
              this.form.balance2.event = item.triggerEvent;
              this.form.balance2.time = item.triggerDays;
              this.form.balance2.range = item.triggerType;
              break;
            case 'DEPOSIT':
              this.form.deposit.percent = item.payPercent * 100;
              this.form.deposit.event = item.triggerEvent;
              this.form.deposit.time = item.triggerDays;
              this.form.deposit.range = item.triggerType;
              break;
            case 'MONTHLY_SETTLEMENT':
              this.form.monthBalance.event = item.triggerEvent;
              this.form.monthBalance.time = item.triggerDays;
              break;
          }
        });
      }
    },
    data () {
      return {
        salesProductAppendVisible: false,
        suppliersSelectVisible: false,
        currentFinancialPlan: '',
        payPlanSelectDialogVisible: false,
        dialogPayPlanFormVisible: false,
        payPlanType: {
          'PHASEONE': '一期尾款',
          'PHASETWO': '二期尾款',
          'MONTHLY_SETTLEMENT': '月结',
          'Cash_On_Delivery': '货到付款',
          'Payment_To_Delivery': '款到发货'
        },
        triggerEvent: {
          'ORDER_CONFIRMED': '确认订单',
          'CONTRACT_SIGNED': '签署合同',
          'DELIVERY_CONFIRMED': '确认收货',
          'RECONCILIATION_CONFIRMED': '确认对账',
          'INVOICE_RECEIVED': '收到发票'
        },
        payPlanForm: {
          name: '',
          remarks: ''
        },
        options: [{
          label: '张三',
          name: '张三',
          value: '张三'
        }, {
          label: '李四',
          name: '李四',
          value: '李四'
        }],
        form: {
          name: 'CO00000000001',
          companyOfSeller: '',
          contactPersonOfSeller: '',
          contactOfSeller: '',
          address: {},
          machiningTypes: 'LABOR_AND_MATERIAL',
          needVoice: false,
          tax: 0.03,
          noCheck: true,
          productionCadre: {
            code: 1010,
            name: '张三',
            value: '张三',
            label: '张三'
          },
          isHaveDeposit: false,
          payPlanType: 'PHASEONE',
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
        }
      }
    },
    created () {

    },
    mounted () {

    }
  };
</script>

<style scoped>
  .sales-plan-form-title {
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
