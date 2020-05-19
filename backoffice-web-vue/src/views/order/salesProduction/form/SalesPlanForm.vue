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
              <el-form-item label="计划名称">
                <el-input v-model="form.name" placeholder="请输入"></el-input>
              </el-form-item>
            </el-col>
            <el-col :span="10">
              <el-form-item label="预计销售时间" class="form-date-item" label-width="120">
                <el-date-picker v-model="form.date" type="daterange" range-separator="~" start-placeholder="开始日期"
                  end-placeholder="结束日期">
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
              <MTAVAT :machiningTypes.sync="form.machiningTypes" :needVoice.sync="form.needVoice"
                :tax.sync="form.tax" />
            </el-col>
          </el-row>
          <my-address-form :vAddress.sync="form.address" />
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
                <el-select v-model="form.productionCadre">
                  <el-option label="张三" value="张三"></el-option>
                  <el-option label="李四" value="李四"></el-option>
                </el-select>
              </el-form-item>
            </el-col>
            <el-col :span="2">
              <el-form-item label="" label-width="5px">
                <el-checkbox v-model="form.noCheck">无需审核</el-checkbox>
              </el-form-item>
            </el-col>
            <el-col :span="2">
              <el-form-item label="" label-width="5px">
                <el-button @click="appendProductionCadre">+ 添加审批人</el-button>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row type="flex" align="start" :gutter="10" :key="index" v-for="(item, index) in form.productionCharge" v-if="index % 6 == 0">
            <template  v-for="(val,inner_index) in form.productionCharge.slice(index, index+6)">
              <el-col :span="4" :key="inner_index">
                <el-form-item label="审批人" label-width="85px">
                  <el-select v-model="form.productionCadre[index]" clearable placeholder="请选择">
                    <el-option
                      v-for="item in options"
                      :key="item.value"
                      :label="item.label"
                      :value="item.value">
                    </el-option>
                  </el-select>
                </el-form-item>
              </el-col>
            </template>
          </el-row>
        </div>
      </el-form>
      <sales-plan-products-table :form="form" @appendProduct="appendProduct"/>
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
  import MTAVAT from '@/components/custom/order-form/MTAVAT';
  import MyAddressForm from '@/components/custom/order-form/MyAddressForm';
  import SalesPlanProductsTable from '../components/SalesPlanProductsTable';
  import SalesPlanAppendProduct from '../components/SalesPlanAppendProduct';

  export default {
    name: 'SalesPlanForm',
    components: {
      SalesPlanAppendProduct,
      MTAVAT,
      MyAddressForm,
      SalesPlanProductsTable
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
      appendProductionCadre () {
        this.form.productionCharge.push('');
      }
    },
    data () {
      return {
        salesProductAppendVisible: false,
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
          code: '',
          name: '',
          date: '',
          machiningTypes: 'LABOR_AND_MATERIAL',
          needVoice: false,
          tax: 0.03,
          address: {

          },
          productionCadre: [''],
          productionCharge: [{
            label: '张三',
            name: '张三',
            value: '张三'
          }],
          noCheck: true,
        }

      };
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

  .material-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    width: 120px;
    height: 40px;
  }
</style>
