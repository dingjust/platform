<template>
  <div class="animated fadeIn content">
    <el-dialog :visible.sync="suppliersSelectVisible" width="60%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <supplier-select @onSelect="onSuppliersSelect" />
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
        <!-- <el-row type="flex" :gutter="20">
          <el-col :span="8">
            <el-form-item label="订单名称" label-width="110px" prop='name'
              :rules="{required: true, message: '不能为空', trigger: 'blur'}">
              <el-input v-model="form.name" placeholder="请输入"></el-input>
            </el-form-item>
          </el-col>
        </el-row> -->
        <el-row>
          <el-col :span="4">
            <div style="padding-left: 10px">
              <h6>合作对象</h6>
            </div>
          </el-col>
        </el-row>
        <el-row type="flex" justify="start" :gutter="20">
          <el-col :span="8">
            <el-form-item label="客户" prop='cooperator.name'
              :rules="{required: true, message: '不能为空', trigger: 'change'}">
              <el-input v-model="form.cooperator.name" :disabled="true" placeholder="请输入"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="6">
            <el-form-item label="联系人" prop='cooperator.contactPerson'
              :rules="{required: true, message: '不能为空', trigger: 'change'}">
              <el-input v-model="form.cooperator.contactPerson" :disabled="true" placeholder="请输入"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="6">
            <el-form-item label="联系方式" prop='cooperator.contactPhone'
              :rules="{required: true, message: '不能为空', trigger: 'change'}">
              <el-input v-model="form.cooperator.contactPhone" :disabled="true" placeholder="请输入"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="4">
            <el-button @click="suppliersSelectVisible=!suppliersSelectVisible" size="mini" :disabled="hasOrigin">选择供应商
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
              <MTAVAT :machiningTypes.sync="form.cooperationMode" :needVoice.sync="form.invoiceNeeded"
                :readOnly="hasOrigin" :tax.sync="form.invoiceTaxPoint" />
            </el-col>
          </el-row>
        </div>
        <el-divider />
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
        <pay-plan-form :vPayPlan.sync="form.payPlan" />
        <el-row type="flex" justify="space-between" align="middle">
          <el-col :span="4">
            <div>
              <h6>人员设置</h6>
            </div>
          </el-col>
        </el-row>
        <div class="form-block-content">
          <el-row type="flex" align="center" :gutter="10">
            <!-- <el-col :span="5">
              <el-form-item label="总负责人" label-width="85px">
                <el-input v-model="form.productionLeader.name" :disabled="true">
                </el-input>
              </el-form-item>
            </el-col> -->
            <el-col :span="6">
              <el-form-item label="生产负责人" label-width="100px" prop="productionLeader"
                :rules="{required: true, message: '不能为空', trigger: 'change'}">
                <personnel-selection :vPerson.sync="form.productionLeader" />
              </el-form-item>
            </el-col>
            <el-col :span="2">
              <el-form-item label="" label-width="5px">
                <el-checkbox v-model="form.auditNeeded">需审核</el-checkbox>
              </el-form-item>
            </el-col>
            <el-col :span="6" v-if="form.auditNeeded">
              <template v-for="(item,itemIndex) in form.approvers">
                <el-form-item :key="'a'+itemIndex" :label="'审批人'+(itemIndex+1)" label-width="100px"
                  :prop="'approvers.' + itemIndex" :rules="{required: true, message: '不能为空', trigger: 'change'}">
                  <personnel-selection :vPerson.sync="form.approvers[itemIndex]" />
                </el-form-item>
              </template>
            </el-col>
            <el-col :span="6">
              <el-form-item label="采购负责人" label-width="100px" prop="purchasingLeader"
                :rules="{required: true, message: '不能为空', trigger: 'change'}">
                <personnel-selection :vPerson.sync="form.purchasingLeader" />
              </el-form-item>
            </el-col>
          </el-row>
        </div>
        <el-row type="flex" justify="end" style="margin-top:20px;">
          <el-col :span="4">订单总数：<span style="color:red;">{{totalAmount}}</span></el-col>
          <el-col :span="4">订单金额：<span style="color:red;">{{totalPrice}}</span></el-col>
        </el-row>
        <sales-production-tabs :canChangeProduct="canChangeProduct" style="margin-top:20px;" :form="form"
          @appendProduct="appendProduct" />
      </el-form>
      <el-row style="margin-top: 20px" type="flex" justify="center" align="middle" :gutter="50">
        <el-col :span="5">
          <el-button class="material-btn" @click="onSave(false)">创建保存</el-button>
        </el-col>
        <el-col :span="5">
          <el-button class="material-btn" @click="onSave(true)">创建并提交审核</el-button>
        </el-col>
      </el-row>
    </el-card>
    <el-dialog :visible.sync="salesProductAppendVisible" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <sales-plan-append-product-form v-if="salesProductAppendVisible" @onSave="onAppendProduct"
        :needMaterialsSpec="needMaterialsSpec" :isUpdate="false" :productionLeader="form.productionLeader" />
    </el-dialog>
  </div>
</template>

<script>
  import SupplierSelect from '@/components/custom/SupplierSelect';
  import MTAVAT from '../../../../components/custom/order-form/MTAVAT';
  import SalesPlanAppendProductForm from './SalesPlanAppendProductForm';
  import PayPlanForm from '@/components/custom/order-form/PayPlanForm';
  import SalesProductionTabs from '../components/SalesProductionTabs';
  import PersonnelSelection from '@/components/custom/PersonnelSelection';

  import {
    getEntryTotalAmount,
    getEntryTotalPrice,
  } from '../js/accounting.js';

  export default {
    name: 'SalesOrderForm',
    components: {
      SalesPlanAppendProductForm,
      MTAVAT,
      SupplierSelect,
      PayPlanForm,
      SalesProductionTabs,
      PersonnelSelection
    },
    computed: {
      //根据订单类型，加工类型判断是否需要物料清单等
      needMaterialsSpec: function () {
        //销售订单
        switch (this.form.cooperationMode) {
          case 'LABOR_AND_MATERIAL':
            return true;
          case 'LIGHT_PROCESSING':
            return false;
          default:
            return false;
        }
      },
      //总数量
      totalAmount: function () {
        let total = 0;
        if (this.form.entries != null) {
          this.form.entries.forEach(element => {
            let num = parseFloat(getEntryTotalAmount(element));
            if (num != null && (!Number.isNaN(num))) {
              total += num;
            }
          });
        }
        return total;
      },
      //销售总价
      totalPrice: function () {
        let total = 0;
        this.form.entries.forEach(element => {
          let num = parseFloat(getEntryTotalPrice(element));
          if (num != null && (!Number.isNaN(num))) {
            total += num;
          }
        });
        return total;
      },
      //是否能添加删除产品
      canChangeProduct: function () {
        //新建订单
        if (this.form.id == null) {
          return true;
        }
        //来源订单不能添加删除
        if (this.form.originOrder != null && this.form.originOrder.code != null) {
          return false;
        } else {
          //订单状态
          if (this.form.auditState == 'NONE' || this.form.auditState == 'AUDITED_FAILED') {
            //TODO人员判断控制
            return true;
          } else {
            return false;
          }
        }
      },
      //是否来源外发
      hasOrigin: function () {
        if (this.form.originOrder != null && this.form.originOrder.code != null && this.form.originOrder.code != '') {
          return true;
        } else {
          return false;
        }
      }
    },
    methods: {
      appendProduct() {
        this.$refs.form.validateField('productionLeader', errMsg => {
          if (errMsg) {
            this.$message.error('请先选择生产负责人');
          } else {
            this.salesProductAppendVisible = true;
          }
        }, );
      },
      onAppendProduct(products) {
        products.forEach(element => {
          let index = this.form.entries.findIndex(entry => entry.product.code == element.product.code);
          if (index == -1) {
            //移除原有Id;
            element.materialsSpecEntries.forEach(item => {
              this.$delete(item, 'id');
              item.materialsColorEntries.forEach(colorEntry => {
                this.$delete(colorEntry, 'id');
              });
            });
            this.form.entries.push(element);
          }
        });
        this.salesProductAppendVisible = false;
      },
      onSuppliersSelect(val) {
        this.suppliersSelectVisible = false;
        this.form.cooperator.id = val.id;
        this.form.cooperator.name = val.name;
        this.form.cooperator.contactPhone = val.phone;
        this.form.cooperator.contactPerson = val.person;
        if (val.payPlan != null) {
          this.setPayPlan(val.payPlan);
          this.$message.success('已关联选择合作商绑定账务方案：' + val.payPlan.name);
        }
      },
      setPayPlan(payPlan) {
        //删除原有id
        this.$delete(payPlan, 'id');
        payPlan.payPlanItems.forEach(element => {
          this.$delete(element, 'id');
        });
        this.$set(this.form, 'payPlan', payPlan);
      },
      async onSave(submitAudit) {
        let validate = await this.validateForms();
        if (validate) {
          this._Save(submitAudit);
        } else {
          this.$message.error('请完善信息');
        }
      },
      async _Save(submitAudit) {
        const url = this.apis().salesPlanSave(submitAudit);
        let submitForm = Object.assign({}, this.form);
        if (!submitForm.auditNeeded) {
          submitForm.approvers = [];
        }
        const result = await this.$http.post(url, submitForm);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        if (result.code == '0') {
          this.$message.error(result.msg);
          return;
        } else if (result.code == '1') {
          this.$message.success('销售订单创建成功，编号： ' + result.data);
          this.$router.go(-1);
        }
      },
      async validateForms() {
        if (this.form.entries.length < 1) {
          this.$message.error('请添加产品');
          return false;
        }

        //校验明细行是否有预算单
        let costingValidate = true;
        //校验是否有核算单
        this.form.entries.forEach(element => {
          if (element.costOrder == null) {
            costingValidate = false;
          }
        });
        if (!costingValidate) {
          this.$message.error('请添加产品');
          return false;
        }

        const form = this.$refs.form;
        // 使用Promise.all 并行去校验结果
        let res = await Promise.all([form].map(this.getFormPromise));
        return res.every(item => !!item);
      },
      //封装Promise对象
      getFormPromise(form) {
        return new Promise(resolve => {
          form.validate(res => {
            resolve(res);
          })
        })
      },
    },
    data() {
      return {
        salesProductAppendVisible: false,
        suppliersSelectVisible: false,
        payPlanSelectDialogVisible: false,
        dialogPayPlanFormVisible: false,
        form: {
          name: '',
          type: 'SALES_ORDER',
          invoiceNeeded: false,
          auditNeeded: true,
          invoiceTaxPoint: 0.03,
          entries: [],
          cooperationMode: 'LABOR_AND_MATERIAL',
          payPlan: {
            isHaveDeposit: false,
            payPlanType: 'PHASEONE',
            payPlanItems: [{
              moneyType: "PHASEONE",
              payPercent: 0.003,
              triggerDays: 5,
              triggerEvent: "ORDER_CONFIRMED",
              triggerType: "INSIDE"
            }]
          },
          cooperator: {
            id: '',
            name: '',
            contactPhone: '',
            contactPerson: ''
          },
          // planLeader: {
          //   id: this.$store.getters.currentUser.id,
          //   name: this.$store.getters.currentUser.username
          // },
          productionLeader: null,
          approvers: [null],
          purchasingLeader: null
        }
      }
    },
    created() {
      if (this.$route.params.order != null) {
        Object.assign(this.form, this.$route.params.order);
        //设置对应供应商
        if (this.form.cooperator.type == 'ONLINE') {
          this.form.cooperator.name = this.form.cooperator.partner.name;
          this.form.cooperator.contactPhone = this.form.cooperator.partner.contactPhone;
          this.form.cooperator.contactPerson = this.form.cooperator.partner.contactPerson;
        }
      }
    },
    mounted() {

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
