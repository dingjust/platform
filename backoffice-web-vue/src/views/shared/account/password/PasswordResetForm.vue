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
          <el-form-item label="会员名" prop="phone" v-if="accountType=='main'">
            <el-input v-model="slotData.phone" placeholder="手机号">
              <template slot="prepend">+86</template>
            </el-input>
          </el-form-item>
          <template v-if="accountType=='employee'">
            <el-row type="flex" justify="space-between">
              <el-col :span="15">
                <el-form-item label="会员名" prop="phone">
                  <el-input v-model="slotData.phone" placeholder="主账号">
                  </el-input>
                </el-form-item>
              </el-col>
              <el-col :span="9">
                <el-form-item prop="phone" label="" label-width="10px" v-if="accountType=='employee'">
                  <el-input v-model="slotData.phone" placeholder="员工账号" style="width:100%">
                  </el-input>
                </el-form-item>
              </el-col>
            </el-row>
          </template>
          <el-form-item label="验证码" prop="code">
            <el-input v-model="slotData.code">
              <el-button slot="append" type="primary" :disabled="disable" :class="{ codeGeting:isGeting }"
                @click="getVerifyCode">{{getCode}}</el-button>
            </el-input>
          </el-form-item>
          <el-form-item label="登录密码" prop="password">
            <el-input v-model="slotData.password" type="password"></el-input>
          </el-form-item>
          <el-form-item label="确认密码" prop="againPassword">
            <el-input v-model="slotData.againPassword" type="password">
              <i class="el-icon-success icon-success" slot="suffix" v-if="showSuccess"></i>
              <i class="el-icon-error icon-error" slot="suffix" v-if="showError"></i>
            </el-input>
          </el-form-item>
          <el-form-item>
            <el-row type="flex" justify="center">
              <el-button class="register-btn" @click="onSubmit">提交</el-button>
            </el-row>
          </el-form-item>
        </el-form>
      </el-col>
    </el-row>
  </div>
</template>
<script>
  export default {
    name: "PasswordResetForm",
    props: {
      slotData: {

      },
      //类型(默认主账号)
      accountType: {
        type: String,
        default: 'main'
      }
    },
    components: {

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
          console.log('发送成功');
        }
      },
      onSubmit() {
        //校验
        this.$refs['form'].validate((valid) => {
          if (valid) {
            this._onSubmit();
          }
        });
      },
      async _onSubmit() {
        let form = {
          newPassword: this.slotData.password,
          captcha: this.slotData.code
        }
        const url = this.apis().resetPasswordByCaptcha(this.slotData.phone);
        const result = await this.$http.put(url, form);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.$message.success('重置成功！');
        this.$router.push("/password/success");
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
