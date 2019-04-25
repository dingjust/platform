<template>
  <el-form ref="form"
           label-position="top"
           :model="slotData"
           :rules="rules">
    <el-row :gutter="10">
      <el-col :span="24">
        <el-form-item label="用户名">
          <el-input :value="username" disabled></el-input>
        </el-form-item>
      </el-col>
    </el-row>
    <el-row :gutter="10">
      <el-col :span="24">
        <el-form-item label="旧密码" prop="oldPassword">
          <el-input type="password" v-model="slotData.oldPassword"></el-input>
        </el-form-item>
      </el-col>
    </el-row>
    <el-row :gutter="10">
      <el-col :span="24">
        <el-form-item label="密码" prop="newPassword">
          <el-input type="password" v-model="slotData.newPassword"></el-input>
        </el-form-item>
      </el-col>
    </el-row>
    <el-row :gutter="10">
      <el-col :span="24">
        <el-form-item label="确认密码" prop="confirmNewPassword">
          <el-input type="password" v-model="slotData.confirmNewPassword"></el-input>
        </el-form-item>
      </el-col>
    </el-row>
    <el-row :gutter="10">
      <el-col :span="12">
        <el-button class="btn-block" @click="onCancel">取 消</el-button>
      </el-col>
      <el-col :span="12">
        <el-button class="btn-block" type="primary" @click="onSubmit">确 定</el-button>
      </el-col>
    </el-row>
  </el-form>
</template>
<script>
  export default {
    name: 'ChangePasswordPage',
    props: ['username', 'ignoreOldPassword'],
    computed: {
      rules: function () {
        if (!this.ignoreOldPassword) {
          return {
            oldPassword: [{required: true, message: '必填', trigger: 'blur'}],
            newPassword: [{required: true, message: '必填', trigger: 'blur'}],
            confirmNewPassword: [{required: true, message: '必填', trigger: 'blur'}],
          }
        } else {
          return {
            newPassword: [{required: true, message: '必填', trigger: 'blur'}],
            confirmNewPassword: [{required: true, message: '必填', trigger: 'blur'}],
          }
        }
      }
    },
    data() {
      return {
        slotData: {
          oldPassword: '',
          newPassword: '',
          confirmNewPassword: ''
        },
      }
    },
    methods: {
      onCancel() {
        this.$emit('onCancel');
      },
      onSubmit() {
        this.$refs['form'].validate(valid => {
          if (valid) {

            const newPassword = this.slotData.newPassword.trim();
            const confirmNewPassword = this.slotData.confirmNewPassword.trim();
            if (newPassword !== confirmNewPassword) {
              this.$message.error('两次密码输入不一致，请重新输入');
              return false;
            }

            const oldPassword = this.slotData.oldPassword.trim();

            this.$emit('onChangePassword', oldPassword, newPassword);

            return true;
          }

          return false;
        });
      },
    }
  }
</script>
