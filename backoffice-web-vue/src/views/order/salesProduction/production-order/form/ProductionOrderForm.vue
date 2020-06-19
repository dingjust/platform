<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="6">
          <div class="orders-list-title">
            <h6>创建生产工单</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <div style="margin-left: 10px">
        <el-form ref="form" label-width="80px" :rules="rules" :model="formData">
          <el-row>
            <label class="el-form-item__label">合作对象</label>
          </el-row>
          <el-row class="basic-form-row" type="flex" justify="start">
            <el-col :span="6">
              <el-form-item label="合作商" prop="cooperator" style="margin-bottom: 0px">
                <el-input v-model="formData.cooperator.partner.name" :disabled="true"></el-input>
                <el-checkbox v-model="formData.isSelfProduction" style="margin-bottom: 0px;"
                             @change="handleCheckChange">自有工厂</el-checkbox>
              </el-form-item>
            </el-col>
            <el-col :span="6">
              <el-form-item label="联系人" style="margin-bottom: 0px">
                <el-input v-model="formData.cooperator.partner.contactPerson" :disabled="true"></el-input>
              </el-form-item>
            </el-col>
            <el-col :span="6">
              <el-form-item label="联系方式" style="margin-bottom: 0px">
                <el-input v-model="formData.cooperator.partner.contactPhone" :disabled="true"></el-input>
              </el-form-item>
            </el-col>
            <el-col :span="4" :offset="1">
              <el-button @click="suppliersSelectVisible=!suppliersSelectVisible" size="mini"
                         :disabled="formData.isSelfProduction">选择供应商</el-button>
            </el-col>
          </el-row>
          <el-row>
            <label class="el-form-item__label">生产详情</label>
          </el-row>
          <el-row class="basic-form-row" type="flex">
            <el-col :span="6">
              <el-form-item label="产品名称" prop="productionTask">
                <el-input v-model="formData.productionTask.product.name" :disabled="true"></el-input>
              </el-form-item>
            </el-col>
            <el-col :span="2" :offset="1">
              <el-button @click="taskDialogVisible = !taskDialogVisible">选择任务</el-button>
            </el-col>
            <el-col :span="8">
              <el-form-item label="交货日期" prop="expectedDeliveryDate">
                <el-date-picker v-model="formData.expectedDeliveryDate" type="date" placeholder="选择日期"
                                value-format="timestamp"/>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row class="basic-form-row" type="flex">
            <el-col :span="24">
              <outbound-order-color-size-table v-if="formData.productionTask.product.colorSizeEntries.length > 0"
                                               :product="formData.productionTask.product"/>
            </el-col>
          </el-row>
          <el-row class="basic-form-row" type="flex">
            <el-col :span="24">
              <my-address-form :vAddress.sync="formData.deliveryAddress" ref="addressForm"/>
            </el-col>
          </el-row>
          <el-divider></el-divider>
          <el-row>
            <label class="el-form-item__label">生产详情</label>
          </el-row>
          <el-row class="basic-form-row" type="flex">
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
          <el-row class="basic-form-row" type="flex">
            <el-col :span="6">
              <el-form-item label="生产节点" prop="progressWorkSheet">
                <el-input v-model="formData.progressWorkSheet.name" :disabled="true"></el-input>
              </el-form-item>
            </el-col>
            <el-col :span="2" :offset="1">
              <el-button class="outbound-btn" @click="progressPlanVisible = !progressPlanVisible">选择</el-button>
            </el-col>
          </el-row>
          <el-row>
            <label class="el-form-item__label">财务设置</label>
          </el-row>
          <el-row class="basic-form-row" type="flex">
            <el-col :span="24">
              <pay-plan-form-v2 :vPayPlan.sync="formData.payPlan" :showPreview="true"/>
            </el-col>
          </el-row>
          <el-row>
            <label class="el-form-item__label">人员设置</label>
          </el-row>
          <el-row class="basic-form-row" type="flex">
            <el-col :span="6">
              <el-form-item label="跟单员" prop="partyAOperator">
                <personnel-selection :vPerson.sync="formData.partyAOperator"/>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row>
            <label class="el-form-item__label">备注及附件</label>
          </el-row>
          <el-row class="basic-form-row" type="flex" justify="start">
            <el-col :span="24">
              <el-form-item label="备注">
                <el-input type="textarea" v-model="formData.remarks"></el-input>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row class="basic-form-row" type="flex">
            <el-form-item label="附件">
              <images-upload class="order-purchase-upload" :slot-data="formData.attachments"/>
            </el-form-item>
          </el-row>
        </el-form>
        <el-row type="flex" justify="center" align="middle">
          <el-button class="material-btn" @click="onCreate">确认创建</el-button>
        </el-row>
      </div>
    </el-card>
    <el-dialog :visible.sync="suppliersSelectVisible" width="60%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <suppliers-select @onSelect="onSuppliersSelect" />
    </el-dialog>
    <el-dialog :visible.sync="taskDialogVisible" width="80%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <production-task-select-dialog v-if="taskDialogVisible" :isSingleChoice="true" :selectType="'PRODUCTION_ORDER'"
                                     :formData="formData" @onSelectTask="onSelectTask"/>
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
    mapGetters,
    mapActions
  } = createNamespacedHelpers(
    'ProductionOrderModule'
  );

  import SuppliersSelect from '@/views/contract/manage/components/SupplierSelect.vue';
  import ProductionTaskSelectDialog from '../../production-task/components/ProductionTaskSelectDialog';
  import MyAddressForm from '@/components/custom/order-form/MyAddressForm';
  import MTAVAT from '@/components/custom/order-form/MTAVAT';
  import ProgressPlanSelectDialog from '../../../../user/progress-plan/components/ProgressPlanSelectDialog';
  import MyPayPlanForm from '@/components/custom/order-form/MyPayPlanForm';
  import PersonnelSelection from '@/components/custom/PersonnelSelection';
  import ImagesUpload from '@/components/custom/ImagesUpload';
  import OutboundOrderColorSizeTable from '../../outbound-order/table/OutboundOrderColorSizeTable';
  import {PayPlanFormV2} from '@/components/'

  export default {
    name: 'ProductionOrderForm',
    components: {
      OutboundOrderColorSizeTable,
      ImagesUpload,
      PersonnelSelection,
      MyPayPlanForm,
      ProgressPlanSelectDialog,
      MTAVAT,
      MyAddressForm,
      ProductionTaskSelectDialog,
      SuppliersSelect,
      PayPlanFormV2
    },
    props: [],
    computed: {
      ...mapGetters({
        formData: 'createFormData'
      })
    },
    methods: {
      ...mapActions({
        clearFormData: 'clearCreateFormData'
      }),
      // 判断是否为自有工厂
      handleCheckChange (val) {
        if (val) {
          this.formData.cooperator = {
            id: '',
            partner: {
              id: '',
              name: '',
              contactPerson: '',
              contactPhone: ''
            }
          };
        }
      },
      // 选择合作商
      onSuppliersSelect (val) {
        this.suppliersSelectVisible = false;
        this.formData.cooperator = {
          id: val.id,
          partner: {
            name: val.name,
            contactPerson: val.person,
            contactPhone: val.phone
          }
        };
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
      // 选择生产任务
      onSelectTask (selectTaskList) {
        this.formData.entries[0] = {
          productionTask: {
            id: selectTaskList[0].id
          }
        }
        this.formData.productionTask = {
          id: selectTaskList[0].id
        };
        this.formData.productionTask.product = {
          id: selectTaskList[0].productionEntry.product.id,
          name: selectTaskList[0].productionEntry.product.name,
          thumbnail: selectTaskList[0].productionEntry.product.thumbnail,
          colorSizeEntries: selectTaskList[0].productionEntry.colorSizeEntries
        };
        this.formData.deliveryAddress = selectTaskList[0].productionEntry.shippingAddress;
        if (this.$refs.addressForm) {
          this.$refs.addressForm.getCities(selectTaskList[0].productionEntry.shippingAddress.region);
          this.$refs.addressForm.onCityChanged(selectTaskList[0].productionEntry.shippingAddress.city);
        }
        this.taskDialogVisible = false;
      },
      // 选择进度节点
      getProgressPlan (val) {
        let item = {};
        let progressList = [];
        val.productionProgresses.forEach(val => {
          item.medias = val.medias;
          item.progressPhase = val.progressPhase;
          item.quantity = val.quantity;
          item.sequence = val.sequence;
          item.warningDays = val.warningDays;
          item.completeAmount = val.completeAmount;
          item.productionProgressOrders = val.productionProgressOrders;
          progressList.push(item);
          item = {}
        })
        this.formData.progressWorkSheet = {
          name: val.name,
          progresses: progressList
        };
        this.progressPlanVisible = false;
      },
      // 封装Promise对象
      getFormPromise (form) {
        return new Promise(resolve => {
          form.validate(res => {
            resolve(res);
          })
        })
      },
      async validateForms () {
        var formArr = [];
        formArr.push(this.$refs['form']);
        formArr.push(this.$refs.addressForm.$refs.address);
        // const form = this.$refs.form;
        // const addressForm = this.$refs.addressComp.$refs.address;
        // 使用Promise.all 并行去校验结果
        let res = await Promise.all(formArr.map(this.getFormPromise));

        return res.every(item => !!item);
      },
      async onCreate () {
        let validate = await this.validateForms();
        if (validate) {
          this._onCreate();
        } else {
          this.$message.error('请完善表单信息');
        }
      },
      _onCreate () {
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
        let data = {
          cooperator: {
            id: this.formData.cooperator.id
          },
          isSelfProduction: this.formData.isSelfProduction,
          productionTask: {
            id: this.formData.productionTask.id
          },
          expectedDeliveryDate: this.formData.expectedDeliveryDate,
          deliveryAddress: this.formData.deliveryAddress,
          machiningType: this.formData.machiningType,
          invoiceNeeded: this.formData.invoiceNeeded,
          invoiceTaxPoint: this.formData.invoiceNeeded ? this.formData.invoiceTaxPoint : null,
          freightPayer: this.formData.freightPayer,
          progressWorkSheet: {
            progresses: this.formData.progressWorkSheet.progresses
          },
          payPlan: this.formData.payPlan,
          remarks: this.formData.remarks,
          partyAOperator: {
            id: this.formData.partyAOperator.id
          },
          attachments: this.formData.attachments
        }
        this.__onCreate(data);
      },
      async __onCreate (data) {
        const url = this.apis().createProductionOrder();
        const result = await this.$http.post(url, data);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$message.success('创建生产工单成功');
        await this.$router.push('/sales/productionOrder');
      },
      validateField (name) {
        this.$refs.form.validateField(name);
      }
      // validateProduct (rule, value, callback) {
      //   if (value.id) {
      //     return callback();
      //   } else {
      //     return callback(new Error('请选择产品'))
      //   }
      // }
    },
    data () {
      var checkProgressPlan = (rule, value, callback) => {
        if (value.name) {
          return callback();
        } else {
          return callback(new Error('请选择生产节点'));
        }
      };
      var validateProduct = (rule, value, callback) => {
        if (value.id) {
          return callback();
        } else {
          return callback(new Error('请选择产品'))
        }
      };
      var validateOperator = (rule, value, callback) => {
        if (value.id != '') {
          return callback();
        } else {
          return callback(new Error('请选择跟单员'))
        }
      };
      var checkCooperator = (rule, value, callback) => {
        if (value.id != '' || this.formData.isSelfProduction) {
          return callback();
        } else {
          return callback(new Error('请选择合作商'))
        }
      };
      return {
        suppliersSelectVisible: false,
        taskDialogVisible: false,
        progressPlanVisible: false,
        rules: {
          'cooperator': [{ type: 'object', validator: checkCooperator, trigger: 'change' }],
          'progressWorkSheet': [{ type: 'object', validator: checkProgressPlan, trigger: 'change' }],
          'productionTask': [{ type: 'object', validator: validateProduct, trigger: 'change' }],
          'expectedDeliveryDate': [{required: true, message: '请选择交货日期', trigger: 'change'}],
          'partyAOperator': [{ type: 'object', validator: validateOperator, trigger: 'change' }]
        }
      }
    },
    watch: {
      'formData.progressPlan': function (n, o) {
        this.validateField('progressPlan');
      }
    },
    created () {

    },
    mounted () {

    },
    destroyed() {
      this.clearFormData();
    }
  }
</script>

<style scoped>
  .orders-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .basic-form-row {
    margin-left: 10px
  }

  .outbound-btn {
    background: #FFD60C;
    color: rgba(0, 0, 0, 0.85);
    width: 70px;
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

  .material-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    width: 120px;
    height: 40px;
  }
</style>
