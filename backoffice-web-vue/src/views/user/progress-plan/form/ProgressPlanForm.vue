<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row type="flex" justify="space-between">
        <el-col :span="6">
          <div class="node-list-title">
            <h6>创建节点方案</h6>
          </div>
        </el-col>
        <el-col :span="2">
          <el-button class="progress-btn" @click="onSubmit">确定</el-button>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <el-form ref="form" :inline="true" :rules="rules" :model="formData">
        <el-row class="progress-basic-row">
          <el-form-item label="方案名称" prop="name">
            <el-input placeholder="输入方案名称" v-model="formData.name"></el-input>
          </el-form-item>
          <el-form-item label="备注">
            <el-input placeholder="" v-model="formData.remarks"></el-input>
          </el-form-item>
        </el-row>
        <progress-setting-form :formData="formData"/>
<!--        <el-row class="progress-basic-row" :gutter="20">-->
<!--          <el-col :span="12">-->
<!--            <div class="progress-container">-->
<!--              <el-table ref="nodeTable" :data="formData.productionProgresses" stripe :height="autoHeight">-->
<!--                <el-table-column label="节点名称" prop="phase"></el-table-column>-->
<!--                <el-table-column label="预警天数">-->
<!--                  <template slot-scope="scope">-->
<!--                    <el-input v-model="scope.row.delayedDays"></el-input>-->
<!--                  </template>-->
<!--                </el-table-column>-->
<!--                <el-table-column label="操作">-->
<!--                  <template slot-scope="scope">-->
<!--                    <el-button type="text" @click="onDelete(scope.row)">删除</el-button>-->
<!--                  </template>-->
<!--                </el-table-column>-->
<!--              </el-table>-->
<!--            </div>-->
<!--          </el-col>-->
<!--          <el-col :span="12">-->
<!--            <div class="progress-container">-->
<!--              <el-table ref="systemTable" stripe :data="data" :height="autoHeight">-->
<!--                <el-table-column label="节点名称" prop="phase"></el-table-column>-->
<!--                <el-table-column label="操作">-->
<!--                  <template slot-scope="scope">-->
<!--                    <el-button type="text" @click="onAppend(scope.row)" :disabled="isDisabled(scope.row)">添加</el-button>-->
<!--                  </template>-->
<!--                </el-table-column>-->
<!--              </el-table>-->
<!--            </div>-->
<!--          </el-col>-->
<!--        </el-row>-->
        <el-row class="progress-basic-row">
          <el-form-item prop="productionProgresses" label-width="100">
            <div></div>
          </el-form-item>
        </el-row>
      </el-form>
    </el-card>
  </div>
</template>

<script>
  import ProgressSettingForm from '../components/ProgressSettingForm';
  export default {
    name: 'ProgressPlanForm',
    components: {ProgressSettingForm},
    methods: {
      onSubmit () {
        this.$refs['form'].validate(valid => {
          if (valid) {
            this._onSubmit();
          } else {
            this.$message.error('请完善表单信息');
            return false;
          }
        });
      },
      async _onSubmit () {
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
        this.$message.success(this.formData.id ? '添加节点成功' : '编辑节点成功');
        await this.$router.push('/account/setting/progress-plan');
      },
      validateField (name) {
        this.$refs.form.validateField(name);
      }
    },
    data () {
      var checkProductionProgresses = (rule, value, callback) => {
        if (this.formData.productionProgresses.length === 0) {
          return callback(new Error('请选择进度节点'));
        } else {
          return callback();
        }
      };
      return {
        rules: {
          'name': [
            { required: true, message: '必填', trigger: 'blur' }
          ],
          'productionProgresses': [
            { type: 'object', validator: checkProductionProgresses, trigger: 'change' }
          ]
        },
        formData: {
          name: '',
          remarks: '',
          productionProgresses: []
        }
      }
    },
    watch: {
      'formData.productionProgresses': function (n, o) {
        this.validateField('productionProgresses');
      }
    },
    created () {
      if (this.$route.params.formData != null) {
        this.formData = this.$route.params.formData;
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
