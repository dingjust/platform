<template>
  <div>
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
      <el-row class="progress-basic-row">
        <el-form-item prop="productionProgresses" label-width="100">
          <div></div>
        </el-form-item>
      </el-row>
    </el-form>
  </div>
</template>

<script>
  import ProgressSettingForm from '../components/ProgressSettingForm';
  export default {
    name: 'ProgressPlanFormInfo',
    props: {
      formData: {
        type: Object
      },
      fromDialog: {
        type: Boolean,
        default: false
      }
    },
    components: {ProgressSettingForm},
    methods: {
      onSubmit () {
        this.$emit('onSubmit');
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
        }
        // formData: {
        //   name: '',
        //   remarks: '',
        //   productionProgresses: []
        // }
      }
    },
    watch: {
      'formData.productionProgresses': function (n, o) {
        this.validateField('productionProgresses');
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
