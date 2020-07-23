<template>
  <el-form ref="form" :model="formData">
    <el-row type="flex" justify="start">
      <el-col :span="12" :offset="1">
        <h6>输入部门名称</h6>
      </el-col>
    </el-row>
    <el-row type="flex" justify="center" style="margin-top: 20px">
      <el-col :span="16">
        <el-form-item>
          <el-input ref="input" v-model="formData.deptName" @keyup.enter.native="onCreate"></el-input>
        </el-form-item>
      </el-col>
    </el-row>
    <el-row type="flex" justify="center" align="middle">
      <el-button @click="onCreate">确认</el-button>
    </el-row>
  </el-form>
</template>

<script>
  export default {
    name: 'DeptForm',
    props: ['formData'],
    methods: {
      onCreate () {
        this.$refs['form'].validate(valid => {
          if (valid) {
            this._onCreate();
          } else {
            this.$message.error('请完善表单信息');
            return false;
          }
        });
      },
      _onCreate () {
        this.$emit('onConfirm', this.formData);
      }
    },
    data () {
      return {
        rules: {
          deptName: [
            { required: true, message: '必填', trigger: 'blur' },
          ]
        },
      }
    },
    created () {
      // input框获取焦点
      this.$nextTick(() => {
        this.$refs.input.focus();
      })
    }
  }
</script>

<style scoped>

</style>