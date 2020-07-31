<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row type="flex" justify="space-between">
        <el-col :span="6">
          <div class="node-list-title">
            <h6>{{isCreate ? '创建节点方案' : '编辑节点方案'}}</h6>
          </div>
        </el-col>
        <el-col :span="2">
          <el-button class="progress-btn" @click="onSubmit">确定</el-button>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <progress-plan-form-info ref="infoForm" :formData="formData" :isCreate="isCreate"/>
    </el-card>
  </div>
</template>

<script>
  import ProgressPlanFormInfo from './ProgressPlanFormInfo';
  export default {
    name: 'ProgressPlanForm',
    components: {ProgressPlanFormInfo},
    methods: {
      onSubmit () {
        this.$refs['infoForm'].$refs['form'].validate(valid => {
          if (valid) {
            this._onSubmit();
          } else {
            this.$message.error('请完善表单信息');
            return false;
          }
        });
      },
      async _onSubmit () {
        let row = {};
        let productionProgresses = this.formData.productionProgresses.map(val => {
          row = {
            medias: val.medias,
            progressPhase: val.progressPhase,
            quantity: val.quantity,
            sequence: val.sequence,
            warningDays: val.warningDays,
            completeAmount: val.completeAmount,
            productionProgressOrders: val.productionProgressOrders
          }
          return row;
        })
        const data = {
          id: this.formData.id ? this.formData.id : null,
          name: this.formData.name,
          remarks: this.formData.remarks,
          productionProgresses: productionProgresses
        }
        const url = this.apis().createProgressPlan();
        const result = await this.$http.post(url, data);
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        this.$message.success(this.formData.id ? '添加节点成功' : '编辑节点成功');
        await this.$router.push('/account/setting/progress-plan');
      }
    },
    data () {
      return {
        isCreate: true,
        formData: {
          name: '',
          remarks: '',
          productionProgresses: []
        }
      }
    },
    created () {
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

  .progress-basic-row {
    padding-left: 20px;
  }

  .progress-container {
    border: 1px solid #DCDFE6;
    border-radius: 2px;
    width: 100%;
  }

  .progress-btn {
    background-color: #FFD60C;
    border-color: #FFD60C;
  }

  /deep/ .el-form-item__error {
    width: 100px;
  }
</style>
