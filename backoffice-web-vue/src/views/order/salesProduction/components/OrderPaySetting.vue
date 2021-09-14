<!--
* @Description: 外接/外发 订单 支付设置
* @Date 2021/06/01 18:23
* @Author L.G.Y
-->
<template>
  <el-form ref="form" :model="formData" class="order-pay-setting" label-width="140px" hide-required-asterisk>
    <el-form-item label="支付类型" label-width="80px">
      <el-radio-group v-model="formData.payOnline" :disabled="readOnly">
        <el-radio :label="true" >线上支付</el-radio>
        <el-radio :label="false" >线下支付</el-radio>
      </el-radio-group>
    </el-form-item>
    <!-- 外接订单才需要填写以下信息 -->
    <template v-if="from === 'SALES_ORDER'">
      <!-- 线上支付 且 登录账号为代运营账号 需要填写扣除比例 -->
      <template v-if="currentUser.agent && formData.payOnline">
        <el-form-item label="服务费用扣除比列" prop="serviceFeePercent" 
                      :rules="[{required: true, validator: checkServiceFeePercent, tigger: 'change'}]">
          <el-input v-model="formData.serviceFeePercent" 
                    @blur="onBlur" 
                    v-number-input.float="{ min: 0 , decimal:4, max: 100}" style="width: 100px">
            <span slot="suffix">%</span>
          </el-input>
        </el-form-item>
      </template>
      <collapse-transition>
        <div class="collapse-wrap" v-show="formData.payOnline">
          <el-row type="flex">
            <el-form-item label="付款方式">
              <el-radio-group v-model="formData.paymentAccount.type">
                <!-- <el-radio v-for="item in payType" :key="item.code" :label="item.code">{{item.name}}</el-radio> -->
                <el-radio label="BANK" key="BANK">银行卡</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-row>
          <collapse-transition>
            <div class="collapse-wrap" v-show="formData.paymentAccount.type === 'BANK'">
              <el-form-item label="收款方姓名" prop="paymentAccount.name">
                <!-- :rules="[{required: formData.payOnline && formData.paymentAccount.type === 'BANK', message: '必填', tigger: 'change'}]"> -->
                <el-input v-model="formData.paymentAccount.name" style="width: 300px"></el-input>
              </el-form-item>
              <el-form-item label="收款方开户行" prop="paymentAccount.serviceProvider">
                <!-- :rules="[{required: formData.payOnline && formData.paymentAccount.type === 'BANK', message: '必填', tigger: 'change'}]"> -->
                <el-input v-model="formData.paymentAccount.serviceProvider" style="width: 300px"></el-input>
              </el-form-item>
              <el-form-item label="收款方卡号" prop="paymentAccount.no">
                <!-- :rules="[{required: formData.payOnline && formData.paymentAccount.type === 'BANK', message: '必填', tigger: 'change'}]"> -->
                <el-input v-model="formData.paymentAccount.no" style="width: 300px"></el-input>
              </el-form-item>
            </div>
          </collapse-transition>
          <collapse-transition>
            <div class="collapse-wrap" v-show="formData.paymentAccount.type === 'WECHAT'">
              <el-form-item label="收款方姓名" prop="paymentAccount.name">
                <el-input v-model="formData.paymentAccount.name" style="width: 300px"></el-input>
              </el-form-item>
              <el-form-item label="收款方开户行" prop="paymentAccount.serviceProvider">
                <el-input v-model="formData.paymentAccount.serviceProvider" style="width: 300px"></el-input>
              </el-form-item>
              <el-form-item label="收款方卡号" prop="paymentAccount.no">
                <el-input v-model="formData.paymentAccount.no" style="width: 300px"></el-input>
              </el-form-item>
            </div>
          </collapse-transition>
        </div> 
      </collapse-transition>
    </template>
  </el-form>
</template>

<script>
import CollapseTransition from '@/views/user/company/components/collapseTransition.js'

export default {
  name: 'OrderPaySetting',
  components: { CollapseTransition },
  props: ['formData', 'from', 'readOnly'],
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
    if (!this.formData.paymentAccount && this.from === 'SALES_ORDER') {
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