<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-form ref="form" :model="form" label-width="100px" label-position="left">
        <el-row>
          <el-col :span="4">
            <div class="sales-plan-form-title">
              <h6>录入销售计划</h6>
            </div>
          </el-col>
        </el-row>
        <div class="pt-2"></div>
        <div style="padding-left:10px">
          <el-row type="flex">
            <el-col :span="6">
              <el-form-item label="计划单号">
                <el-input v-model="form.code" placeholder="系统自动生成" :disabled="true"></el-input>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row type="flex" :gutter="20">
            <!-- <el-col :span="8">
              <el-form-item label="计划名称" prop="name" :rules="{required: true, message: '不能为空', trigger: 'blur'}">
                <el-input v-model="form.name" placeholder="请输入"></el-input>
              </el-form-item>
            </el-col> -->
            <el-col :span="24">
              <el-form-item label="预计销售时间" class="form-date-item" label-width="120px">
                <el-date-picker v-model="form.salesDateRange" type="daterange" range-separator="~" unlink-panels
                  @change="onDateRangeChange" start-placeholder="开始日期" end-placeholder="结束日期">
                </el-date-picker>
              </el-form-item>
            </el-col>
          </el-row>
        </div>
        <el-row>
          <el-col :span="4">
            <div style="padding-left: 10px">
              <h6>生产要求</h6>
            </div>
          </el-col>
        </el-row>
        <div class="form-block-content">
          <el-row type="flex">
            <el-col :span="18">
              <MTAVAT :machiningTypes.sync="form.cooperationMode" :needVoice.sync="form.invoiceNeeded"
                :tax.sync="form.invoiceTaxPoint" />
            </el-col>
          </el-row>
        </div>
        <el-divider />
        <el-row>
          <el-col :span="4">
            <div style="padding-left: 10px">
              <h6>人员设置</h6>
            </div>
          </el-col>
        </el-row>
        <div class="form-block-content">
          <el-row type="flex" align="center" :gutter="10">
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
          </el-row>
        </div>
      </el-form>
      <sales-production-tabs :form="form" @appendProduct="appendProduct" />
      <el-row style="margin-top: 20px" type="flex" justify="center" align="middle" :gutter="50">
        <el-col :span="5">
          <el-button class="material-btn" @click="onSave(false)">保存</el-button>
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
  import MTAVAT from '@/components/custom/order-form/MTAVAT';
  import SalesProductionTabs from '../components/SalesProductionTabs';
  import SalesPlanAppendProductForm from './SalesPlanAppendProductForm';
  import PersonnelSelection from '@/components/custom/PersonnelSelection';

  export default {
    name: 'SalesPlanForm',
    props: ['id'],
    components: {
      SalesPlanAppendProductForm,
      MTAVAT,
      SalesProductionTabs,
      PersonnelSelection
    },
    computed: {
      //根据订单类型，加工类型判断是否需要物料清单等
      needMaterialsSpec: function () {
        //销售计划
        switch (this.form.cooperationMode) {
          case 'LABOR_AND_MATERIAL':
            return false;
          case 'LIGHT_PROCESSING':
            return true;
          default:
            return false;
        }
      }
    },
    methods: {
      onDateRangeChange(val) {
        this.form.salesDateStart = val[0];
        this.form.salesDateEnd = val[1];
      },
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
      async validateForms() {
        if (this.form.entries.length < 1) {
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
          this.$message.success('销售计划创建成功，编号： ' + result.data);
          this.$router.go(-1);
        }
      },
    },
    data() {
      return {
        salesProductAppendVisible: false,
        updateEntry: null,
        form: {
          code: '',
          name: '',
          "type": "SALES_PLAN",
          salesDateRange: [],
          salesDateStart: '',
          salesDateEnd: '',
          cooperationMode: 'LABOR_AND_MATERIAL',
          invoiceNeeded: false,
          invoiceTaxPoint: 0.03,
          entries: [],
          productionLeader: null,
          approvers: [null],
          auditNeeded: true,
        }

      };
    },
    created() {
      if (this.$route.params.order != null) {
        Object.assign(this.form, this.$route.params.order);
        this.form.salesDateRange = [this.form.salesDateStart, this.form.salesDateEnd];
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

  .material-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    width: 120px;
    height: 40px;
  }

</style>
