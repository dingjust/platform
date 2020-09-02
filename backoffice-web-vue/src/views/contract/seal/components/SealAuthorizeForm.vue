<template>
  <div>
    <el-row type="flex" justify="center" style="margin-bottom: 20px">
      <h6 style="font-size: 20px">印章授权</h6>
    </el-row>
    <el-row type="flex" justify="center">
      <el-form :model="formData" :inline="true">
        <el-form-item label="选择授权人员">
          <el-input v-model="formData.name" placeholder=""></el-input>
        </el-form-item>
      </el-form>
    </el-row>
    <el-row type="flex" justify="center" align="middle" >
      <h6 style="color: #F56C6C">注：被授权人需要完成个人实名认证</h6>
    </el-row>
    <el-row type="flex" justify="center" align="middle" style="margin-top: 10px">
      <el-button class="create-btn" @click="onSumbit">确定</el-button>
    </el-row>
  </div>
</template>

<script>
export default {
  name: 'SealAuthorizeForm',
  methods: {
    onSumbit () {
      this.$emit('callback');
    }
  },
  data () {
    return {
      formData: {
        name: ''
      }
    }
  }  
}
</script>

<style scoped>
  .create-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    border-radius: 3px;
    width: 70px;
    height: 30px;
  }
</style>