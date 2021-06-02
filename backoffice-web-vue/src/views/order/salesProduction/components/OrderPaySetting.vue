<!--
* @Description: 外接/外发 订单 支付设置
* @Date 2021/06/01 18:23
* @Author L.G.Y
-->
<template>
  <el-form ref="form" :model="formData" class="order-pay-setting" label-width="80px">
    <div class="pay-container">
      <el-form-item label="支付类型">
        <el-radio :label="true" v-model="formData.payOnline">线上支付</el-radio>
        <el-radio :label="false" v-model="formData.payOnline">线下支付</el-radio>
      </el-form-item>
      <!-- 线上支付 且 登录账号为代运营账号 需要填写扣除比例 -->
      <template v-if="currentUser.agent && formData.payOnline">
        <el-form-item label="服务费用扣除比列" label-width="140px" prop="serviceFeePercent" 
                      :rules="[{required: true, validator: checkServiceFeePercent, tigger: 'change'}]">
          <el-input v-model="formData.serviceFeePercent" @blur="onBlur" v-number-input.float="{ min: 0 , decimal:4, max: 100}">
            <span slot="suffix">%</span>
          </el-input>
        </el-form-item>
      </template>
    </div>
    <collapse-transition>
      <div class="collapse-wrap" v-show="formData.payOnline">
        <el-row type="flex" style="margin-left: 25px;">
          <el-radio-group v-model="formData.paymentAccount.type">
            <!-- <el-radio v-for="item in payType" :key="item.code" :label="item.code">{{item.name}}</el-radio> -->
            <el-radio label="BANK" key="BANK">银行卡</el-radio>
          </el-radio-group>
        </el-row>
        <collapse-transition>
          <div class="collapse-wrap" v-show="formData.paymentAccount.type === 'BANK'">
            <el-form-item label="姓名" prop="paymentAccount.name" :rules="[{required: formData.payOnline, message: '必填', tigger: 'change'}]">
              <el-input v-model="formData.paymentAccount.name" placeholder=""></el-input>
            </el-form-item>
            <el-form-item label="开户行" prop="paymentAccount.serviceProvider" :rules="[{required: formData.payOnline, message: '必填', tigger: 'change'}]">
              <el-input v-model="formData.paymentAccount.serviceProvider" placeholder=""></el-input>
            </el-form-item>
            <el-form-item label="卡号" prop="paymentAccount.no" :rules="[{required: formData.payOnline, message: '必填', tigger: 'change'}]">
              <el-input v-model="formData.paymentAccount.no" placeholder=""></el-input>
            </el-form-item>
          </div>
        </collapse-transition>
      </div> 
    </collapse-transition>
  </el-form>
</template>

<script>
import CollapseTransition from '@/views/user/company/components/collapseTransition.js'

export default {
  name: 'OrderPaySetting',
  components: { CollapseTransition },
  props: ['formData'],
  methods: {
    onBlur() {
      var reg = /\.$/;
      if (reg.test(this.formData.serviceFeePercent)) {
        this.formData.serviceFeePercent = Number.parseInt(this.formData.serviceFeePercent);
      }
    },
    checkServiceFeePercent (rule, value, callback) {
      if (value) {
        callback();
      } else {
        callback(new Error('请输入'));
      }
    }
  },
  data () {
    return {
      currentUser: this.$store.getters.currentUser,
      payType: this.$store.state.EnumsModule['PayType']
    }
  },
  created () {
    if (!this.formData.payOnline) {
      this.$set(this.formData, 'payOnline', false);
    }
    if (!this.formData.paymentAccount) {
      this.$set(this.formData, 'paymentAccount', {
        name: '',
        serviceProvider: '',
        no: '',
        type: 'BANK'
      });
    }
  }
}
</script>

<style scoped>
.order-pay-setting {
  margin-left: 30px;
}

.order-pay-setting >>> .el-input__suffix {
    right: 5px;
}

.pay-container {
  display: flex;
  flex-wrap: wrap;
}
</style>