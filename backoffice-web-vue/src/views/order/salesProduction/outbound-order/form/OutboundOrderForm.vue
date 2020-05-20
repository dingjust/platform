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
      <el-form ref="form" label-width="80px" :rules="rules">
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
                <el-form-item label="产品名称">
                  <el-input v-model="item.product.name" :disabled="true" placeholder="请输入"></el-input>
                </el-form-item>
              </el-col>
              <el-col :span="4">
                <el-button @click="onProductSelect(index)" size="mini">选择产品/任务</el-button>
              </el-col>
            </el-row>
            <el-row class="outbound-basic-row" type="flex" justify="start" :gutter="20">
              <el-col :span="6">
                <el-form-item label="发单价格">
                  <el-input v-model="item.billPrice" placeholder="请输入" @blur="onBlur(item,'billPrice')"
                            v-number-input.float="{ min: 0 ,decimal:2}"></el-input>
                </el-form-item>
              </el-col>
              <el-col :span="6">
                <el-form-item label="交货日期">
                  <el-date-picker v-model="item.expectedDeliveryDate" type="date"
                                  value-format="timestamp" placeholder="选择日期"></el-date-picker>
                </el-form-item>
              </el-col>
            </el-row>
            <el-row class="outbound-basic-row" type="flex" justify="start" :gutter="20">
              <el-col :span="24">
                <my-address-form :vAddress.sync="item.shippingAddress" />
              </el-col>
            </el-row>
          <el-divider/>
        </template>
        <el-row type="flex" justify="center" class="info-order-row" align="middle">
          <el-col :span="24">
            <div class="order-purchase-table-btn_add" @click="addRow">
              +添加另一款产品
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
          <el-col :span="4">
            <el-form-item label="生产节点">
              <el-input></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="2">
            <el-button class="outbound-btn">选择</el-button>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="4">
            <div style="padding-left: 10px">
              <h6>财务设置</h6>
            </div>
          </el-col>
        </el-row>
        <el-row class="outbound-basic-row" type="flex" justify="start" :gutter="20">
          <el-col :span="24">
            <my-pay-plan-form :form="formData.payPlan"/>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="4">
            <div style="padding-left: 10px">
              <h6>人员设置</h6>
            </div>
          </el-col>
        </el-row>
        <el-row class="outbound-basic-row" type="flex" justify="start" :gutter="20">
          <el-col :span="4">
            <el-checkbox v-model="formData.noCheck">是否需要审核</el-checkbox>
          </el-col>
          <el-col :span="20" v-if="formData.noCheck">
            <el-input :disabled="true"></el-input>
          </el-col>
<!--          <el-col :span="20">-->
<!--            <template v-for="(value, index) in formData.operator">-->
<!--              <el-form-item label="审批人">-->
<!--                <el-select v-model="formData.operator[index]">-->
<!--                  <el-option v-for="item in options"-->
<!--                    :key="item.value"-->
<!--                    :label="item.label"-->
<!--                    :value="item.value">-->
<!--                  </el-option>-->
<!--                </el-select>-->
<!--              </el-form-item>-->
<!--            </template>-->
<!--          </el-col>-->
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
          <el-button class="material-btn" @click="onCreate">确认创建</el-button>
        </el-col>
      </el-row>
    </el-card>
    <el-dialog :visible.sync="sampleDialogVisible" width="80%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <sample-products-select-dialog v-if="sampleDialogVisible" @onSelectSample="onSelectSample"/>
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
    'OutboundOrderModule'
  );

  import SuppliersSelect from '../../../../contract/manage/components/SupplierSelect';
  import MyAddressForm from '../../../../../components/custom/order-form/MyAddressForm';
  import MTAVAT from '../../../../../components/custom/order-form/MTAVAT';
  import MyPayPlanForm from '../../../../../components/custom/order-form/MyPayPlanForm';
  import ImagesUpload from '../../../../../components/custom/ImagesUpload';
  import SampleProductsSelectDialog from '../../../../product/sample/components/SampleProductsSelectDialog';
  export default {
    name: 'OutboundOrderForm',
    components: {
      SampleProductsSelectDialog,
      ImagesUpload,
      MyPayPlanForm,
      MTAVAT,
      MyAddressForm,
      SuppliersSelect
    },
    computed: {
      ...mapGetters({
        formData: 'formData'
      })
    },
    methods: {
      ...mapActions({
        clearFormData: 'clearFormData'
      }),
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
          this.setPayPlan(val.payPlan);
          this.$message.success('已关联选择合作商绑定账务方案：' + val.payPlan.name);
        }
      },
      setPayPlan (payPlan) {
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
        this.sampleDialogVisible = true;
        this.selectIndex = index;
      },
      addRow () {
        let item = {
          productionTaskId: '',
          billPrice: '',
          expectedDeliveryDate: '',
          shippingAddress: {},
          product: {}
        };
        this.formData.entries.push(item);
      },
      deleteRow (index) {
        this.formData.entries.splice(index, 1);
      },
      onSelectSample (data) {
        this.sampleDialogVisible = false;
        this.formData.entries[this.selectIndex].product.name = data.name;
        this.formData.entries[this.selectIndex].product.id = data.id;
      },
      async onCreate () {
        var payPlanData = {
          isHaveDeposit: this.formData.payPlan.isHaveDeposit,
          payPlanType: this.formData.payPlan.payPlanType,
          payPlanItems: []
        };
        if (this.formData.payPlan.isHaveDeposit) {
          payPlanData.payPlanItems.push({
            payPercent: this.formData.payPlan.deposit.percent * 0.01,
            triggerEvent: this.formData.payPlan.deposit.event,
            triggerDays: this.formData.payPlan.deposit.time,
            moneyType: 'DEPOSIT',
            triggerType: this.formData.payPlan.deposit.range
          });
        }
        if (this.formData.payPlan.payPlanType == 'MONTHLY_SETTLEMENT') {
          payPlanData.payPlanItems.push({
            triggerEvent: this.formData.payPlan.monthBalance.event,
            moneyType: 'MONTHLY_SETTLEMENT',
            triggerDays: this.formData.payPlan.monthBalance.time
          });
        } else {
          payPlanData.payPlanItems.push({
            payPercent: this.formData.payPlan.balance1.percent * 0.01,
            triggerEvent: this.formData.payPlan.balance1.event,
            triggerDays: this.formData.payPlan.balance1.time,
            moneyType: 'PHASEONE',
            triggerType: this.formData.payPlan.balance1.range
          });
          if (this.formData.payPlanType == 'PHASETWO') {
            payPlanData.payPlanItems.push({
              payPercent: this.formData.payPlan.balance2.percent * 0.01,
              triggerEvent: this.formData.payPlan.balance2.event,
              triggerDays: this.formData.payPlan.balance2.time,
              moneyType: 'PHASETWO',
              triggerType: this.formData.payPlan.balance2.range
            });
          }
        }
        let data = Object.assign({}, this.formData);
        data.payPlan = payPlanData;

        const url = this.apis().createOutboundOrder();
        const result = await this.$http.post(url, data);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$message.success('创建外发订单成功');
        await this.$router.push({
          name: '外发订单列表'
        });
      }
    },
    data () {
      return {
        rules: {
          outboundCompanyName: [{required: true, message: '请选择外发工厂', trigger: 'change'}]
        },
        suppliersSelectVisible: false,
        sampleDialogVisible: false,
        selectIndex: ''
      }
    },
    created() {
      if (this.formData.payplan.payPlanItems.length > 0) {
        this.setPayPlan(this.formData.payplan);
      }
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
