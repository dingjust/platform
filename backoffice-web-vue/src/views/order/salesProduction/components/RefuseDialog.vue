<template>
  <div class="animated fadeIn">
    <el-row type="flex" justify="space-between">
      <el-col :span="6">
        <div class="sales-plan-form-title">
          <h6>拒绝</h6>
        </div>
      </el-col>
    </el-row>
    <div class="pt-2"></div>
    <el-row type="flex" class="basic-form-row">
      <el-col :span="4">
        <h6>拒绝原因<span style="color: red">*</span></h6>
      </el-col>
      <el-col :span="20">
        <el-input
          type="textarea"
          placeholder="请输入内容"
          v-model="textarea"
          maxlength="30">
        </el-input>
      </el-col>
    </el-row>
    <el-row type="flex" justify="center" style="margin-top: 20px">
      <el-col :span="3">
        <el-button class="material-btn" @click="onSubmit">通过</el-button>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  export default {
    name: 'RefuseDialog',
    data () {
      return {
        textarea: ''
      }
    },
    methods: {
      onSubmit () {
        if (this.textarea.replace(/^\s*|\s*$/g, '').length === 0) {
          this.$message.error('请填写拒绝原因');
          return;
        }
        this.$emit('getRefuseMsg', this.textarea);
      }
    }
  }
</script>

<style scoped>
  .sales-plan-form-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .material-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    width: 90px;
    height: 35px;
  }

  .basic-form-row {
    padding-left: 10px;
  }
</style>
