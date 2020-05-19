<template>
  <div>
    <div class="sales-plan-box">
      <div class="sales-border-container sales-plan-one">
        <el-row type="flex" justify="start" class="basic-form-row">
          <h6>订单基本信息</h6>
        </el-row>
        <el-row type="flex" justify="start" align="middle" class="basic-form-row">
          <el-col :span="8">
            <el-row type="flex" align="middle">
              <el-form-item label="创建人：">
                <h6 class="sales-plan-h6">{{form.foundPerson}}</h6>
              </el-form-item>
            </el-row>
          </el-col>
          <el-col :span="8">
            <el-row type="flex" align="middle">
              <el-form-item label="联系人：">
                <h6 class="sales-plan-h6">{{form.contactPerson}}</h6>
              </el-form-item>
            </el-row>
          </el-col>
          <el-col :span="8">
            <el-row type="flex" align="middle">
              <el-form-item label="联系方式：">
                <h6 class="sales-plan-h6">{{form.contactPhone}}</h6>
              </el-form-item>
            </el-row>
          </el-col>
        </el-row>
        <el-row type="flex" justify="start" class="basic-form-row">
          <el-col :span="8">
            <el-row type="flex" align="middle">
              <el-form-item label="合作方式：" :rules="[{ required: true, message: '请选择合作方式', trigger: 'change'}]"
                prop="machiningTypes">
                <h6 v-show="!modifyType" class="sales-plan-h6">{{getEnum('cooperationModes', form.cooperationMode)}}
                </h6>
                <el-row v-show="modifyType">
                  <template v-for="value in machiningTypes">
                    <el-radio class="sales-radio" :key="value.code" v-model="form.cooperationMode" :label="value.code">
                      {{value.name}}</el-radio>
                  </template>
                </el-row>
              </el-form-item>
            </el-row>
          </el-col>
          <el-col :span="10">
            <el-row type="flex" align="middle">
              <el-form-item label="是否开发票：" :rules="[{ required: true, message: '请选择是否开发票', trigger: 'change'}]"
                prop="invoice">
                <h6 v-show="!modifyType" class="sales-plan-h6">{{form.invoice ? '开发票' : '不开发票'}}</h6>
                <el-radio v-show="modifyType" class="sales-radio" v-model="form.invoice" :label="false">不开发票</el-radio>
                <el-radio v-show="modifyType" class="sales-radio" v-model="form.invoice" :label="true">开发票</el-radio>
              </el-form-item>
            </el-row>
          </el-col>
        </el-row>
        <el-row type="flex" justify="start" class="basic-form-row">
          <el-col :span="8">
            <el-row type="flex" align="middle">
              <el-form-item label="订单数量：">
                <h6 class="sales-plan-h6">{{form.quantity}}</h6>
              </el-form-item>
            </el-row>
          </el-col>
          <el-col :span="8">
            <el-row type="flex" align="middle">
              <el-form-item label="订单总金额：">
                <h6 class="sales-plan-h6">{{form.total}}元</h6>
              </el-form-item>
            </el-row>
          </el-col>
        </el-row>
        <el-row type="flex" justify="start" class="basic-form-row">
          <el-col :span="8">
            <el-row type="flex" align="middle">
              <el-form-item label="预计总成本：">
                <h6 class="sales-plan-h6">{{form.budget}}元</h6>
              </el-form-item>
            </el-row>
          </el-col>
          <el-col :span="8">
            <el-row type="flex" align="middle">
              <el-form-item label="预计利润：">
                <h6 class="sales-plan-h6">{{form.profit}}元</h6>
              </el-form-item>
            </el-row>
          </el-col>
          <el-col :span="8">
            <el-row type="flex" align="middle">
              <el-form-item label="预计利润率：">
                <h6 class="sales-plan-h6">{{form.profitMargin * 100}}%</h6>
              </el-form-item>
            </el-row>
          </el-col>
        </el-row>
      </div>
      <div class="sales-plan-three"></div>
      <div class="sales-border-container sales-plan-two">
        <el-row type="flex" justify="start" class="basic-form-row">
          <h6>人员设置</h6>
        </el-row>
        <el-row type="flex" justify="start" class="basic-form-row">
          <el-row type="flex" align="middle">
            <el-form-item label="审批负责人：" :rules="[{ required: true, message: '请选择审批负责人', trigger: 'change'}]"
              prop="approvalBy">
              <h6 v-show="!modifyType" class="sales-plan-h6">{{form.approvalBy}}</h6>
              <el-select v-model="form.approvalBy" placeholder="请选择" v-show="modifyType" value-key="id">
                <el-option v-for="item in options" :key="item.value.id" :label="item.label" :value="item.value">
                </el-option>
              </el-select>
            </el-form-item>
          </el-row>
        </el-row>
        <el-row type="flex" justify="start" class="basic-form-row">
          <el-row type="flex" align="middle">
            <el-form-item label="订单负责人：" :rules="[{ required: true, message: '请选择订单负责人', trigger: 'change'}]"
              prop="orderOwner">
              <h6 v-show="!modifyType" class="sales-plan-h6">{{form.orderOwner}}</h6>
              <el-select v-model="form.orderOwner" placeholder="请选择" v-show="modifyType" value-key="id">
                <el-option v-for="item in options" :key="item.value.id" :label="item.label" :value="item.value">
                </el-option>
              </el-select>
            </el-form-item>
          </el-row>
        </el-row>
        <el-row type="flex" justify="start" class="basic-form-row">
          <el-row type="flex" align="middle">
            <el-form-item label="生产负责人：" :rules="[{ required: true, message: '请选择生产负责人', trigger: 'change'}]"
              prop="productionBy">
              <h6 v-show="!modifyType" class="sales-plan-h6">{{form.productionBy}}</h6>
              <el-select v-model="form.productionBy" placeholder="请选择" v-show="modifyType" value-key="id">
                <el-option v-for="item in options" :key="item.value.id" :label="item.label" :value="item.value">
                </el-option>
              </el-select>
            </el-form-item>
          </el-row>
        </el-row>
        <!-- <el-row type="flex" justify="start" class="basic-form-row">
          <el-row type="flex" align="middle">
            <el-form-item label="采购负责人：" :rules="[{ required: true, message: '请选择采购负责人', trigger: 'change'}]"
              prop="procurementBy">
              <h6 v-show="!modifyType" class="sales-plan-h6">{{form.procurementBy}}</h6>
              <el-select v-model="form.procurementBy" placeholder="请选择" v-show="modifyType">
                <el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value">
                </el-option>
              </el-select>
            </el-form-item>
          </el-row>
        </el-row> -->
      </div>
    </div>
  </div>
</template>

<script>
  import {
    accMul
  } from '@/common/js/number';
  export default {
    name: 'SalesOrderDetailForm',
    props: {
      form: {
        type: Object,
      },
      modifyType: {
        type: Boolean,
        defalut: false
      }
    },
    methods: {
      showFloatPercentNum(val) {
        var reg = /\.$/;
        if (val && !reg.test(val)) {
          return accMul(val, 100);
        } else {
          return val;
        }
      },
      onBlur(row, attribute) {
        var reg = /\.$/;
        if (reg.test(row[attribute])) {
          this.$set(row, attribute, parseFloat(row[attribute] + '0') / 100.0);
        }
      },
      onTaxInput(val, row) {
        var reg = /\.$/;
        if (!reg.test(val)) {
          row.profitMargin = (val / 100.0).toFixed(3);
        } else {
          row.profitMargin = val;
        }
      },
      validatePhone(rule, value, callback) {
        const reg = /^[1][3,4,5,6,7,8,9][0-9]{9}$/;
        if (value === '') {
          callback(new Error('请输入手机号码'));
        } else if (!reg.test(value)) {
          callback(new Error('请输入合法手机号码'));
        } else {
          callback();
        }
      },
      validate(callback) {
        this.$refs.form.validate(callback);
      }
    },
    data() {
      return {
        machiningTypes: this.$store.state.EnumsModule.cooperationModes,
        options: [{
          label: this.$store.getters.currentUser.username,
          value: {
            id: this.$store.getters.currentUser.id,
            name: this.$store.getters.currentUser.username
          }
        }, ]
      }
    }
  }

</script>

<style scoped>
  .sales-plan-box {
    display: table;
    margin: 0 auto;
    width: 100%;
  }

  .sales-plan-one {
    width: 75%;
    display: table-cell;
  }

  .sales-plan-three {
    width: 1%;
    display: table-cell;
  }

  .sales-plan-two {
    width: 24%;
    display: table-cell;
    z-index: 100;
  }

  .sales-plan-triangle_box {
    margin-top: 1px;
    position: absolute;
    right: 0;
    top: 0;
  }

  .sales-plan-triangle {
    width: 0;
    height: 0;
    border-right: 70px solid white;
    border-bottom: 70px solid transparent;
    z-index: 0;
  }

  .sales-plan-triangle_text {
    width: 80px;
    padding-top: 10px;
    padding-left: 30px;
    transform: rotateZ(45deg);
  }

  .sales-border-container {
    border: 1px solid #DCDFE6;
    border-radius: 5px;
    padding-top: 10px;
  }

  .basic-form-row {
    padding-left: 10px;
  }

  .material-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    width: 90px;
    height: 35px;
  }

  .sales-plan-h6 {
    padding-top: 8px;
  }

  /deep/ .el-input__inner {
    height: 24px;
    line-height: 24px;
    border-radius: 2px;
    padding: 0px;
  }

  .sales-radio {
    margin-top: 8px
  }

  .over-tabs {
    position: absolute;
    z-index: 100;
    right: 30px;
    margin-top: 2px;
  }

  /deep/ .el-form-item--mini.el-form-item,
  .el-form-item--small.el-form-item {
    margin-bottom: 5px;
  }

</style>
