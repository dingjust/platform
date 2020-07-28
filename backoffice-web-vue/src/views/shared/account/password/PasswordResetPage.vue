<!-- 
 * @description: 密码重置页面
 * @fileName: PasswordResetPage.vue 
 * @author: yj 
 * @date: 2020-07-24 14:14:21
 * @version: V1.0.0 
!-->
<template>
  <div class="app flex-row register-container">
    <div class="register-body">
      <el-row type="flex" justify="center">
        <el-col :span="12">
          <div>
            <el-row type="flex" justify="end">
              <el-button type="text" class="tologin-btn" @click="toLogin">我有账号直接登录》</el-button>
            </el-row>
            <el-card>
              <el-row type="flex" justify="center" align="middle">
                <img src="static/img/logo3.png" class="register-logo" />
                <h2 class="register-title">钉单</h2>
              </el-row>
              <el-tabs v-model="form.type" @tab-click="handleClick" :stretch="true" class="register-form-tabs">
                <el-tab-pane label="主账号" name="main">
                  <password-reset-form :slot-data="form" accountType='main'/>
                </el-tab-pane>
                <el-tab-pane label="员工账号" name="employee">
                  <password-reset-form :slot-data="form" accountType='employee'/>
                </el-tab-pane>
              </el-tabs>
            </el-card>
          </div>
        </el-col>
      </el-row>
    </div>
  </div>
</template>
<script>
  import PasswordResetForm from "./PasswordResetForm";

  export default {
    name: "PasswordResetPage",
    props: {

    },
    data() {
      return {
        form: {
          type: "main",
          phone: "",
          name: "",
          code: "",
          password: "",
          againPassword: "",
          companyName: ""
        }
      };
    },
    components: {
      PasswordResetForm
    },
    computed: {},
    created() {
      if (this.$route.query.accountType != null && this.$route.query.accountType != '') {
        this.form.type = this.$route.query.accountType;
      }
    },
    mounted() {},
    methods: {
      handleClick(tab, event) {
        console.log(tab, event);
      },
      toLogin() {
        this.$router.push("/login");
      }
    }
  };

</script>
<style>
  .register-container {
    background-image: url("https://yijiayi.oss-cn-shenzhen.aliyuncs.com/login-background.jpg");
    background-repeat: no-repeat;
    background-size: cover;
  }

  .register-body {
    width: 100%;
    margin-right: auto;
    margin-left: auto;
    padding-top: 50px;
    overflow: auto;
    padding-bottom: 50px;
    padding-right: 20px;
  }

  .tologin-btn {
    color: #ffffff;
    font-size: 16px;
  }

  .register-logo {
    width: 46px;
    height: 46px;
    /* margin-top: 20px;
  margin-right: 20px; */
  }

  .register-title {
    margin-left: 20px;
    line-height: 46px;
    margin-top: 10px;
  }

  .register-form-tabs .el-tabs__item {
    font-size: 20px;
  }

  .register-form-tabs .el-tabs__item.is-active {
    color: #ffd60c;
  }

  .register-form-tabs .el-tabs__item:hover {
    color: #ffd60c;
    cursor: pointer;
  }

  .register-form-tabs .el-tabs__active-bar {
    background-color: #ffd60c;
  }

  .register-info {
    padding-left: 20px;
    padding-right: 20px;
    margin-bottom: 40px;
    margin-top: 10px;
  }

</style>
