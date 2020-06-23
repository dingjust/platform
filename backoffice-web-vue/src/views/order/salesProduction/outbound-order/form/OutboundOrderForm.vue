<template>
  <div class="animated fadeIn content">
    <el-dialog :visible.sync="suppliersSelectVisible" width="60%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <suppliers-select @onSelect="onSuppliersSelect" />
    </el-dialog>
    <el-card>
      <el-row>
        <el-col :span="4">
          <div class="outbound-order-create-title">
            <h6>创建外发订单</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <el-form ref="form" label-width="80px" :rules="rules" :model="formData">
        <el-row>
          <el-col :span="4">
            <div style="padding-left: 10px">
              <h6>合作对象</h6>
            </div>
          </el-col>
        </el-row>
        <el-row class="outbound-basic-row" type="flex" justify="start" :gutter="20">
          <el-col :span="8">
            <el-form-item label="外发工厂" prop="outboundCompanyName">
              <el-input v-model="formData.outboundCompanyName" :disabled="true"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="6">
            <el-form-item label="联系人" prop="outboundContactPerson">
              <el-input v-model="formData.outboundContactPerson" :disabled="true"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="6">
            <el-form-item label="联系方式" prop="outboundContactPhone">
              <el-input v-model="formData.outboundContactPhone" :disabled="true"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="4">
            <el-button @click="suppliersSelectVisible=!suppliersSelectVisible" size="mini">选择供应商</el-button>
          </el-col>
        </el-row>
        <template v-for="(item, index) in formData.entries">
          <el-form ref="itemForm" label-width="80px" :model="item">
            <el-row type="flex" justify="end" v-if="index > 0">
              <el-col :span="2">
                <el-button class="outbound-btn" @click="deleteRow(index)">删除</el-button>
              </el-col>
            </el-row>
            <el-row>
              <el-col :span="4">
                <div style="padding-left: 10px">
                  <h6>生产详情</h6>
                </div>
              </el-col>
            </el-row>
            <el-row class="outbound-basic-row" type="flex" justify="start" :gutter="20">
              <el-col :span="8">
                <el-form-item label="产品名称" prop="product" :rules="[{ type: 'object', validator: validateProduct, trigger: 'change' }]">
                  <el-input v-model="item.product.name" :disabled="true" placeholder="请输入"></el-input>
                </el-form-item>
              </el-col>
              <el-col :span="4">
                <el-button @click="onProductSelect(index)" size="mini">选择任务</el-button>
              </el-col>
            </el-row>
            <outbound-order-color-size-table v-if="item.colorSizeEntries.length > 0" :product="item"/>
            <el-row class="outbound-basic-row" type="flex" justify="start" :gutter="20">
              <el-col :span="6">
                <el-form-item label="发单价格" prop="billPrice" :rules="[{required: true, message: '请填写发单价格', trigger: 'blur'}]">
                  <el-input v-model="item.billPrice" placeholder="请输入" @blur="onBlur(item,'billPrice')"
                            v-number-input.float="{ min: 0 ,decimal:2}"></el-input>
                </el-form-item>
              </el-col>
              <el-col :span="6">
                <el-form-item label="交货日期" prop="expectedDeliveryDate" :rules="[{required: true, message: '请选择交货日期', trigger: 'change'}]">
                  <el-date-picker v-model="item.expectedDeliveryDate" type="date"
                                  value-format="timestamp" placeholder="选择日期"></el-date-picker>
                </el-form-item>
              </el-col>
            </el-row>
            <el-row class="outbound-basic-row" type="flex" justify="start" :gutter="20">
              <el-col :span="24">
                <my-address-form :vAddress.sync="item.shippingAddress" ref="addressForm"/>
              </el-col>
            </el-row>
          </el-form>
          <el-divider/>
        </template>
        <el-row type="flex" justify="center" class="info-order-row" align="middle">
          <el-col :span="24">
            <div class="order-purchase-table-btn_add" @click="addRow">
              +添加另一生产任务
            </div>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="4">
            <div style="padding-left: 10px">
              <h6>生产详情</h6>
            </div>
          </el-col>
        </el-row>
        <el-row class="outbound-basic-row" type="flex" justify="start" :gutter="20">
          <el-col :span="18">
            <MTAVAT :machiningTypes.sync="formData.machiningType" :needVoice.sync="formData.invoiceNeeded"
                    :tax.sync="formData.invoiceTaxPoint" />
          </el-col>
          <el-col :span="6">
            <el-form-item label="运费承担：" label-width="120">
              <el-radio v-model="formData.freightPayer" :label="'PARTYA'">甲方</el-radio>
              <el-radio v-model="formData.freightPayer" :label="'PARTYB'">乙方</el-radio>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row class="outbound-basic-row" type="flex" justify="start" :gutter="20">
          <el-col :span="6">
            <el-form-item label="生产节点" prop="progressPlan">
              <el-input v-model="formData.progressPlan.name" :disabled="true"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="2">
            <el-button class="outbound-btn" @click="progressPlanVisible = !progressPlanVisible">选择</el-button>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="4">
            <div style="padding-left: 10px">
              <h6>财务设置</h6>
            </div>
          </el-col>
        </el-row>
        <el-row class="outbound-basic-row" type="flex" justify="start" :gutter="20" style="margin-bottom: 20px">
          <el-col :span="24">
            <!-- <pay-plan-form-v4 :vPayPlan.sync="formData.payPlan" :showPreview="true"/> -->
            <pay-plan-form-v2 :vPayPlan.sync="formData.payPlan" :showPreview="true"/>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="4">
            <div style="padding-left: 10px">
              <h6>人员设置</h6>
            </div>
          </el-col>
        </el-row>
        <el-row class="outbound-basic-row" style="margin-top: 10px" type="flex" justify="start" :gutter="20" align="top">
          <el-col :span="6">
            <el-form-item label="跟单员" prop="partyAOperator">
              <personnel-selection :vPerson.sync="formData.partyAOperator"/>
            </el-form-item>
          </el-col>
          <el-col :span="2">
            <el-checkbox v-model="formData.isApproval" style="padding-top: 5px">是否需要审核</el-checkbox>
          </el-col>
          <template v-for="(item, index) in formData.approvers">
            <el-col :span="6" v-if="formData.isApproval">
              <el-form-item label="审核员" prop="approvers" :rules="[{ type: 'object', validator: checkApprover, trigger: 'change' }]">
                <personnel-selection :vPerson.sync="formData.approvers[index]"/>
              </el-form-item>
            </el-col>
          </template>
        </el-row>
        <el-row>
          <el-col :span="4">
            <div style="padding-left: 10px">
              <h6>附件及备注</h6>
            </div>
          </el-col>
        </el-row>
        <el-row style="padding-left: 10px" type="flex" justify="start" :gutter="20">
          <el-col :span="24">
            <el-form-item label="备注">
              <el-input
                type="textarea"
                :rows="2"
                placeholder="请输入内容"
                v-model="formData.remarks">
              </el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row class="outbound-basic-row" type="flex" justify="start" :gutter="20">
          <el-form-item label="附件">
            <images-upload class="order-purchase-upload" :slot-data="formData.attachments"/>
          </el-form-item>
        </el-row>
      </el-form>
      <el-row style="margin-top: 20px" type="flex" justify="center" align="middle" :gutter="50">
        <el-col :span="5">
          <el-button class="material-btn" @click="onSave">保存</el-button>
        </el-col>
        <el-col :span="5">
          <el-button class="material-btn" @click="onCreate">创建并提交</el-button>
        </el-col>
      </el-row>
    </el-card>
    <el-dialog :visible.sync="taskDialogVisible" width="80%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <production-task-select-dialog v-if="taskDialogVisible" :formData="formData" @onSelectTask="onSelectTask" :selectType="'OUTBOUND_ORDER'"/>
    </el-dialog>
    <el-dialog :visible.sync="progressPlanVisible" width="60%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <progress-plan-select-dialog v-if="progressPlanVisible" @getProgressPlan="getProgressPlan"/>
    </el-dialog>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';

  const {
    mapActions
  } = createNamespacedHelpers(
    'OutboundOrderModule'
  );

  import SuppliersSelect from '../../../../contract/manage/components/SupplierSelect';
  import MyAddressForm from '../../../../../components/custom/order-form/MyAddressForm';
  import MTAVAT from '../../../../../components/custom/order-form/MTAVAT';
  import MyPayPlanForm from '../../../../../components/custom/order-form/MyPayPlanForm';
  import ImagesUpload from '../../../../../components/custom/ImagesUpload';
  import ProgressPlanSelectDialog from '../../../../user/progress-plan/components/ProgressPlanSelectDialog';
  import ProductionTaskSelectDialog from '../../production-task/components/ProductionTaskSelectDialog';
  import OutboundOrderColorSizeTable from '../table/OutboundOrderColorSizeTable';
  import PersonnelSelection from '@/components/custom/PersonnelSelection';
  import {PayPlanFormV2} from '@/components/'
  export default {
    name: 'OutboundOrderForm',
    components: {
      PersonnelSelection,
      OutboundOrderColorSizeTable,
      ProductionTaskSelectDialog,
      ProgressPlanSelectDialog,
      ImagesUpload,
      MyPayPlanForm,
      MTAVAT,
      MyAddressForm,
      SuppliersSelect,
      PayPlanFormV2
    },
    methods: {
      ...mapActions({
        clearFormData: 'clearFormData'
      }),
      getProgressPlan (val) {
        let item = {};
        let progressList = [];
        val.productionProgresses.forEach(val => {
          item.medias = val.medias;
          item.progressPhase = val.progressPhase;
          item.quantity = val.quantity;
          item.sequence = val.sequence;
          item.completeAmount = val.completeAmount;
          item.warningDays = val.warningDays;
          item.productionProgressOrders = val.productionProgressOrders;
          progressList.push(item);
          item = {}
        })
        this.formData.progressPlan = {
          name: val.name,
          remarks: val.remarks,
          productionProgresses: progressList
        };
        this.progressPlanVisible = false;
      },
      onBlur (row, attribute) {
        var reg = /\.$/;
        if (reg.test(row[attribute])) {
          this.$set(row, attribute, parseFloat(row[attribute] + '0'));
        }
      },
      onSuppliersSelect (val) {
        this.suppliersSelectVisible = false;
        this.formData.outboundCompanyName = val.name;
        this.formData.outboundContactPerson = val.person;
        this.formData.outboundContactPhone = val.phone;
        this.formData.cooperator.id = val.id;
        if (val.payPlan != null) {
          this.formData.payPlan = val.payPlan;
          // this.setPayPlan(val.payPlan);
          this.$message.success('已关联选择合作商绑定账务方案：' + val.payPlan.name);
        }
      },
      setPayPlan (payPlan) {
        this.formData.payPlan.name = payPlan.name;
        this.formData.payPlan.isHaveDeposit = payPlan.isHaveDeposit;
        this.formData.payPlan.payPlanType = payPlan.payPlanType;
        payPlan.payPlanItems.forEach((item) => {
          switch (item.moneyType) {
            case 'PHASEONE':
              this.formData.payPlan.balance1.percent = item.payPercent * 100;
              this.formData.payPlan.balance1.event = item.triggerEvent;
              this.formData.payPlan.balance1.time = item.triggerDays;
              this.formData.payPlan.balance1.range = item.triggerType;
              break;
            case 'PHASETWO':
              this.formData.payPlan.balance2.percent = item.payPercent * 100;
              this.formData.payPlan.balance2.event = item.triggerEvent;
              this.formData.payPlan.balance2.time = item.triggerDays;
              this.formData.payPlan.balance2.range = item.triggerType;
              break;
            case 'DEPOSIT':
              this.formData.payPlan.deposit.percent = item.payPercent * 100;
              this.formData.payPlan.deposit.event = item.triggerEvent;
              this.formData.payPlan.deposit.time = item.triggerDays;
              this.formData.payPlan.deposit.range = item.triggerType;
              break;
            case 'MONTHLY_SETTLEMENT':
              this.formData.payPlan.monthBalance.event = item.triggerEvent;
              this.formData.payPlan.monthBalance.time = item.triggerDays;
              break;
          }
        });
      },
      onProductSelect (index) {
        this.taskDialogVisible = true;
        this.selectIndex = index;
      },
      addRow () {
        let item = {
          productionTask: {
            id: ''
          },
          billPrice: '',
          expectedDeliveryDate: '',
          shippingAddress: {},
          product: {},
          colorSizeEntries: []
        };
        this.formData.entries.push(item);
      },
      deleteRow (index) {
        this.formData.entries.splice(index, 1);
      },
      onSelectTask (selectTaskList) {
        let row = {}
        let index;
        let entries = [];
        selectTaskList.forEach(item => {
          index = this.formData.entries.findIndex(val => val.productionTask.id == item.id);
          if (index > -1) {
            entries.push(this.formData.entries[index]);
          } else {
            row = {
              productionTask: {
                id: item.id
              },
              billPrice: '',
              expectedDeliveryDate: '',
              shippingAddress: item.productionEntry.shippingAddress,
              product: {
                id: item.productionEntry.product.id,
                name: item.productionEntry.product.name,
                thumbnail: item.productionEntry.product.thumbnail
              },
              colorSizeEntries: item.productionEntry.colorSizeEntries
            }
            entries.push(row);
            row = {};
          }
        })
        this.formData.entries = entries;
        // 回显地址
        this.formData.entries.forEach((val, index) => {
          if (this.$refs.addressForm[index]) {
            this.$refs.addressForm[index].getCities(val.shippingAddress.region);
            this.$refs.addressForm[index].onCityChanged(val.shippingAddress.city);
          }
        })
        this.taskDialogVisible = false;
      },
      // 封装Promise对象
      getFormPromise (form) {
        return new Promise(resolve => {
          form.validate(res => {
            resolve(res);
          })
        })
      },
      async onCreate () {
        let validate = await this.validateForms();
        if (validate) {
          this._onCreate(true);
        } else {
          this.$message.error('请完善表单信息');
        }
      },
      async validateForms () {
        var formArr = [];
        formArr.push(this.$refs['form']);
        this.$refs['itemForm'].forEach(item => {
          formArr.push(item);
        })
        this.$refs['addressForm'].forEach(item => {
          formArr.push(item.$refs['address']);
        })
        // const form = this.$refs.form;
        // const addressForm = this.$refs.addressComp.$refs.address;
        // 使用Promise.all 并行去校验结果
        let res = await Promise.all(formArr.map(this.getFormPromise));

        return res.every(item => !!item);
      },
      _onCreate (isSumbitAudit) {
        // var payPlanData = {
        //   isHaveDeposit: this.formData.payPlan.isHaveDeposit,
        //   payPlanType: this.formData.payPlan.payPlanType,
        //   payPlanItems: []
        // };
        // if (this.formData.payPlan.isHaveDeposit) {
        //   payPlanData.payPlanItems.push({
        //     payPercent: this.formData.payPlan.deposit.percent * 0.01,
        //     triggerEvent: this.formData.payPlan.deposit.event,
        //     triggerDays: this.formData.payPlan.deposit.time,
        //     moneyType: 'DEPOSIT',
        //     triggerType: this.formData.payPlan.deposit.range
        //   });
        // }
        // if (this.formData.payPlan.payPlanType == 'MONTHLY_SETTLEMENT') {
        //   payPlanData.payPlanItems.push({
        //     triggerEvent: this.formData.payPlan.monthBalance.event,
        //     moneyType: 'MONTHLY_SETTLEMENT',
        //     triggerDays: this.formData.payPlan.monthBalance.time
        //   });
        // } else {
        //   payPlanData.payPlanItems.push({
        //     payPercent: this.formData.payPlan.balance1.percent * 0.01,
        //     triggerEvent: this.formData.payPlan.balance1.event,
        //     triggerDays: this.formData.payPlan.balance1.time,
        //     moneyType: 'PHASEONE',
        //     triggerType: this.formData.payPlan.balance1.range
        //   });
        //   if (this.formData.payPlan.payPlanType == 'PHASETWO') {
        //     payPlanData.payPlanItems.push({
        //       payPercent: this.formData.payPlan.balance2.percent * 0.01,
        //       triggerEvent: this.formData.payPlan.balance2.event,
        //       triggerDays: this.formData.payPlan.balance2.time,
        //       moneyType: 'PHASETWO',
        //       triggerType: this.formData.payPlan.balance2.range
        //     });
        //   }
        // }
        let data = Object.assign({}, this.formData);
        // data.payPlan = payPlanData;

        // 人员设置数据处理
        if (!this.formData.isApproval) {
          data.approvers = [];
        }
        if (!data.invoiceNeeded) {
          data.invoiceTaxPoint = null;
        }
        if (isSumbitAudit) {
          this.__onCreate(data);
        } else {
          this._onSave(data);
        }
      },
      async __onCreate (data) {
        if (this.formData.id) {
          const url = this.apis().updateOutboundOrder();
          const result = await this.$http.put(url, data, {
            submitAudit: true
          });
          if (result['errors']) {
            this.$message.error(result['errors'][0].message);
            return;
          }
          this.$message.success('编辑外发订单成功');
        } else {
          const url = this.apis().createOutboundOrder();
          const result = await this.$http.post(url, data, {
            submitAudit: true
          });
          if (result['errors']) {
            this.$message.error(result['errors'][0].message);
            return;
          }
          this.$message.success('创建外发订单成功');
        }
        await this.$router.push({
          name: '外发订单列表'
        });
      },
      // 保存不提交
      onSave () {
        this._onCreate(false);
      },
      async _onSave (data) {
        // const url = this.apis().createOutboundOrder();
        let url = data.id ? this.apis().updateOutboundOrder() : this.apis().createOutboundOrder();
        const result = await this.$http.post(url, data, {
          submitAudit: false
        });
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$message.success('保存外发订单成功');
        await this.$router.push({
          name: '外发订单列表'
        });
      },
      validateField (name) {
        this.$refs.form.validateField(name);
      },
      validateProduct (rule, value, callback) {
        if (value.id) {
          return callback();
        } else {
          return callback(new Error('请选择产品'))
        }
      },
      checkApprover (rule, value, callback) {
        if (value[0] && value[0].id) {
          return callback();
        } else {
          return callback(new Error('请选择审核员'))
        }
      },
      initData () {
        if (this.$route.params.formData != null) {
          this.formData = this.$route.params.formData;
          if (this.formData.entries.length <= 0) {
            this.addRow();
          }
          // if (this.formData.payPlan.payPlanItems.length > 0) {
          //   this.setPayPlan(this.formData.payPlan);
          // }
          if (this.formData.status == 'NOT_COMMITED') {
            if (!this.formData.cooperator) {
              this.formData.cooperator = {
                id: ''
              }
            }
            this.formData.entries.forEach(item => {
              if (item.product == null) {
                item.product = {
                  id: '',
                  name: '',
                  thumbnail: ''
                }
              }
              if (item.productionTask == null) {
                item.productionTask = {
                  id: ''
                }
              }
            })
          }
        } else {
          this.formData = Object.assign({}, this.$store.state.OutboundOrderModule.formData);
        }
      }
    },
    data () {
      var checkProgressPlan = (rule, value, callback) => {
        if (value.name) {
          return callback();
        } else {
          return callback(new Error('请选择生产节点'));
        }
      };
      var checkPartyAOperator = (rule, value, callback) => {
        if (value && value.id != '') {
          return callback();
        } else {
          return callback(new Error('请选择跟单员'));
        }
      };
      return {
        rules: {
          outboundCompanyName: [{required: true, message: '请选择外发工厂', trigger: 'change'}],
          outboundContactPerson: [{required: true, message: '请选择联系人', trigger: 'change'}],
          outboundContactPhone: [{required: true, message: '请选择联系方式', trigger: 'change'}],
          progressPlan: [{ type: 'object', validator: checkProgressPlan, trigger: 'change' }],
          partyAOperator: [{ type: 'object', validator: checkPartyAOperator, trigger: 'change' }]
        },
        formData: '',
        suppliersSelectVisible: false,
        taskDialogVisible: false,
        selectIndex: '',
        progressPlanVisible: false,
        operator: {},
        count: 0,
        operatorList: [{
          id: 1,
          name: '张三'
        }, {
          id: 2,
          name: '李四'
        }, {
          id: 3,
          name: '王五'
        }]
      }
    },
    watch: {
      'formData.progressPlan': function (n, o) {
        this.validateField('progressPlan');
      }
    },
    created () {
      this.initData();
    },
    mounted () {
      this.$nextTick(() => {
        this.$refs['form'].clearValidate();
      })
    },
    destroyed () {
      this.clearFormData();
    }
  }
</script>

<style scoped>
  .outbound-order-create-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .outbound-basic-row {
    padding-left: 20px;
  }

  .outbound-btn {
    background: #FFD60C;
    color: rgba(0, 0, 0, 0.85);
    width: 70px;
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

  /deep/ .el-divider--horizontal {
    margin: 16px 0;
  }

  .order-purchase-upload {
    margin-left: 5px;
  }

  .order-purchase-upload>>>.el-upload--picture-card {
    width: 100px;
    height: 100px;
    line-height: 100px;
  }

  .order-purchase-upload>>>.el-upload-list--picture-card .el-upload-list__item {
    width: 100px;
    height: 100px;
  }
</style>
