<template>
  <div>
    <el-form ref="form" :rules="rules" :model="formData">
      <el-row class="reconciliation-basic-row" type="flex">
        <el-col :span="12">
          <el-form-item label="方案名称" prop="name" label-width="100px">
            <el-input placeholder="输入方案名称" v-model="formData.name" style="width: 100%"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="备注" label-width="100px">
            <el-input placeholder="输入备注" v-model="formData.remarks" style="width: 100%"></el-input>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row class="reconciliation-basic-row">
        <el-form-item label="对账配置" prop="isEnable" label-width="100px">
          <el-radio v-model="formData.isEnable" :label="true">启用</el-radio>
          <el-radio v-model="formData.isEnable" :label="false">停用</el-radio>
        </el-form-item>
      </el-row>
<!--      <reconciliation-setting-form :formData="formData" :isFormCreate="isCreate"/>-->
      <el-row class="reconciliation-basic-row">
        <el-form-item label="对账规则" prop="planRules" label-width="100px">
          <template v-for="item in formData.planRules">
            <el-row v-if="item.isRange" type="flex" >
              <el-col :span="18">
                <el-row  type="flex" style="align-items: baseline;padding-bottom: 20px">
                  <h6>当月</h6>
                  <el-select v-model="item.monthlyStartDayNum" placeholder="请选择">
                    <template v-for="val in 28">
                      <el-option :label="val+'号'" :value="val" :key="val"></el-option>
                    </template>
                    <el-option label="月底" :value="-1" :key="-1"></el-option>
                  </el-select>
                  <h6>至</h6>
                  <el-select v-model="item.monthlyEndDayNum" placeholder="请选择">
                    <template v-for="val in 28">
                      <el-option :label="val+'号'" :value="val" :key="val"></el-option>
                    </template>
                    <el-option label="月底" :value="-1" :key="-1"></el-option>
                  </el-select>
                  <h6>收货完成的发货单于</h6>
                  <el-select v-model="item.monthType" placeholder="请选择">
                    <template v-for="val in monthTypes">
                      <el-option :label="val.name" :value="val.code" :key="val.code"></el-option>
                    </template>
                  </el-select>
                  <el-select v-model="item.reconciliationDayNum" placeholder="请选择">
                    <template v-for="val in 28">
                      <el-option :label="val+'号'" :value="val" :key="val"></el-option>
                    </template>
                    <el-option label="月底" :value="-1" :key="-1"></el-option>
                  </el-select>
                  <h6>对账</h6>
                </el-row>
              </el-col>
              <el-col :span="6">
                <el-button type="text" @click="deleteRule(item)" style="color: red">
                  删除
                </el-button>
              </el-col>
            </el-row>
            <el-row v-else type="flex" >
              <el-col :span="18">
                <el-row type="flex" style="align-items: baseline;padding-bottom: 20px">
                  <h6>每月</h6>
                  <el-select v-model="item.monthlyEndDayNum" placeholder="请选择">
                    <template v-for="val in 28">
                      <el-option :label="val+'号'" :value="val" :key="val"></el-option>
                    </template>
                    <el-option label="月底" :value="-1" :key="-1"></el-option>
                  </el-select>
                  <h6>前收货完成的发货单于</h6>
                  <el-select v-model="item.monthType" placeholder="请选择">
                    <template v-for="val in monthTypes">
                      <el-option :label="val.name" :value="val.code" :key="val.code"></el-option>
                    </template>
                  </el-select>
                  <el-select v-model="item.reconciliationDayNum" placeholder="请选择">
                    <template v-for="val in 28">
                      <el-option :label="val+'号'" :value="val" :key="val"></el-option>
                    </template>
                    <el-option label="月底" :value="-1" :key="-1"></el-option>
                  </el-select>
                  <h6>对账</h6>
                </el-row>
              </el-col>
              <el-col :span="6">
                <el-button type="text" @click="addRule()">
                  <i class="el-icon-circle-plus"></i>增加规则
                </el-button>
              </el-col>
            </el-row>
          </template>
        </el-form-item>
      </el-row>
    </el-form>
  </div>
</template>

<script>
  import ReconciliationSettingForm from '../components/ReconciliationSettingForm';
  export default {
    name: 'ReconciliationPlanFormInfo',
    props: {
      formData: {
        type: Object
      },
      fromDialog: {
        type: Boolean,
        default: false
      },
      isCreate: {
        type: Boolean,
        default: true
      }
    },
    components: {ReconciliationSettingForm},
    methods: {
      onSubmit () {
        this.$emit('onSubmit');
      },
      validateField (name) {
        this.$refs.form.validateField(name);
      },
      addRule() {
        if (this.formData.planRules != null && this.formData.planRules.length < 3) {
          this.formData.planRules.push({isRange: true});
        } else {
          this.$message.error('最多支持3个对账规则');
        }
      },
      deleteRule(rule) {
        let index = this.formData.planRules.indexOf(rule);
        if (index > -1) {
          this.formData.planRules.splice(index, 1);
        }
      }
    },
    data () {
      var checkProductionProgresses = (rule, value, callback) => {
        if (this.formData.planRules.length === 0) {
          return callback(new Error('请填写对账规则'));
        } else {
          return callback();
        }
      };
      return {
        monthTypes: this.$store.state.EnumsModule.MonthType,
        rules: {
          'name': [
            { required: true, message: '必填', trigger: 'blur' }
          ],
          'planRules': [
            { type: 'object', validator: checkProductionProgresses, trigger: 'change' }
          ]
        }
        // formData: {
        //   name: '',
        //   remarks: '',
        //   planRules: []
        // }
      }
    },
    created () {
      // if (this.$route.params.formData != null) {
      //   this.formData = this.$route.params.formData;
      // }
    }
  }
</script>

<style scoped>
  .node-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .reconciliation-basic-row {
    width: 100%;
  }

  .reconciliation-container {
    border: 1px solid #DCDFE6;
    border-radius: 2px;
    width: 100%;
  }

  .reconciliation-btn {
    background-color: #FFD60C;
    border-color: #FFD60C;
  }

  /deep/ .el-form-item__error {
    width: 100px;
  }
  /deep/ .el-select {
    width: 100px;
    margin: 0 5px;
  }
</style>
