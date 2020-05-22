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
        <el-row type="flex" :gutter="20">
          <el-col :span="8">
            <el-form-item label="订单名称">
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
              <el-input v-model="form.cooperator.name" :disabled="true" placeholder="请输入"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="6">
            <el-form-item label="联系人">
              <el-input v-model="form.cooperator.contactPerson" :disabled="true" placeholder="请输入"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="6">
            <el-form-item label="联系方式">
              <el-input v-model="form.cooperator.contactPhone" :disabled="true" placeholder="请输入"></el-input>
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
          <my-address-form :vAddress.sync="form.address" ref="addressComp" />
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
            <el-col :span="5">
              <el-form-item label="总负责人" label-width="85px">
                <el-input v-model="form.productionLeader.name" :disabled="true">
                </el-input>
              </el-form-item>
            </el-col>
            <el-col :span="5">
              <el-form-item label="生产负责人" label-width="85px">
                <el-input v-model="form.productionLeader.name" :disabled="true">
                </el-input>
              </el-form-item>
            </el-col>
            <el-col :span="2">
              <el-form-item label="" label-width="5px">
                <el-checkbox v-model="form.auditNeeded">需审核</el-checkbox>
              </el-form-item>
            </el-col>
            <el-col :span="5" v-if="form.auditNeeded">
              <el-form-item label="审批人" label-width="85px">
                <template v-for="item in form.approvers">
                  <el-input :key="item.id" v-model="item.name" :disabled="true">
                  </el-input>
                </template>
              </el-form-item>
            </el-col>
            <el-col :span="5">
              <el-form-item label="采购负责人" label-width="85px">
                <el-input v-model="form.productionLeader.name" :disabled="true">
                </el-input>
              </el-form-item>
            </el-col>
          </el-row>
        </div>
        <el-row type="flex" justify="end">
          <el-col :span="4">订单总数：<span style="color:red;">{{totalAmount}}</span></el-col>
          <el-col :span="4">订单金额：<span style="color:red;">{{totalPrice}}</span></el-col>
        </el-row>
        <sales-order-tabs style="margin-top:20px;" :form="form" @appendProduct="appendProduct" />
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
    <el-dialog :visible.sync="salesProductAppendVisible" width="90%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <sales-order-append-product-form v-if="salesProductAppendVisible" @onSave="onAppendProduct" :isUpdate="false"
        :productionLeader="form.productionLeader" />
    </el-dialog>
  </div>
</template>

<script>
  import SupplierSelect from '@/components/custom/SupplierSelect';
  import MTAVAT from '../../../../components/custom/order-form/MTAVAT';
  import MyAddressForm from '../../../../components/custom/order-form/MyAddressForm';
  import SalesOrderAppendProductForm from './SalesOrderAppendProductForm';
  import PayPlanForm from '@/components/custom/order-form/PayPlanForm';
  import SalesOrderTabs from '../components/SalesOrderTabs';

  import {
    getEntryTotalAmount,
    getEntryTotalPrice,
  } from '../js/accounting.js';

  export default {
    name: 'SalesOrderForm',
    components: {
      SalesOrderAppendProductForm,
      MyAddressForm,
      MTAVAT,
      SupplierSelect,
      PayPlanForm,
      SalesOrderTabs
    },
    computed: {
      //总数量
      totalAmount: function () {
        let total = 0;
        this.form.entries.forEach(element => {
          let num = parseFloat(getEntryTotalAmount(element));
          if (num != null && (!Number.isNaN(num))) {
            total += num;
          }
        });
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
    },
    methods: {
      appendProduct() {
        this.salesProductAppendVisible = true;
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
        const result = await this.$http.post(url, this.form);
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

        const form = this.$refs.form;
        const addressForm = this.$refs.addressComp.$refs.address;
        // 使用Promise.all 并行去校验结果
        let res = await Promise.all([form, addressForm].map(this.getFormPromise));

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
          address: {},
          entries: [],
          machiningTypes: 'LABOR_AND_MATERIAL',
          payPlan: {},
          cooperator: {
            id: '',
            name: '',
            contactPhone: '',
            contactPerson: ''
          },
          planLeader: {
            id: this.$store.getters.currentUser.id,
            name: this.$store.getters.currentUser.username
          },
          productionLeader: {
            id: this.$store.getters.currentUser.id,
            name: this.$store.getters.currentUser.username
          },
          approvers: [{
            id: this.$store.getters.currentUser.id,
            name: this.$store.getters.currentUser.username
          }],
          purchasingLeader: {
            id: this.$store.getters.currentUser.id,
            name: this.$store.getters.currentUser.username
          },
        }
      }
    },
    created() {

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
