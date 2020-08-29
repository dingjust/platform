<template>
  <div class="animated fadeIn content">
    <el-dialog :visible.sync="suppliersSelectVisible" width="60%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <supplier-select @onSelect="onSuppliersSelect" :categories="['CUSTOMER']"/>
    </el-dialog>
    <el-card>
      <el-form ref="form" :model="form" label-width="80px">
        <el-row>
          <el-col :span="4">
            <div class="sales-plan-form-title">
              <h6>录入外接订单</h6>
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
            <el-form-item label="客户" prop='originCooperator.name'
              :rules="{required: true, message: '不能为空', trigger: 'change'}">
              <el-input v-model="form.originCooperator.name" :disabled="true" placeholder="请输入"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="6">
            <el-form-item label="联系人" prop='originCooperator.contactPerson'
              :rules="{required: true, message: '不能为空', trigger: 'change'}">
              <el-input v-model="form.originCooperator.contactPerson" :disabled="true" placeholder="请输入"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="6">
            <el-form-item label="联系方式" prop='originCooperator.contactPhone'
              :rules="{required: true, message: '不能为空', trigger: 'change'}">
              <el-input v-model="form.originCooperator.contactPhone" :disabled="true" placeholder="请输入"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="4">
            <el-button @click="suppliersSelectVisible=!suppliersSelectVisible" size="mini" :disabled="hasOrigin">选择合作商
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
            <!-- <el-col :span="6">
              <el-form-item label="是否需要产前：" label-width="120" prop="needVoice">
                <el-radio v-model="form.needPreproduction" :label="true" :disabled="hasOrigin">是</el-radio>
                <el-radio v-model="form.needPreproduction" :label="false" :disabled="hasOrigin">否</el-radio>
              </el-form-item>
            </el-col> -->
          </el-row>
          <!-- <el-row type="flex">
            <el-col :span="8">
              <el-form-item label="生产节点设置" label-width="100px">
                <el-input v-model="form.progressPlan.name" :disabled="true" style="width: 200px"></el-input>
              </el-form-item>
            </el-col>
            <el-col :span="2">
              <el-button class="progreesPlan-btn" @click="progressPlanVisible = !progressPlanVisible">选择</el-button>
            </el-col>
          </el-row> -->
        </div>
        <el-divider />
        <el-row type="flex" style="padding-left: 20px">
          <el-col :span="24">
            <!-- <pay-plan-form-v2 :vPayPlan.sync="form.payPlan" :readOnly="hasOrigin" /> -->
            <pay-plan-form :formData="form.payPlan" :isUseForOrder="true" ref="payPlanCom" :readOnly="hasOrigin"/>
          </el-col>
        </el-row>
        <el-row type="flex" justify="space-between" align="middle">
          <el-col :span="4">
            <div style="padding-left: 10px">
              <h6>人员设置</h6>
            </div>
          </el-col>
        </el-row>
        <div class="form-block-content">
          <div style="display: flex;flex-wrap: wrap;">
          <el-form-item label="跟单员" prop="productionLeader"
            :rules="{required: true, message: '不能为空', trigger: 'change'}">
            <personnal-selection-v2 :vPerson.sync="form.productionLeader"/>
          </el-form-item>
          <el-form-item label="" label-width="10px">
            <el-checkbox v-model="form.auditNeeded" @change="handleClick">需审核</el-checkbox>
          </el-form-item>
          <template v-for="(item,itemIndex) in form.approvers">
            <el-form-item :key="'a'+itemIndex" :label="'审批人'+(itemIndex+1)" label-width="80px" style="margin-right:10px;"
              :prop="'approvers.' + itemIndex" :rules="{required: form.auditNeeded, message: '不能为空', trigger: 'change'}">
              <personnal-selection-v2 :vPerson.sync="form.approvers[itemIndex]" :disabled="!form.auditNeeded" 
                                      :excludeMySelf="true" style="width: 194px" :selectedRow="form.approvers"/>
            </el-form-item>
          </template>
          <el-button-group style="padding-bottom: 26px;">
            <el-button v-if="form.approvers && form.approvers.length < 5" style="height: 32px" @click="appendApprover">+ 添加审批人</el-button>
            <el-button v-if="form.approvers && form.approvers.length > 1" style="height: 32px" @click="removeApprover">删除
            </el-button>
          </el-button-group>
          </div>
          <div>
            <h6 style="color: #F56C6C">* 审批人将按照你选择的顺序逐级审批</h6>
          </div>
        </div>
        <el-row type="flex" justify="end" style="margin-top:20px;">
          <el-col :span="4">订单总数：<span style="color:red;">{{totalAmount}}</span></el-col>
          <el-col :span="4">订单金额：<span style="color:red;">{{totalPrice}}</span></el-col>
        </el-row>
        <sales-production-tabs :canChangeProduct="canChangeProduct" :canUpdate="!hasOrigin" style="margin-top:20px;"
          :form="form" @appendProduct="appendProduct" />
      </el-form>
      <el-row style="margin-top: 20px" type="flex" justify="center" align="middle" :gutter="50">
        <el-col :span="5">
          <!-- <authorized :permission="['ROLE_SALES_ORDER_CREATE']"> -->
          <el-button class="material-btn" @click="onSave(false)">保存</el-button>
          <!-- </authorized> -->
        </el-col>
        <el-col :span="5">
          <!-- <authorized :permission="['ROLE_SALES_ORDER_CREATE']"> -->
          <el-button class="material-btn" @click="onSave(true)">创建并提交审核</el-button>
          <!-- </authorized> -->
        </el-col>
      </el-row>
    </el-card>
    <el-dialog :visible.sync="salesProductAppendVisible" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <sales-plan-append-product-form ref="appendProductForm" v-if="salesProductAppendVisible" @onSave="onAppendProduct"
        :orderType="'SALES_ORDER'" :needMaterialsSpec="needMaterialsSpec" :isUpdate="false"
        :productionLeader="fromProductionLeader" />
    </el-dialog>
    <el-dialog :visible.sync="materialDialogVisible" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <sample-products-select-dialog v-if="materialDialogVisible" @onSelectSample="onSelectSample" />
    </el-dialog>
    <!-- <el-dialog :visible.sync="progressPlanVisible" width="60%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <progress-plan-select-dialog v-if="progressPlanVisible" @getProgressPlan="setProgressPlan"/>
    </el-dialog> -->
  </div>
</template>

<script>
  import SupplierSelect from '@/components/custom/SupplierSelect';
  import MTAVAT from '../../../../components/custom/order-form/MTAVAT';
  import SalesPlanAppendProductForm from './SalesPlanAppendProductForm';
  import SalesProductionTabs from '../components/SalesProductionTabs';
  import PersonnelSelection from '@/components/custom/PersonnelSelection';
  import ProgressPlanSelectDialog from '@/views/user/progress-plan/components/ProgressPlanSelectDialog'
  import SampleProductsSelectDialog from '@/views/product/sample/components/SampleProductsSelectDialog';

  import {
    PayPlanForm,
    DeptSelection,
    PersonnalSelectionV2
  } from '@/components'

  import {
    getEntryTotalAmount,
    getEntryTotalPrice
  } from '../js/accounting.js';

  export default {
    name: 'SalesOrderForm',
    components: {
      PayPlanForm,
      SalesPlanAppendProductForm,
      MTAVAT,
      SupplierSelect,
      SalesProductionTabs,
      PersonnelSelection,
      ProgressPlanSelectDialog,
      DeptSelection,
      PersonnalSelectionV2,
      SampleProductsSelectDialog
    },
    computed: {
      // 根据订单类型，加工类型判断是否需要物料清单等
      needMaterialsSpec: function () {
        // 销售订单
        switch (this.form.cooperationMode) {
          case 'LABOR_AND_MATERIAL':
            return true;
          case 'LIGHT_PROCESSING':
            return false;
          default:
            return false;
        }
      },
      // 总数量
      totalAmount: function () {
        let total = 0;
        if (this.form.taskOrderEntries != null) {
          this.form.taskOrderEntries.forEach(element => {
            let num = parseFloat(getEntryTotalAmount(element));
            if (num != null && (!Number.isNaN(num))) {
              total += num;
            }
          });
        }
        return total;
      },
      // 销售总价
      totalPrice: function () {
        let total = 0;
        this.form.taskOrderEntries.forEach(element => {
          let num = parseFloat(getEntryTotalPrice(element));
          if (num != null && (!Number.isNaN(num))) {
            total += num;
          }
        });
        return total;
      },
      // 是否能添加删除产品
      canChangeProduct: function () {
        // 新建订单
        if (this.form.id == null) {
          return true;
        }
        // 来源订单不能添加删除
        if (this.hasOrigin) {
          return false;
        } else {
          // 订单状态
          if (this.form.auditState == 'NONE' || this.form.auditState == 'AUDITED_FAILED') {
            // TODO人员判断控制
            return true;
          } else {
            return false;
          }
        }
      },
      // 是否来源外发
      hasOrigin: function () {
        //来源公司
        return this.form.originCompany != null && this.form.originCompany != '';
      },
      fromProductionLeader: function () {
        return {
          id: this.form.productionLeader[this.form.productionLeader.length - 1]
        }
      }
    },
    methods: {
      appendApprover() {
        this.form.approvers.push({});
      },
      removeApprover() {
        this.form.approvers.splice(this.form.approvers.length - 1, 1);
      },
      handleClick(value) {
        // if (!value) {
        //   this.form.approvers = [null];
        // }
        this.form.approvers.forEach((item, index) => {
          this.$refs.form.clearValidate('approvers.' + index);
        })
      },
      onSelectSample(data) {
        this.materialDialogVisible = false;
        this.salesProductAppendVisible = true;
        this.$nextTick(() => {
          this.$refs.appendProductForm.onSelectSample(data);
        })
      },
      appendProduct() {
        this.$refs.form.validateField('productionLeader', errMsg => {
          if (errMsg) {
            this.$message.error('请先选择生产负责人');
          } else {
            this.materialDialogVisible = true;
            // this.salesProductAppendVisible = true;
          }
        });
      },
      onAppendProduct(products) {
        products.forEach(element => {
          let index = this.form.taskOrderEntries.findIndex(entry => entry.product.code == element.product.code);
          if (index == -1) {
            // 移除原有Id;
            if (element.materialsSpecEntries != null) {
              element.materialsSpecEntries.forEach(item => {
                this.$delete(item, 'id');
                item.materialsColorEntries.forEach(colorEntry => {
                  this.$delete(colorEntry, 'id');
                });
              });
            }
            this.form.taskOrderEntries.push(element);
          }
        });
        this.salesProductAppendVisible = false;
      },
      onSuppliersSelect(val) {
        this.suppliersSelectVisible = false;
        this.form.originCooperator.id = val.id;
        this.form.originCooperator.name = val.name;
        this.form.originCooperator.contactPhone = val.phone;
        this.form.originCooperator.contactPerson = val.person;
        if (val.payPlan != null) {
          // this.setPayPlan(val.payPlan);
          // 删除原有id
          this.$delete(val.payPlan, 'id');
          val.payPlan.payPlanItems.forEach(element => {
            this.$delete(element, 'id');
          });
          this.form.payPlan = Object.assign({}, val.payPlan);
          this.$message.success('已关联选择合作商绑定账务方案：' + val.payPlan.name);
        }
      },
      // setProgressPlan (val) {
      //   this.form.progressPlan.id = val.id;
      //   this.form.progressPlan.name = val.name;
      //   this.progressPlanVisible = !this.progressPlanVisible;
      // },
      setPayPlan(payPlan) {
        // 删除原有id
        this.$delete(payPlan, 'id');
        payPlan.payPlanItems.forEach(element => {
          this.$delete(element, 'id');
        });
        this.$set(this.form, 'payPlan', payPlan);
      },
      async onSave(submitAudit) {
        let validate = await this.validateForms();
        if (validate) {
          if (this.hasOrigin) {
            if (this.form.originCooperator.id) {
              this._Save(submitAudit);
            } else {
              this.$confirm('此订单合作对象非本公司合作商，是否添加为合作商?', '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
              }).then(() => {
                this._Save(submitAudit);
              });
            }
          } else {
            this._Save(submitAudit);
          }
        } else {
          this.$message.error('请完善信息');
        }
      },
      async _Save(submitAudit) {
        const url = this.apis().salesOrderSave(submitAudit);
        let submitForm = Object.assign({}, this.form);
        if (!submitForm.auditNeeded) {
          submitForm.approvers = [];
        } else {
          // 处理级联选择数据
          submitForm.approvers = [];
          this.form.approvers.forEach(item => {
            if (item instanceof Array && item.length > 0) {
              submitForm.approvers.push({
                id: item[item.length - 1]
              });
            }
          })
        }
        // 处理级联选择数据
        submitForm.productionLeader = {
          id: this.form.productionLeader[this.form.productionLeader.length - 1]
        }

        const result = await this.$http.post(url, submitForm);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        if (result.code == '0') {
          this.$message.error(result.msg);
        } else if (result.code == '1') {
          this.$message.success('销售订单创建成功，编号： ' + result.data);
          this.$router.go(-1);
        }
      },
      async validateForms() {
        if (this.form.taskOrderEntries.length < 1) {
          this.$message.error('请添加产品');
          return false;
        }

        // //校验明细行是否有预算单
        // let costingValidate = true;
        // //校验是否有核算单
        // this.form.taskOrderEntries.forEach(element => {
        //   if (element.costOrder == null) {
        //     costingValidate = false;
        //   }
        // });
        // if (!costingValidate) {
        //   this.$message.error('请添加产品');
        //   return false;
        // }

        const form = this.$refs.form;
        let forms = [form];
        forms.push(this.$refs['payPlanCom'].$refs['payPlanForm']);
        // 使用Promise.all 并行去校验结果
        let res = await Promise.all(forms.map(this.getFormPromise));
        return res.every(item => !!item);
      },
      // 封装Promise对象
      getFormPromise(form) {
        return new Promise(resolve => {
          form.validate(res => {
            resolve(res);
          })
        })
      },
      validateField (name) {
        this.$refs.form.validateField(name);
      },
      validateProductionDept (rule, value, callback) {
        if (value.length <= 0) {
          callback(new Error('请选择生产部门'));
        } else {
          callback()
        }
      }
    },
    data() {
      return {
        salesProductAppendVisible: false,
        suppliersSelectVisible: false,
        payPlanSelectDialogVisible: false,
        dialogPayPlanFormVisible: false,
        materialDialogVisible: false,
        // progressPlanVisible: false,
        form: {
          name: '',
          type: 'SALES_ORDER',
          invoiceNeeded: false,
          auditNeeded: true,
          needPreproduction: true,
          invoiceTaxPoint: 0.03,
          taskOrderEntries: [],
          cooperationMode: 'LABOR_AND_MATERIAL',
          // productionDept: [],
          payPlan: {
            isHaveDeposit: false,
            payPlanType: 'PHASEONE',
            payPlanItems: [{
              moneyType: 'PHASEONE',
              payPercent: 0.003,
              triggerDays: 5,
              triggerEvent: 'ORDER_CONFIRMED',
              triggerType: 'INSIDE'
            }]
          },
          progressPlan: {
            id: null,
            name: '',
            remarks: '',
            productionProgresses: []
          },
          originCooperator: {
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
        },
      }
    },
    watch: {
      'form.productionLeader': function (nval, oval) {
        this.validateField('productionLeader');
      },
      'form.approvers': function (nval, oval) {
        this.form.approvers.forEach((item, index) => {
          this.validateField('approvers.' + index);
        })
      }
    },
    created() {
      if (this.$route.params.order != null) {
        Object.assign(this.form, this.$route.params.order);
        // 设置对应供应商
        if (this.form.originCooperator.type == 'ONLINE') {
          this.form.originCooperator.name = this.form.originCooperator.partner.name;
          this.form.originCooperator.contactPhone = this.form.originCooperator.partner.contactPhone;
          this.form.originCooperator.contactPerson = this.form.originCooperator.partner.contactPerson;
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

  .progreesPlan-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
  }

</style>
