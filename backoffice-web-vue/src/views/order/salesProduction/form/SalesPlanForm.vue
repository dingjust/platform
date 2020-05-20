<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-form ref="form" :model="form" label-width="80px">
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
            <el-col :span="8">
              <el-form-item label="计划名称" prop="name" :rules="{required: true, message: '不能为空', trigger: 'blur'}">
                <el-input v-model="form.name" placeholder="请输入"></el-input>
              </el-form-item>
            </el-col>
            <el-col :span="10">
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
              <MTAVAT :machiningTypes.sync="form.cooperationMode" :needVoice.sync="form.needVoice"
                :tax.sync="form.tax" />
            </el-col>
          </el-row>
          <my-address-form :vAddress.sync="form.address" ref="addressComp" />
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
            <el-col :span="5">
              <el-form-item label="审批人" label-width="85px" v-if="form.auditNeeded">
                <template v-for="item in form.approvers">
                  <el-input :key="item.id" v-model="item.name" :disabled="true">
                  </el-input>
                </template>
              </el-form-item>
            </el-col>
            <!-- <el-col :span="2">
              <el-form-item label="" label-width="5px">
                <el-checkbox v-model="form.auditNeeded">无需审核</el-checkbox>
              </el-form-item>
            </el-col>
            <el-col :span="2">
              <el-form-item label="" label-width="5px">
                <el-button @click="appendProductionCadre">+ 添加审批人</el-button>
              </el-form-item>
            </el-col> -->
          </el-row>
          <!-- <el-row type="flex" align="start" :gutter="10" :key="index" v-for="(item, index) in form.productionCharge"
            v-if="index % 6 == 0">
            <template v-for="(val,inner_index) in form.productionCharge.slice(index, index+6)">
              <el-col :span="4" :key="inner_index">
                <el-form-item label="审批人" label-width="85px">
                  <el-select v-model="form.productionCadre[index]" clearable placeholder="请选择">
                    <el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value">
                    </el-option>
                  </el-select>
                </el-form-item>
              </el-col>
            </template>
          </el-row> -->
        </div>
      </el-form>
      <sales-production-tabs :form="form" @appendProduct="appendProduct" />
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
        :defaultAddress="form.address" :isUpdate="false" :productionLeader="form.productionLeader" />
    </el-dialog>
  </div>
</template>

<script>
  import MTAVAT from '@/components/custom/order-form/MTAVAT';
  import MyAddressForm from '@/components/custom/order-form/MyAddressForm';
  import SalesProductionTabs from '../components/SalesProductionTabs';
  import SalesPlanAppendProductForm from './SalesPlanAppendProductForm';

  export default {
    name: 'SalesPlanForm',
    components: {
      SalesPlanAppendProductForm,
      MTAVAT,
      MyAddressForm,
      SalesProductionTabs
    },
    computed: {

    },
    methods: {
      onDateRangeChange(val) {
        this.form.salesDateStart = val[0];
        this.form.salesDateEnd = val[1];
      },
      appendProduct() {
        this.salesProductAppendVisible = true;
      },
      onAppendProduct(products) {
        products.forEach(element => {
          let index = this.form.entries.findIndex(entry => entry.product.code == element.product.code);
          if (index == -1) {
            this.form.entries.push(element);
          }
        });
        this.salesProductAppendVisible = false;
      },
      async validateForms() {
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
          this.$message.success('销售计划创建成功，编号： ' + result.code);
          this.$router.go(-1);
        }
      },
      appendProductionCadre() {
        this.form.productionCharge.push({
          label: '张三',
          name: '张三',
          value: '张三'
        });
      }
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
          needVoice: false,
          tax: 0.03,
          address: {

          },
          entries: [],
          productionLeader: {
            id: this.$store.getters.currentUser.id,
            name: this.$store.getters.currentUser.username
          },
          approvers: [{
            id: this.$store.getters.currentUser.id,
            name: this.$store.getters.currentUser.username
          }],
          auditNeeded: true,
        }

      };
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

  .material-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    width: 120px;
    height: 40px;
  }

</style>
