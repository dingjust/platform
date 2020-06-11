<template>
  <div>
    <el-row type="flex" justify="center" align="middle" class="progress-date-form-row">
      <div class="progress-date-form-title">
        <h6>跟单员</h6>
      </div>
      <personnel-selection :vPerson.sync="submitData.personInCharge" width="220"/>
    </el-row>
    <el-row type="flex" justify="center" align="middle" class="progress-date-form-row">
      <div class="progress-date-form-title">
        <h6>优先级</h6>
      </div>
      <el-select v-model="submitData.priorityLevel" placeholder="请选择" style="width: 220px">
        <el-option
          v-for="item in priorities"
          :key="item.code"
          :label="item.name"
          :value="item.code">
        </el-option>
      </el-select>
    </el-row>
    <el-divider></el-divider>
    <template v-for="item in submitData.progresses">
      <el-row type="flex" justify="center" align="middle" class="progress-date-form-row" :key="item.id">
        <div class="progress-date-form-title">
          <h6>{{item.progressPhase.name}}</h6>
        </div>
        <el-date-picker v-model="item.estimatedDate" type="date" value-format="timestamp" placeholder="选择日期">
        </el-date-picker>
      </el-row>
    </template>
    <h6 class="progress-date-form-info">预计交货时间：{{slotData.expectedDeliveryDate | formatDate}}</h6>
    <el-row type="flex" justify="center" style="margin-top:20px;">
      <el-button @click="onSubmit" type="primary">确定</el-button>
    </el-row>
  </div>
</template>

<script>
  import PersonnelSelection from '../../../../../../../components/custom/PersonnelSelection';
  export default {
    name: 'ProductionProgressDateSettingForm',
    props: ['slotData'],
    components: {PersonnelSelection},
    computed: {},
    methods: {
      async onSubmit () {
        let formData = {
          id: this.submitData.id,
          progresses: this.submitData.progresses,
          personInCharge: this.submitData.personInCharge,
          priorityLevel: this.submitData.priorityLevel
        }
        const url = this.apis().updateProgressDate();
        const result = await this.$http.put(url, formData);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$message.success('设置成功');
        this.$emit('afterSubmit');
      }
    },
    data () {
      return {
        submitData: '',
        personInCharge: {
          id: ''
        },
        priorityLevel: '',
        priorities: this.$store.state.EnumsModule.priorities
      };
    },
    created () {
      this.submitData = JSON.parse(JSON.stringify(this.slotData));
      this.submitData.priorityLevel = '';
      this.submitData.personInCharge = {id: ''};
    }
  };
</script>
<style>
  .purchase-grid-content {
    text-align: center;
    border-left: 2px solid rgba(0, 0, 0, 0.09);
  }

  .progress-date-form-row {
    margin-top: 10px;
  }

  .progress-date-form-title {
    width: 50px;
  }

  .progress-date-form-info {
    color: red;
    size: 12px;
    margin-left: 50px;
    margin-top: 10px;
  }

</style>
