<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row type="flex" justify="space-between">
        <el-col :span="6">
          <div class="node-list-title">
            <h6>{{isCreate ? '创建对账方案' : '编辑对账方案'}}</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <reconciliation-plan-form-info ref="infoForm" :formData="formData" :isCreate="isCreate" />
      <el-row type="flex" justify="center">
        <el-col :span="4">
          <el-button class="reconciliation-btn" @click="onSubmit">确定</el-button>
        </el-col>
      </el-row>
    </el-card>
  </div>
</template>

<script>
  import ReconciliationPlanFormInfo from './ReconciliationPlanFormInfo';
  export default {
    name: 'ReconciliationPlanForm',
    components: {
      ReconciliationPlanFormInfo
    },
    methods: {
      onSubmit() {
        this.$refs['infoForm'].$refs['form'].validate(valid => {
          if (valid) {
            this._onSubmit();
          } else {
            this.$message.error('请完善表单信息');
            return false;
          }
        });
      },
      async _onSubmit() {
        let row = {};
        let planRules = this.formData.planRules.map(val => {
          row = {
            reconciliationDayNum: val.reconciliationDayNum,
            monthType: val.monthType,
            isRange: val.isRange,
            monthlyStartDayNum: val.monthlyStartDayNum,
            monthlyEndDayNum: val.monthlyEndDayNum
          }
          return row;
        })
        const data = {
          id: this.formData.id ? this.formData.id : null,
          name: this.formData.name,
          remarks: this.formData.remarks,
          isEnable: this.formData.isEnable,
          planRules: planRules
        }
        if (this.formData.id) {
          const url = this.apis().updateReconciliationPlan(this.formData.id);
          const result = await this.$http.put(url, data);
          if (result.code === 0) {
            this.$message.error(result.msg);
            return;
          }
          this.$message.success('编辑对账方案成功');
        } else {
          const url = this.apis().createReconciliationPlan();
          const result = await this.$http.post(url, data);
          if (result.code === 0) {
            this.$message.error(result.msg);
            return;
          }
          this.$message.success('添加对账方案成功');
        }
        await this.$router.push('/account/setting/reconciliation-plan');
      }
    },
    data() {
      return {
        isCreate: true,
        formData: {
          name: '',
          remarks: '',
          isEnable: true,
          planRules: [{
            isRange: false
          }]
        }
      }
    },
    created() {
      if (this.$route.params.formData != null) {
        this.formData = this.$route.params.formData;
        this.isCreate = false;
      }
    }
  }

</script>

<style scoped>
  .node-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .reconciliation-basic-row {
    padding-left: 20px;
  }

  .reconciliation-container {
    border: 1px solid #DCDFE6;
    border-radius: 2px;
    width: 100%;
  }

  .reconciliation-btn {
    background-color: #FFD60C;
    border-color: #FFD60C;
    padding: 5px 20px;
  }

  /deep/ .el-form-item__error {
    width: 100px;
  }

</style>
