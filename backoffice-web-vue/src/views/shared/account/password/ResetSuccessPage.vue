<!-- 
 * @description: 重置成功
 * @fileName: ResetSuccessPage.vue 
 * @author: yj 
 * @date: 2020-07-24 16:00:26
 * @version: V1.0.0 
!-->
<template>
  <div class="app flex-row register-container">
    <div class="register-body">
      <el-row type="flex" justify="center">
        <el-col :span="12">
          <div>
            <!-- <el-row type="flex" justify="end">
              <el-button type="text" class="tologin-btn" @click="toLogin">我有账号直接登录》</el-button>
            </el-row> -->
            <el-card>
              <el-row type="flex" justify="center" align="middle">
                <img src="static/img/logo3.png" class="register-logo" />
                <h2 class="register-title">钉单</h2>
              </el-row>
              <el-row type="flex" justify="center" style="margin-top:50px">
                <i class="el-icon-success success-icon"></i>
                <h4>密码修改成功</h4>
              </el-row>
              <el-row type="flex" justify="center">
                <h4>您可以使用新的密码登录</h4>
              </el-row>
              <el-row type="flex" justify="center" style="margin-top:100px;">
                <el-button class="register-btn" @click="toLogin">去登陆</el-button>
              </el-row>
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
    name: "ResetSuccessPage",
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
      },
      toLogin() {
        this.$router.push("/login");
      }
    }
  };

</script>
<style>
  .register-container {
    background-image: url("https://cdn-oss.nbyjy.net/login-background.jpg");
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

  .success-icon {
    font-size: 15px;
    color: #4fc3f7;
    padding-top: 3px;
  }

  .register-btn {
    background: #ffd60c;
    color: rgba(0, 0, 0, 0.85);
    width: 200px;
    height: 35px;
    border: none;
  }
</style>
