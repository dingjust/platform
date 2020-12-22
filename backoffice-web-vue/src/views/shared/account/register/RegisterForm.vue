<template>
  <div class="register-form-container">
    <el-dialog :visible.sync="serviceProtocolVisible" :close-on-click-modal="false">
      <service-protocol />
    </el-dialog>
    <el-dialog :visible.sync="paymentProtocolVisible" :close-on-click-modal="false">
      <payment-protocol />
    </el-dialog>
    <el-row type="flex" justify="center">
      <el-col :span="16">
        <el-form ref="form" :model="slotData" label-width="80px" :rules="rules" label-position="left">
          <el-form-item label="会员名" prop="phone">
            <el-input v-model="slotData.phone" placeholder="手机号">
              <template slot="prepend">+86</template>
            </el-input>
          </el-form-item>
          <el-form-item label="验证码" prop="code">
            <el-input v-model="slotData.code">
              <el-button slot="append" type="primary" :disabled="disable" :class="{ codeGeting:isGeting }"
                @click="getVerifyCode">{{getCode}}</el-button>
            </el-input>
          </el-form-item>
          <el-form-item label="联系人" prop="name">
            <el-input v-model="slotData.name"></el-input>
          </el-form-item>
          <el-form-item label="密码" prop="password">
            <el-input v-model="slotData.password" type="password"></el-input>
          </el-form-item>
          <el-form-item label="确认密码" prop="againPassword">
            <el-input v-model="slotData.againPassword" type="password">
              <i class="el-icon-success icon-success" slot="suffix" v-if="showSuccess"></i>
              <i class="el-icon-error icon-error" slot="suffix" v-if="showError"></i>
            </el-input>
          </el-form-item>
          <el-form-item label="公司名称" prop="companyName">
            <el-input v-model="slotData.companyName"></el-input>
          </el-form-item>
          <el-row type="flex" justify="center">
            <el-checkbox v-model="checked">我已同意并阅读<el-button type="text"
                @click="serviceProtocolVisible=!serviceProtocolVisible">《钉单平台服务协议》</el-button>和<el-button type="text"
                @click="paymentProtocolVisible=!paymentProtocolVisible">
                《钉单平台贷款代收代付协议》</el-button>
            </el-checkbox>
          </el-row>
          <el-form-item>
            <el-row type="flex" justify="center">
              <el-button class="register-btn" @click="onSubmit" :disabled="!checked">注册</el-button>
            </el-row>
          </el-form-item>
        </el-form>
      </el-col>
    </el-row>
  </div>
</template>
<script>
  import ServiceProtocol from './ServiceProtocol';
  import PaymentProtocol from './PaymentProtocol';

  export default {
    name: "RegisterForm",
    props: ['slotData'],
    components: {
      ServiceProtocol,
      PaymentProtocol
    },
    data() {
      var validatePass = (rule, value, callback) => {
        if (value === '') {
          callback(new Error('请输入密码'));
        } else {
          // if (this.slotData.password !== '') {
          //   this.$refs.form.validateField('password');
          // }
          callback();
        }
      };
      var validatePass2 = (rule, value, callback) => {
        if (value === '') {
          callback(new Error('请再次输入密码'));
        } else if (value !== this.slotData.password) {
          callback(new Error('两次输入密码不一致!'));
        } else {
          callback();
        }
      };
      var validatePhone = async (rule, value, callback) => {
        const reg = /^[1][3,4,5,6,7,8,9][0-9]{9}$/;
        if (value === '') {
          callback(new Error('请输入手机号码'));
        } else if (!reg.test(value)) {
          callback(new Error('请输入合法手机号码'));
        } else {
          callback();
        }
      };
      return {
        getCode: '获取验证码',
        isGeting: false,
        count: 60,
        disable: false,
        checked: false,
        serviceProtocolVisible: false,
        paymentProtocolVisible: false,
        formData: {

        },
        rules: {
          phone: [{
            required: true,
            // message: '请输入手机号码',
            trigger: 'blur',
            validator: validatePhone
          }, ],
          code: [{
            required: true,
            message: '请输入验证码',
            trigger: 'blur'
          }],
          name: [{
            required: true,
            message: '请输入会员名',
            trigger: 'blur'
          }],
          password: [{
            required: true,
            trigger: 'blur',
            validator: validatePass
          }],
          againPassword: [{
            required: true,
            trigger: 'blur',
            validator: validatePass2
          }],
          companyName: [{
            required: true,
            message: '请输入公司名',
            trigger: 'blur'
          }],
        }
      };
    },
    computed: {
      showSuccess: function () {
        return this.slotData.password == this.slotData.againPassword && this.slotData.password != '';
      },
      showError: function () {
        return this.slotData.password != this.slotData.againPassword && this.slotData.password != '';
      },
    },
    created() {},
    mounted() {

    },
    methods: {
      getVerifyCode() {
        if (this.slotData.phone == '') {
          this.$message.error('请填写手机号码');
          return;
        }
        this.sendCaptcha();
        var countDown = setInterval(() => {
          if (this.count < 1) {
            this.isGeting = false;
            this.disable = false;
            this.getCode = '获取验证码';
            this.count = 60;
            clearInterval(countDown);
          } else {
            this.isGeting = true;
            this.disable = true;
            this.getCode = this.count-- + 's后重发';
          }
        }, 1000);

      },
      async sendCaptcha() {
        const url = this.apis().sendCaptcha(this.slotData.phone);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        } else {
        }
      },
      async validateCaptcha() {
        const url = this.apis().validateCaptcha();
        const result = await this.$http.get(url, {
          phone: this.slotData.phone,
          captcha: this.slotData.code
        });
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return false;
        } else {
          return result;
        }
      },
      async onSubmit() {
        // const captchaStatus = await this.validateCaptcha();
        // if (!captchaStatus) {
        //   this.$message.error('验证码错误');
        //   return;
        // }

        let form = {
          mobileNumber: this.slotData.phone,
          password: this.slotData.password,
          name: this.slotData.companyName,
          contactPerson: this.slotData.name,
          contactPhone: this.slotData.phone,
          captchaCode: this.slotData.code
        }
        const url = this.apis().fastRegister(this.slotData.type);
        const result = await this.$http.post(url, form);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.$message.success('注册成功！');
        this.$router.push("/login");
      }
    }
  };

</script>
<style>
  .register-form-container {
    /* padding-left: 50px;
  padding-right: 50px; */
  }

  .register-btn {
    background: #ffd60c;
    color: rgba(0, 0, 0, 0.85);
    width: 200px;
    height: 35px;
    border: none;
  }

  .register-btn.el-button.is-disabled {
    background-color: #f1f1f1 !important;
  }

  .icon-success {
    color: #7AED8F;
    font-size: 18px;
  }

  .icon-error {
    color: red;
    font-size: 18px;
  }

  .codeGeting {
    background: #cdcdcd;
    border-color: #cdcdcd;
  }

</style>
