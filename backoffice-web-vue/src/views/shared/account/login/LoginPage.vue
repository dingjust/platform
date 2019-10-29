<template>
  <div class="app flex-row login-container">
    <div class="login-container">
      <el-row type="flex" justify="end">
        <img src="static/img/logo3.png" class="login-logo" />
      </el-row>
      <el-row type="flex" justify="space-between">
        <el-col :span="8" :offset="2">
          <el-row>
            <h2 class="login-text">钉单记录你每一步的努力，</h2>
          </el-row>
          <el-row>
            <h2 class="login-text">也分享你每一步收获的喜悦。</h2>
          </el-row>
          <el-row type="flex" justify="end">
            <h3 class="login-text2">——致敬每一位服装人</h3>
          </el-row>
        </el-col>
      </el-row>
      <el-row type="flex">
        <el-col :span="5" :xs="12" :sm="10" :md="6" :lg="5" :xl="5" :offset="16">
          <el-card class="login-card">
            <b-input-group class="mb-3">
              <div class="input-group-prepend">
                <span class="input-group-text"><i class="icon-user"></i></span>
              </div>
              <input v-model="username" type="text" class="form-control" placeholder="请输入账号">
            </b-input-group>
            <b-input-group class="mb-4">
              <div class="input-group-prepend">
                <span class="input-group-text"><i class="icon-lock"></i></span>
              </div>
              <input v-model="password" type="password" class="form-control" placeholder="请输入密码">
            </b-input-group>
            <el-row type="flex" justify="center">
              <b-button variant="primary" class="px-4" @click="login" @keyup.enter="login">登录</b-button>
            </el-row>
          </el-card>
        </el-col>
      </el-row>
    </div>
  </div>
</template>
<script>
  export default {
    name: 'LoginPage',
    data() {
      return {
        username: '',
        password: '',
        cardStyle: {
          // color:'#0000'
          border: 'none',
          backgroundColor: '#00000029'
        }
      }
    },
    created() {
      // var vm = this;
      // document.onkeydown = function(e) {
      //   var key = window.event.keyCode;
      //   if (key == 13) {
      //     vm.login();
      //   }
      // }
    },
    methods: {
      login() {
        const username = this.username;
        const password = this.password;

        this.$store.dispatch('login', {
          username,
          password
        });
      },
    }
  }

</script>
<style>
  .login-card {
    margin-top: 50px;
    background-color: #0000005e !important;
    border: none !important;
  }

  .login-container {
    background-image: url('https://yijiayi.oss-cn-shenzhen.aliyuncs.com/login-background.jpg');
    background-repeat: no-repeat;
    background-size: cover;
  }

  .login-text {
    color: white;
    font-family: "Helvetica Neue", Helvetica, "PingFang SC", "Hiragino Sans GB", "Microsoft YaHei", "微软雅黑", Arial, sans-serif;
  }

  .login-text2 {
    color: white;
    font-family: "Helvetica Neue", Helvetica, "PingFang SC", "Hiragino Sans GB", "Microsoft YaHei", "微软雅黑", Arial, sans-serif;
    font-size-adjust: inherit;
  }

  .login-container {
    width: 100%;
    padding-right: 15px;
    padding-left: 15px;
    margin-right: auto;
    margin-left: auto;
  }

  .login-logo {
    width: 64px;
    height: 64px;
    margin-top: 20px;
    margin-right: 20px;
  }

</style>
