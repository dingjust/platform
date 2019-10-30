<template>
  <div class="register-form-container">
    <el-dialog :visible.sync="serviceProtocolVisible">
      <service-protocol />
    </el-dialog>
    <el-dialog :visible.sync="paymentProtocolVisible">
      <payment-protocol />
    </el-dialog>
    <el-row type="flex" justify="center">
      <el-col :span="16">
        <el-form ref="form" :model="slotData" label-width="80px">
          <el-form-item label="手机">
            <el-input v-model="slotData.phone">
              <template slot="prepend">+86</template>
            </el-input>
          </el-form-item>
          <el-form-item label="验证码">
            <el-input v-model="slotData.code">
              <el-button slot="append">发送验证码</el-button>
            </el-input>
          </el-form-item>
          <el-form-item label="会员名">
            <el-input v-model="slotData.name"></el-input>
          </el-form-item>
          <el-form-item label="密码">
            <el-input v-model="slotData.password" type="password"></el-input>
          </el-form-item>
          <el-form-item label="确认密码">
            <el-input v-model="slotData.againPassword" type="password">
              <i class="el-icon-success icon-success" slot="suffix" v-if="showSuccess"></i>
              <i class="el-icon-error icon-error" slot="suffix" v-if="showError"></i>
            </el-input>
          </el-form-item>
          <el-form-item label="公司名称">
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
              <el-button class="register-btn" @click="onSubmit">注册</el-button>
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
      return {
        checked: false,
        serviceProtocolVisible: false,
        paymentProtocolVisible: false
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
      onSubmit() {
        console.log(this.slotData);
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

  .icon-success {
    color: #7AED8F;
    font-size: 18px;
  }

  .icon-error {
    color: red;
    font-size: 18px;
  }

</style>
