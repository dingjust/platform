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
        <el-col :offset="16">
          <el-card class="login-card">
            <b-input-group class="mb-3 login-row">
              <div class="input-group-prepend">
                <span class="input-group-text">
                  <i class="icon-user"></i>
                </span>
              </div>
              <input v-model="username" type="text" class="form-control" placeholder="请输入账号" />
            </b-input-group>
            <b-input-group class="mb-4 login-row">
              <div class="input-group-prepend">
                <span class="input-group-text">
                  <i class="icon-lock"></i>
                </span>
              </div>
              <input v-model="password" type="password" class="form-control" placeholder="请输入密码" />
            </b-input-group>
            <div id="nc_captcha" class="nc-container no-captcha-container"></div>
            <el-row type="flex" justify="center">
              <!-- <b-button variant="primary" class="px-4" @click="login" @keyup.enter="login">登录</b-button> -->
              <el-button class="login-btn" @click="login" :disabled="!captchaPass">登录</el-button>
            </el-row>
          </el-card>
        </el-col>
      </el-row>
    </div>
  </div>
</template>
<script>
  export default {
    name: "LoginPage",
    data() {
      return {
        username: "",
        password: "",
        NC_RESULT: {
          csessionid: '',
          sig: ''
        }
      };
    },
    computed:{
      captchaPass:function() {
        //人机验证通过 TODO:后端服务调用阿里云验证签名
        return this.NC_RESULT.csessionid!=''&&this.NC_RESULT.sig!=''&&this.username!=''&&this.password!='';
      }
    },
    created() {},
    mounted() {
      var nc_token = [
        "FFFF0N00000000008691",
        new Date().getTime(),
        Math.random()
      ].join(":");
      var NC_Opt = {
        renderTo: "#nc_captcha",
        appkey: "FFFF0N00000000008691",
        scene: "nc_login",
        token: nc_token,
        customWidth: 300,
        trans: {
          key1: "code0"
        },
        offsetWidth: 300,
        elementID: ["usernameID"],
        is_Opt: 0,
        language: "cn",
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
      nc.upLang("cn", {
        _startTEXT: "请按住滑块，拖动到最右边",
        _yesTEXT: "验证通过",
        _error300: '哎呀，出错了，点击<a href="javascript:__nc.reset()">刷新</a>再来一次',
        _errorNetwork: '网络不给力，请<a href="javascript:__nc.reset()">点击刷新</a>'
      });
    },
    methods: {
      login() {
        const username = this.username;
        const password = this.password;

        this.$store.dispatch("login", {
          username,
          password
        });
      },
      ///NC验证回调
      ncCallback(data){
          // window.console && console.log(nc_token);
          // window.console && console.log(data.csessionid);
          // window.console && console.log(data.sig);
          console.log(JSON.stringify(data));
          this.NC_RESULT.csessionid = data.csessionid;
          this.NC_RESULT.sig = data.sig;
      }
    }
  };

</script>
<style>
  .login-card {
    margin-top: 50px;
    background-color: #0000005e !important;
    border: none !important;
    width: 350px;
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

  .login-row {
    margin-top: 30px;
    width: 300px;
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
    background: #FFD60C;
    color: rgba(0, 0, 0, 0.85);
    width: 200px;
    height: 35px;
    border: none;
  }
</style>
