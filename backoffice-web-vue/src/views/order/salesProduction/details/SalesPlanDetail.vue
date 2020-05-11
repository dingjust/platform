<template>
  <div class="animated fadeIn content">
    <el-card>
      <div class="sales-plan-triangle_box">
        <div class="sales-plan-triangle" :style="getTriangleColor">
          <h6 class="sales-plan-triangle_text">未审核</h6>
        </div>
      </div>
      <el-row type="flex" justify="space-between">
        <el-col :span="6">
          <div class="sales-plan-form-title">
            <h6>销售计划详情</h6>
          </div>
        </el-col>
        <el-col :span="16">
          <div>
            <h6>销售单号：{{code}}</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <el-form ref="form" :inline="true" :model="form" hide-required-asterisk>
        <sales-order-detail-form :form="form" :modifyType="modifyType"/>
      </el-form>
      <div style="margin-top: 10px">
        <sales-plan-products-table :isCreate="false" :form="form"/>
      </div>
      <div class="sales-border-container" style="margin-top: 10px"  v-if="form.status == 'FAILED'">
        <el-row type="flex" justify="start" class="basic-form-row">
          <h5 style="font-weight: bold">拒绝原因</h5>
        </el-row>
        <el-row class="basic-form-row" type="flex" justify="center">
          <el-col :span="22">
            <h6>{{form.msg}}</h6>
          </el-col>
        </el-row>
      </div>
      <el-row type="flex" justify="space-around" style="margin-top: 20px" :gutter="50" v-if="form.status == 'UNAPPROVED' || form.status == 'FAILED'">
        <el-col :span="3" v-if="modifyType">
          <el-button class="material-btn" @click="onReturn">返回</el-button>
        </el-col>
        <el-col :span="3" v-if="modifyType">
          <el-button class="material-btn" @click="onSave">保存</el-button>
        </el-col>
        <el-col :span="3" v-if="!modifyType">
          <el-button class="material-btn" @click="onModify">修改</el-button>
        </el-col>
        <el-col :span="3">
          <el-button class="material-btn" @click="onSubmit">提交审核</el-button>
        </el-col>
        <el-col :span="3" v-if="!modifyType">
          <el-button class="material-btn" @click="onReturnPage">返回</el-button>
        </el-col>
      </el-row>
<!--      <el-row type="flex" justify="space-around" style="margin-top: 20px" :gutter="50" v-if="form.status == 'APPROVED'">-->
<!--        <el-col :span="3">-->
<!--          <el-button class="material-btn" @click="onRefuse">拒绝</el-button>-->
<!--        </el-col>-->
<!--        <el-col :span="3">-->
<!--          <el-button class="material-btn" @click="onPass">通过</el-button>-->
<!--        </el-col>-->
<!--      </el-row>-->
      <el-row type="flex" justify="space-around" style="margin-top: 20px" :gutter="50" v-if="form.status == 'APPROVED'">
        <el-col :span="3">
          <el-button class="material-btn" @click="onRefuse">返回</el-button>
        </el-col>
        <el-col :span="3">
          <el-button class="material-btn" @click="onPass">撤回</el-button>
        </el-col>
      </el-row>
      <el-row type="flex" justify="space-around" style="margin-top: 20px" :gutter="50" v-if="form.status == 'COMPLETE'">
        <el-col :span="3">
          <el-button class="material-btn" @click="onClose">关闭</el-button>
        </el-col>
      </el-row>
    </el-card>
    <el-dialog :visible.sync="refuseVisible" width="40%"  :close-on-click-modal="false">
      <refuse-dialog v-if="refuseVisible" @getRefuseMsg="getRefuseMsg"/>
    </el-dialog>
  </div>
</template>

<script>
  import {
    accMul
  } from '@/common/js/number';
  import SalesPlanProductsTable from '../components/SalesPlanProductsTable';
  import RefuseDialog from '../components/RefuseDialog';
  import SalesOrderDetailForm from '../form/SalesOrderDetailForm';
  export default {
    name: 'SalesPlanDetail',
    props: ['code'],
    components: {
      SalesOrderDetailForm,
      RefuseDialog,
      SalesPlanProductsTable
    },
    computed: {
      getTriangleColor: function () {
        switch (this.form.status) {
          case 'APPROVED' :
            return 'border-right: 70px solid #114EE8;';
          case 'COMPLETE' :
            return 'border-right: 70px solid #4DE811;';
          case 'FAILED':
            return 'border-right: 70px solid #D91A17;';
          case 'UNAPPROVED':
            return 'border-right: 70px solid #BBBBBB;';
          default :
            return 'border-right: 70px solid #BBBBBB;';
        }
      }
    },
    methods: {
      onModify () {
        // 复制一份原本数据
        this.originalData = Object.assign({}, this.form);
        this.modifyType = true;
      },
      onReturn () {
        // 返回取消数据更改
        this.form = this.originalData;
        this.modifyType = false;
      },
      onSave () {
        this.$refs.form.validate((valid) => {
          if (valid) {
            this.$message.success('修改成功');
            this.originalData = '';
            this.modifyType = false;
          } else {
            this.$message.error('请完善填写信息');
            return false;
          }
        });
      },
      onSubmit () {
        this.$message('-----------提交审核----------------------');
      },
      onReturnPage () {
        this.$router.push({
          name: '销售计划'
        })
      },
      onRefuse () {
        this.refuseVisible = true;
      },
      getRefuseMsg (msg) {
        this.refuseVisible = false;
        this.$message('-----------拒绝销售计划' + msg + '----------------------');
      },
      onPass () {
        this.$confirm('请问是否通过此销售计划', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this.$message('-----------通过销售计划----------------------');
        });
      },
      onClose () {
        this.$message('-----------关闭----------------------');
      },
      showFloatPercentNum (val) {
        var reg = /\.$/;
        if (val && !reg.test(val)) {
          return accMul(val, 100);
        } else {
          return val;
        }
      },
      onBlur (row, attribute) {
        var reg = /\.$/;
        if (reg.test(row[attribute])) {
          this.$set(row, attribute, parseFloat(row[attribute] + '0') / 100.0);
        }
      },
      onTaxInput (val, row) {
        var reg = /\.$/;
        if (!reg.test(val)) {
          row.profitMargin = (val / 100.0).toFixed(3);
        } else {
          row.profitMargin = val;
        }
      },
      validatePhone (rule, value, callback) {
        const reg = /^[1][3,4,5,6,7,8,9][0-9]{9}$/;
        if (value === '') {
          callback(new Error('请输入手机号码'));
        } else if (!reg.test(value)) {
          callback(new Error('请输入合法手机号码'));
        } else {
          callback();
        }
      },
      validate (callback) {
        this.$refs.form.validate(callback);
      }
    },
    data () {
      return {
        refuseVisible: false,
        originalData: '',
        modifyType: false,
        machiningTypes: this.$store.state.EnumsModule.cooperationModes,
        options: [
          {
            label: '马化腾',
            value: 'MMMM'
          },
          {
            label: '周鸿伟',
            value: 'ZZZZ'
          },
          {
            label: '马云',
            value: 'YYYY'
          },
          {
            label: '伟腾云',
            value: 'WWWW'
          }
        ],
        form: {
          code: 'CO0000000001',
          foundPerson: '宁波衣加衣宁波衣加衣',
          contactPerson: '宁波衣加衣宁波衣加衣',
          contactPhone: '13888888888',
          machiningTypes: 'LABOR_AND_MATERIAL',
          invoice: true,
          quantity: 5000,
          total: 1222200202,
          budget: 12222,
          profit: 122222,
          profitMargin: 0.6,
          approvalBy: '马化腾',
          orderOwner: '周鸿伟',
          productionBy: '马云',
          procurementBy: '伟腾云',
          status: 'UNAPPROVED',
          msg: 'zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz'
        }
      }
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

  .sales-plan-box {
    display:table;
    margin:0 auto;
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
    display:table-cell;
    z-index: 100;
  }

  .sales-plan-triangle_box {
    margin-top: 1px;
    position: absolute;
    right: 0;
    top: 0;
  }

  .sales-plan-triangle{
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

  .sales-border-container{
    border: 1px solid #DCDFE6;
    border-radius: 5px;
    padding-top:10px;
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

  /deep/ .el-form-item--mini.el-form-item, .el-form-item--small.el-form-item {
    margin-bottom: 5px;
  }
</style>
