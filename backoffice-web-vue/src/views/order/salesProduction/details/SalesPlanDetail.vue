<template>
  <div class="animated fadeIn content">
    <el-card>
      <div class="sales-plan-triangle_box">
        <div class="sales-plan-triangle" :style="getTriangleColor">
          <h6 class="sales-plan-triangle_text">{{getEnum('SalesProductionAuditStatus', formData.auditState)}}</h6>
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
            <h6>销售单号：{{formData.code}}</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <el-form ref="form" :inline="true" :model="formData" hide-required-asterisk>
        <sales-order-detail-form :form="formData" :modifyType="modifyType" />
      </el-form>
      <div style="margin-top: 10px">
        <sales-production-tabs :isCreate="false" :form="formData" />
      </div>
      <div class="sales-border-container" style="margin-top: 10px" v-if="formData.auditState=='AUDITED_FAILED'">
        <el-row type="flex" justify="start" class="basic-form-row">
          <h5 style="font-weight: bold">拒绝原因</h5>
        </el-row>
        <el-row class="basic-form-row" type="flex" justify="center">
          <el-col :span="22">
            <h6 class="reject_reason">{{formData.msg}}</h6>
          </el-col>
        </el-row>
      </div>
      <sales-plan-detail-btn-group :state="formData.auditState" @onReturn="onReturn" @onSave="onSave(false)"
        @onSubmit="onSave(true)" />
    </el-card>
    <el-dialog :visible.sync="refuseVisible" width="40%" :close-on-click-modal="false">
      <refuse-dialog v-if="refuseVisible" @getRefuseMsg="getRefuseMsg" />
    </el-dialog>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';

  const {
    mapGetters,
    mapActions,
    mapMutations
  } = createNamespacedHelpers(
    'SalesProductionOrdersModule'
  );

  import {
    accMul
  } from '@/common/js/number';
  import SalesProductionTabs from '../components/SalesProductionTabs';
  import RefuseDialog from '../components/RefuseDialog';
  import SalesOrderDetailForm from '../form/SalesOrderDetailForm';
  import SalesPlanDetailBtnGroup from '../components/SalesPlanDetailBtnGroup';

  export default {
    name: 'SalesPlanDetail',
    props: ['id'],
    components: {
      SalesOrderDetailForm,
      RefuseDialog,
      SalesProductionTabs,
      SalesPlanDetailBtnGroup
    },
    computed: {
      ...mapGetters({
        formData: 'formData'
      }),
      getTriangleColor: function () {
        switch (this.formData.auditState) {
          case 'AUDITING':
            return 'border-right: 70px solid #114EE8;';
          case 'PASSED':
            return 'border-right: 70px solid #4DE811;';
          case 'AUDITED_FAILED':
            return 'border-right: 70px solid #D91A17;';
          case 'NONE':
            return 'border-right: 70px solid #BBBBBB;';
          default:
            return 'border-right: 70px solid #BBBBBB;';
        }
      },
      modifyType: function () {
        if (this.formData.auditState == 'NONE' || this.formData.auditState == 'AUDITED_FAILED') {
          return true;
        } else {
          return false;
        }
      }
    },
    methods: {
      async getDetails() {
        const url = this.apis().getSalesProductionOrderDetails(this.id);
        const result = await this.$http.get(url);
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        this.$store.state.SalesProductionOrdersModule.formData = Object.assign({}, result.data);
      },
      onReturn() {

      },
      async onSave(submitAudit) {
        const url = this.apis().salesPlanSave(submitAudit);
        const result = await this.$http.post(url, this.formData);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        if (result.code == '0') {
          this.$message.error(result.msg);
          return;
        } else if (result.code == '1') {
          this.$message.success('更新成功');
          this.$router.go(0);
        }
      },
      onReturnPage() {
        this.$router.push({
          name: '销售计划'
        })
      },
      onRefuse() {
        this.refuseVisible = true;
      },
      getRefuseMsg(msg) {
        this.refuseVisible = false;
        this.$message('-----------拒绝销售计划' + msg + '----------------------');
      },
      onPass() {
        this.$confirm('请问是否通过此销售计划', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this.$message('-----------通过销售计划----------------------');
        });
      },
      onClose() {
        this.$message('-----------关闭----------------------');
      },
      validate(callback) {
        this.$refs.form.validate(callback);
      }
    },
    data() {
      return {
        refuseVisible: false,
        originalData: '',
        machiningTypes: this.$store.state.EnumsModule.cooperationModes,
      }
    },
    created() {
      this.getDetails();
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
    color: white;
    font-size: 12px;
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

  .reject_reason {
    color: #606266;
    padding-bottom: 10px;
  }

</style>
