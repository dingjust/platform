<template>
  <div class="app flex-row login-container">
    <div class="login-body">
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
        <el-col :offset="16">
          <el-card class="login-card">
            <div class="tab-container">
              <el-row type="flex" style="height:100%">
                <div class="tab-btn" :class="activeTabName=='main'?'btn-active':null" @click="handleTabClick('main')">
                  <span>主账号</span>
                </div>
                <div class="tab-btn" :class="activeTabName=='employee'?'btn-active':null"
                  @click="handleTabClick('employee')">
                  <span>员工账号</span>
                </div>
              </el-row>
            </div>
            <div class="card-main">
              <!-- 主账号 -->
              <template v-if="activeTabName=='main'">
                <b-input-group class="mb-3 login-row">
                  <div class="input-group-prepend">
                    <span class="input-group-text">
                      <i class="icon-user"></i>
                    </span>
                  </div>
                  <input v-model="username" type="text" class="form-control" placeholder="请输入账号" />
                </b-input-group>
              </template>
              <!-- 员工账号 -->
              <template v-if="activeTabName=='employee'">
                <b-input-group class="mb-3 login-row">
                  <div class="input-group-prepend">
                    <span class="input-group-text">
                      <i class="icon-user"></i>
                    </span>
                  </div>
                  <input v-model="username" type="text" class="form-control" placeholder="主账号" />
                  <div style="width:10px"></div>
                  <input v-model="employeeUserName" type="text" class="form-control" placeholder="员工账号" />
                </b-input-group>
              </template>
              <b-input-group class="mb-4 login-row">
                <div class="input-group-prepend">
                  <span class="input-group-text">
                    <i class="icon-lock"></i>
                  </span>
                </div>
                <input v-model="password" type="password" class="form-control" placeholder="请输入密码" />
              </b-input-group>
              <el-row class="login-btn-row" type="flex" justify="space-between">
                <el-button type="text" @click="onRegister" class="login-btn_text">注册</el-button>
                <el-button type="text" @click="onPasswordReset" class="login-btn_text">忘记密码</el-button>
              </el-row>
              <div id="nc_captcha" class="nc-container no-captcha-container"></div>
              <el-row type="flex" justify="center">
                <!-- <b-button variant="primary" class="px-4" @click="login" @keyup.enter="login">登录</b-button> -->
                <el-button class="login-btn" @click="login" :disabled="!captchaPass">登录</el-button>
              </el-row>
            </div>
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
        activeTabName: 'main',
        username: '',
        //员工账号,
        employeeUserName: '',
        password: '',
        NC_RESULT: {
          csessionid: '',
          sig: '',
          value: '',
          token: ''
        }
      };
    },
    computed: {
      captchaPass: function () {
        // 人机验证通过 TODO:后端服务调用阿里云验证签名        

        //员工账号
        if (this.activeTabName == 'employee') {
          return (
            this.NC_RESULT.csessionid != '' &&
            this.NC_RESULT.sig != '' &&
            this.username != '' &&
            this.password != '' &&
            this.employeeUserName != '' &&
            this.NC_RESULT.value == 'pass'
          );
        }
        
        return (
          this.NC_RESULT.csessionid != '' &&
          this.NC_RESULT.sig != '' &&
          this.username != '' &&
          this.password != '' &&
          this.NC_RESULT.value == 'pass'
        );
      }
    },
    created() {      
      var ua = navigator.userAgent.toLowerCase(); // 判断浏览器的类型
      //本地是否存储userName
      let localUserName = localStorage.getItem('userName');
      if (localUserName != null && localUserName != '') {
        this.username = localUserName;
      }

      let employeeUserName = localStorage.getItem('employeeUserName');
      if (employeeUserName != null && employeeUserName != '') {
        this.employeeUserName = employeeUserName;
      }
    },
    mounted() {
      var nc_token = [
        'FFFF0N00000000008691',
        new Date().getTime(),
        Math.random()
      ].join(':');
      var NC_Opt = {
        renderTo: '#nc_captcha',
        appkey: 'FFFF0N00000000008691',
        scene: 'nc_login',
        token: nc_token,
        customWidth: 300,
        trans: {
          key1: 'code0'
        },
        offsetWidth: 300,
        elementID: ['usernameID'],
        is_Opt: 0,
        language: 'cn',
        isEnabled: true,
        timeout: 3000,
        times: 5,
        apimap: {
          // 'analyze': '//a.com/nocaptcha/analyze.jsonp',
          // 'get_captcha': '//b.com/get_captcha/ver3',
          // 'get_captcha': '//pin3.aliyun.com/get_captcha/ver3'
          // 'get_img': '//c.com/get_img',
          // 'checkcode': '//d.com/captcha/checkcode.jsonp',
          // 'umid_Url': '//e.com/security/umscript/3.2.1/um.js',
          // 'uab_Url': '//aeu.alicdn.com/js/uac/909.js',
          // 'umid_serUrl': 'https://g.com/service/um.json'
        },
        callback: this.ncCallback
      };
      var nc = new noCaptcha(NC_Opt);
      nc.upLang('cn', {
        _startTEXT: '请按住滑块，拖动到最右边',
        _yesTEXT: '验证通过',
        _error300: '哎呀，出错了，点击<a href="javascript:__nc.reset()">刷新</a>再来一次',
        _errorNetwork: '网络不给力，请<a href="javascript:__nc.reset()">点击刷新</a>'
      });
    },
    methods: {
      async login() {
        let username = this.username.replace(/(\s*$)/g, '');
        if (this.activeTabName == 'employee') {
          username = username + ':' + this.employeeUserName;
        }
        const password = this.password;

        await this.$store.dispatch('login', {
          username,
          password
        });
      },
      /// NC验证回调
      ncCallback(data) {
        console.log(JSON.stringify(data));
        this.NC_RESULT.csessionid = data.csessionid;
        this.NC_RESULT.sig = data.sig;
        this.NC_RESULT.token = data.token;
        this.NC_RESULT.value = data.value;
      },
      onRegister() {
        this.$router.push('register');
        // this.$router.push('/account/setting/payPlan/create');
        // this.$router.push("/account/my");
      },
      handleTabClick(name) {
        this.activeTabName = name;
      },
      onPasswordReset() {
        this.$router.push({
          path: '/password/reset',
          query: {
            accountType: this.activeTabName
          }
        });
      }
    }
  };

</script>
<style>
  .login-card {
    margin-top: 50px;
    background-color: rgba(0, 0, 0, 0.35) !important;
    border: none !important;
    width: 350px;
  }

  .login-card .el-card__body {
    padding: 0;
  }

  .login-container {
    background-image: url("https://yijiayi.oss-cn-shenzhen.aliyuncs.com/login-background.jpg");
    background-repeat: no-repeat;
    background-size: cover;
  }

  .login-text {
    color: white;
    font-family: "Helvetica Neue", Helvetica, "PingFang SC", "Hiragino Sans GB",
      "Microsoft YaHei", "微软雅黑", Arial, sans-serif;
  }

  .login-text2 {
    color: white;
    font-family: "Helvetica Neue", Helvetica, "PingFang SC", "Hiragino Sans GB",
      "Microsoft YaHei", "微软雅黑", Arial, sans-serif;
    font-size-adjust: inherit;
  }

  .login-body {
    width: 100%;
    overflow: auto;
    margin-right: auto;
    margin-left: auto;
    padding-bottom: 50px;
    padding-right: 20px;
  }

  .login-logo {
    width: 64px;
    height: 64px;
    margin-top: 20px;
    margin-right: 20px;
  }

  .login-row {
    margin-top: 30px;
    width: 300px;
  }

  .login-btn-row {
    /* margin-top: 10px; */
    width: 300px;
  }

  .login-btn_text {
    color: #ffffff;
  }

  .no-captcha-container {
    width: 100px;
    height: 50px;
  }

  .login-input {
    width: 300px;
  }

  .nc_scale div.nc_bg {
    background: #ffd60c !important;
    /* 滑过时的背景色 */
  }

  .login-btn {
    background: #ffd60c;
    color: rgba(0, 0, 0, 0.85);
    width: 200px;
    height: 35px;
    border: none;
  }

  .login-btn.el-button.is-disabled {
    background-color: #f1f1f1 !important;
  }

  .tab-container {
    width: 100%;
    height: 40px;
    background-color: #ffffff40;
  }

  .card-main {
    padding: 20px;
  }

  .tab-btn {
    width: 50%;
    height: 100%;
    cursor: pointer;
    line-height: 40px;
    text-align: center;
  }

  .btn-active {
    background-color: white;
  }

</style>
