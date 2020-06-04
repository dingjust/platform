<template>
  <div>
    <el-row class="progress-row">
      <el-col :span="6">
        <el-form-item label="生产节点" prop="progressPlan">
          <el-input v-model="formData.progressPlan.name" :disabled="true"></el-input>
        </el-form-item>
      </el-col>
      <el-col :span="2">
        <el-button class="outbound-btn" @click="progressPlanVisible = !progressPlanVisible">选择</el-button>
      </el-col>
    </el-row>
    <el-row type="flex" justify="center">
      <el-col :span="22">
        <progress-factory-setting-form :formData="formData.progressPlan"/>
      </el-col>
    </el-row>
    <el-dialog :visible.sync="progressPlanVisible" width="60%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <progress-plan-select-dialog v-if="progressPlanVisible" @getProgressPlan="getProgressPlan"/>
    </el-dialog>
  </div>
</template>

<script>
  import ProgressPlanSelectDialog from '../../../../user/progress-plan/components/ProgressPlanSelectDialog';
  import ProgressSettingForm from '../../../../user/progress-plan/components/ProgressSettingForm';
  import ProgressFactorySettingForm from '../../../../user/progress-plan/components/ProgressFactorySettingForm';
  export default {
    name: 'ProgressOrderFactoryNodeForm',
    components: {ProgressFactorySettingForm, ProgressSettingForm, ProgressPlanSelectDialog},
    props: ['formData'],
    methods: {
      getProgressPlan (val) {
        this.formData.progressPlan = val;
        this.progressPlanVisible = false;
      },
      async saveProgressPlan () {
        const data = {
          id: this.formData.id ? this.formData.id : null,
          name: this.formData.name,
          remarks: this.formData.remarks,
          productionProgresses: this.formData.productionProgresses
        }
        const url = this.apis().createProgressPlan();
        const result = await this.$http.post(url, data);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$message.success('保存节点方案成功');
      }
    },
    data () {
      return {
        progressPlanVisible: false
      }
    }
  }
</script>

<style scoped>
  .progress-row {
    padding-left: 10px;
    margin-top: 20px;
  }
</style>
