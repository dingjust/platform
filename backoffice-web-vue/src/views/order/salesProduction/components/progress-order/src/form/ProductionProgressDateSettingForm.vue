<template>
  <div>
    <el-form :model="submitData" :inline="true" :rules="rules" ref="form" hide-required-asterisk>
      <el-row type="flex" justify="center" align="middle" class="progress-date-form-row">
<!--        <div class="progress-date-form-title">-->
<!--          <h6>跟单员</h6>-->
<!--        </div>-->
<!--        <personnel-selection :vPerson.sync="submitData.personInCharge" width="220"/>-->
        <!-- <el-form-item label="跟单员" prop="personInCharge" style="margin-bottom: 0px">
          <personnel-selection :vPerson.sync="submitData.personInCharge" width="220"/>
        </el-form-item> -->
      </el-row>
      <el-row type="flex" justify="center" align="middle" class="progress-date-form-row">
<!--        <div class="progress-date-form-title">-->
<!--          <h6>优先级</h6>-->
<!--        </div>-->
        <el-form-item label="优先级" prop="priorityLevel" style="margin-bottom: 0px">
          <el-select v-model="submitData.priorityLevel" placeholder="请选择" style="width: 220px">
            <el-option
              v-for="item in priorities"
              :key="item.code"
              :label="item.name"
              :value="item.code">
            </el-option>
          </el-select>
        </el-form-item>
      </el-row>
      <el-divider></el-divider>
      <template v-for="(item, index) in submitData.progresses">
        <el-row type="flex" justify="center" align="middle" class="progress-date-form-row" :key="item.id">
<!--          <div class="progress-date-form-title">-->
<!--            <h6>{{item.progressPhase.name}}</h6>-->
<!--          </div>-->
          <el-form-item :label="item.progressPhase.name" :prop="'progresses.' + index + '.estimatedDate'"
                        :rules="[{required: true, message: '请选择日期', trigger: 'change'}]" style="margin-bottom: 0px">
            <el-date-picker v-model="item.estimatedDate" type="date" value-format="timestamp" placeholder="选择日期" @change="changeDate">
            </el-date-picker>
          </el-form-item>
        </el-row>
      </template>
      <h6 class="progress-date-form-info">预计交货时间：{{slotData.expectedDeliveryDate | formatDate}}</h6>
      <el-row type="flex" justify="center" style="margin-top:20px;">
        <el-button @click="onSubmit" type="primary">确定</el-button>
      </el-row>
    </el-form>
  </div>
</template>

<script>
  import { PersonnelSelection } from '@/components/';
  export default {
    name: 'ProductionProgressDateSettingForm',
    props: ['slotData'],
    components: {PersonnelSelection},
    computed: {},
    methods: {
      onSubmit () {
        this.$refs['form'].validate((valid) => {
          if (valid) {
            this._onSubmit();
          } else {
            this.$message.error('请完善需求信息');
            return false;
          }
        });
      },
      async _onSubmit () {
        let formData = {
          id: this.submitData.id,
          progresses: this.submitData.progresses,
          personInCharge: this.submitData.personInCharge,
          priorityLevel: this.submitData.priorityLevel
        }
        const url = this.apis().updateProgressDate();
        const result = await this.$http.put(url, formData);
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        this.$message.success('设置成功');
        this.$emit('afterSubmit');
      },
      changeDate (timestamp) {
        const nowTimestamp = new Date(new Date().setHours(0, 0, 0, 0));
        if (timestamp < nowTimestamp) {
          this.$message.warning('选择日期早于当前日期');
        }
      }
    },
    data () {
      var checkPersonInCharge = (rule, value, callback) => {
        if (value.id != '') {
          return callback();
        } else {
          return callback(new Error('请选择跟单员'));
        }
      };
      return {
        rules: {
          personInCharge: [{ type: 'object', validator: checkPersonInCharge, trigger: 'change' }],
          priorityLevel: [{required: true, message: '请选择优先级', trigger: 'change'}]
        },
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
      if (!this.submitData.priorityLevel) {
        this.$set(this.submitData, 'priorityLevel', '');
      }
      if (!this.submitData.priorityLevel) {
        this.$set(this.submitData, 'personInCharge', {id: ''});
      }
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
