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
                <el-tab-pane label="品牌注册" name="brand">
                  <el-row type="flex" justify="center">
                    <span
                      class="register-info">品牌商：服装品牌商、贴牌贸易商、设计工作室、批发档口、电商网红等，需要在钉单APP寻找优质工厂或者服装款式服务的企业或个人，选择“品牌商”注册。</span>
                  </el-row>
                  <register-form :slot-data="form" />
                </el-tab-pane>
                <el-tab-pane label="工厂注册" name="factory">
                  <el-row type="flex" justify="center">
                    <span class="register-info">工 厂：服装生产工厂，需要在钉单APP上寻找各类服装加工订单，管理生产进度的企业选择“工厂”注册。</span>
                  </el-row>
                  <register-form :slot-data="form" />
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
  import RegisterForm from "./RegisterForm";

  export default {
    name: "RegisterPage",
    data() {
      return {
        form: {
          type: "brand",
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
      RegisterForm
    },
    computed: {},
    created() {},
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
