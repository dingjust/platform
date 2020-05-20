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
                <h6 class="sales-plan-h6">{{form.creator!=null?form.creator.name:''}}</h6>
              </el-form-item>
            </el-row>
          </el-col>
        </el-row>
        <MTAVAT v-if="modifyType" :machiningTypes.sync="form.cooperationModes" :needVoice.sync="form.invoiceNeeded"
          :tax.sync="form.invoiceTaxPoint" :layoutScale="mtavatLayoutScale" class="basic-form-row" />
        <el-row type="flex" justify="start" class="basic-form-row" v-if="!modifyType">
          <el-col :span="8">
            <el-row type="flex" align="middle">
              <el-form-item label="合作方式：">
                <h6 class="sales-plan-h6">{{getEnum('cooperationModes', form.cooperationMode)}}
                </h6>
              </el-form-item>
            </el-row>
          </el-col>
          <el-col :span="10">
            <el-row type="flex" align="middle">
              <el-form-item label="是否开发票：">
                <h6 class="sales-plan-h6">{{form.invoice ? '开发票' : '不开发票'}}</h6>
              </el-form-item>
            </el-row>
          </el-col>
          <el-col :span="10">
            <el-row type="flex" align="middle">
              <el-form-item label="税点">
                <h6 class="sales-plan-h6">
                  {{form.invoiceTaxPoint!=null?(parseFloat(form.invoiceTaxPoint)*100).toFixed(2):''}}%</h6>
              </el-form-item>
            </el-row>
          </el-col>
        </el-row>
        <el-row type="flex" justify="start" class="basic-form-row">
          <el-col :span="8">
            <el-row type="flex" align="middle">
              <el-form-item label="订单数量：">
                <h6 class="sales-plan-h6">{{totalAmount}}</h6>
              </el-form-item>
            </el-row>
          </el-col>
          <el-col :span="8">
            <el-row type="flex" align="middle">
              <el-form-item label="订单总金额：">
                <h6 class="sales-plan-h6">{{totalPrice}}元</h6>
              </el-form-item>
            </el-row>
          </el-col>
        </el-row>
        <el-row type="flex" justify="start" class="basic-form-row">
          <el-col :span="8">
            <el-row type="flex" align="middle">
              <el-form-item label="预计总成本：">
                <h6 class="sales-plan-h6">{{totalCost}}元</h6>
              </el-form-item>
            </el-row>
          </el-col>
          <el-col :span="8">
            <el-row type="flex" align="middle">
              <el-form-item label="预计利润：">
                <h6 class="sales-plan-h6">{{totalProfit}}元</h6>
              </el-form-item>
            </el-row>
          </el-col>
          <el-col :span="8">
            <el-row type="flex" align="middle">
              <el-form-item label="预计利润率：">
                <h6 class="sales-plan-h6">{{totalProfitPercent}}%</h6>
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
            <el-form-item label="审批负责人：">
              <h6 v-show="!modifyType" class="sales-plan-h6">
                {{(form.approvers!=null&&form.approvers[0]!=null)?form.approvers[0].name:''}}</h6>
              <el-select v-model="form.approvers[0]" placeholder="请选择" v-if="modifyType" value-key="id">
                <el-option v-for="item in options" :key="item.value.id" :label="item.label" :value="item.value">
                </el-option>
              </el-select>
            </el-form-item>
          </el-row>
        </el-row>
        <el-row type="flex" justify="start" class="basic-form-row">
          <el-row type="flex" align="middle">
            <el-form-item label="订单负责人：">
              <h6 v-show="!modifyType" class="sales-plan-h6">{{form.planLeader!=null?form.planLeader.name:''}}</h6>
              <el-select v-model="form.orderOwner" placeholder="请选择" v-if="modifyType" value-key="id">
                <el-option v-for="item in options" :key="item.value.id" :label="item.label" :value="item.value">
                </el-option>
              </el-select>
            </el-form-item>
          </el-row>
        </el-row>
        <el-row type="flex" justify="start" class="basic-form-row">
          <el-row type="flex" align="middle">
            <el-form-item label="生产负责人：">
              <h6 v-show="!modifyType" class="sales-plan-h6">
                {{form.productionLeader!=null?form.productionLeader.name:''}}</h6>
              <el-select v-model="form.productionLeader" placeholder="请选择" v-if="modifyType" value-key="id">
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

  import {
    getEntryTotalAmount,
    getEntryTotalPrice,
    getEntryTotalCost,
    getEntryProfit,
    getEntryProfitPercent
  } from '../js/accounting.js';

  import MTAVAT from '@/components/custom/order-form/MTAVAT';


  export default {
    name: 'SalesOrderDetailForm',
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
      //总成本
      totalCost: function () {
        let total = 0;
        this.form.entries.forEach(element => {
          let num = parseFloat(getEntryTotalCost(element));
          if (num != null && (!Number.isNaN(num))) {
            total += num;
          }
        });
        return total;
      },
      //总利润
      totalProfit: function () {
        let total = 0;
        this.form.entries.forEach(element => {
          let num = parseFloat(getEntryProfit(element));
          if (num != null && (!Number.isNaN(num))) {
            total += num;
          }
        });
        return total;
      },
      //利润率
      totalProfitPercent: function () {
        let profit = this.totalProfit;
        let totalPrice = this.totalPrice;
        if (profit != '' && totalPrice != '') {
          return (parseFloat(profit / totalPrice) * 100).toFixed(2);
        } else {
          return '';
        }
      },
    },
    components: {
      MTAVAT
    },
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
      validate(callback) {
        this.$refs.form.validate(callback);
      }
    },
    data() {
      return {
        machiningTypes: this.$store.state.EnumsModule.cooperationModes,
        mtavatLayoutScale: [9, 9, 6],
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
