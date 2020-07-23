<template>
  <div class="animated fadeIn content payment-request-container">
    <el-card>
      <el-row>
        <el-col :span="4">
          <div class="financial-list-title">
            <h6>创建付款申请单</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <el-form ref="form" :inline="true" :model="formData" label-position="right" label-width="100px" :hide-required-asterisk="true">
        <el-row type="flex" justify="start" align="top" style="padding-left: 10px">
          <el-col :span="7">
            <el-form-item label="付款申请单号">
              <el-input placeholder="系统自动生成" :disabled="true" class="payment-request-input"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="9">
            <el-form-item label="订单号" prop="productionOrder" :rules="[{type: Object, validator: validateProductionOrder, trigger: 'change'}]">
              <el-input class="payment-request-input" v-model="formData.productionOrder.code" :disabled="true"></el-input>
              <el-button @click="saleProdutionVisible = !saleProdutionVisible">选择</el-button>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="合同号">
              <el-input class="payment-request-input" :disabled="true" v-model="contactCode"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row type="flex" justify="start" align="top" style="padding-left: 10px">
          <el-col :span="7">
            <el-form-item label="申请部门">
              <el-input class="payment-request-input" :disabled="true"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="9">
            <el-form-item label="申请人">
              <el-input :disabled="true" class="payment-request-input" v-model="currentUser.username"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="付款内容" prop="paymentFor" :rules="[{required: true, message: '请填写付款内容', trigger: 'change'}]">
              <el-input class="payment-request-input" v-model="formData.paymentFor"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row type="flex" justify="start" align="top" style="padding-left: 10px">
          <el-col :span="7">
            <el-form-item label="收款对象">
              <el-input :disabled="true" class="payment-request-input" v-model="receiver"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="9">
            <el-form-item label="申请金额" style="margin-bottom: 17px" prop="requestAmount" 
              :rules="[{required: true, message: '请填写申请金额', trigger: 'change'}]">
              <el-input class="payment-request-input" v-model="formData.requestAmount" @input="onChange" 
                v-number-input.float="{min: 0 ,decimal:2}" @blur="onBlur">
                <span slot="suffix">元</span>
              </el-input>
              <h6 v-if="preApplyAmount !== '' || preApplyAmount === 0" style="color: #909399;margin-bottom: 0px">可申请金额{{preApplyAmount}}元</h6>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="金额大写">
              <el-input :disabled="true" class="payment-request-input" v-model="chineseAmount"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row type="flex" justify="start" align="top" style="padding-left: 10px">
          <el-col :span="7">
            <el-form-item label="收款人" prop="bankCardAccount" :rules="[{required: true, message: '请填写收款人', trigger: 'change'}]">
              <el-input class="payment-request-input" v-model="formData.bankCardAccount"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="9">
            <el-form-item label="收款账号" prop="bankCardNo" :rules="[{required: true, message: '请填写收款账号', trigger: 'change'}]">
              <el-input class="payment-request-input" v-model="formData.bankCardNo"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="开户行" prop="bank" :rules="[{required: true, message: '请填写开户行', trigger: 'change'}]">
              <el-input class="payment-request-input" v-model="formData.bank"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row type="flex" justify="start" align="top" style="padding-left: 10px">
          <template v-for="(item, index) in formData.approvers">
            <el-col :span="7" :key="index">
              <el-form-item label="审批人" prop="approvers" :rules="[{type: Array, validator: validateAppeovers, trigger: 'change'}]">
                <personnel-selection :vPerson.sync="formData.approvers[index]"/>
              </el-form-item>
            </el-col>
          </template>
          <el-col :span="2">
            <el-button @click="addApprover" v-if="formData.approvers.length < 2">+ 添加审核员</el-button>
          </el-col>
        </el-row>
        <el-row type="flex" justify="start" align="top" style="padding-left: 10px">
          <el-col :span="21">
            <el-form-item label="备注" style="margin-bottom: 0px"></el-form-item>
            <el-input type="textarea" style="margin-left: 100px;" v-model="formData.remark"></el-input>
          </el-col>
        </el-row>
        <el-row type="flex" justify="start" align="middle" style="margin-top: 20px;padding-left: 10px">
          <el-col :span="24">
            <el-form-item label="上传凭证">
              <images-upload :slotData="formData.requestVouchers"></images-upload>
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <el-row type="flex" justify="center" align="middle">
        <el-button class="create-btn" @click="onConfirm">提交</el-button>
      </el-row>
    </el-card>
    <el-dialog :visible.sync="saleProdutionVisible" width="80%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <outbound-order-select-page v-if="saleProdutionVisible" @setSelectOrder="setSelectOrder" />
    </el-dialog>
  </div>
</template>

<script>
  import {PersonnelSelection, ImagesUpload} from '@/components/index.js'
  import {OutboundOrderSelectPage} from '@/views/order/salesProduction/outbound-order/index.js'
  export default {
    name: 'PaymentRequestForm',
    props: {

    },
    components: {
      PersonnelSelection,
      ImagesUpload,
      OutboundOrderSelectPage
    },
    computed: {

    },
    methods: {
      async countRequestAmount (id) {
        const url = this.apis().getRequestAmount(id);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        this.preApplyAmount = this.parseFloatNotParNaN(result.data.amount) - 
                              this.parseFloatNotParNaN(result.data.paidAmount);
      },
      parseFloatNotParNaN (data) {
        if (isNaN(parseFloat(data))) {
          return 0;
        } else {
          return parseFloat(data);
        }
      },
      setSelectOrder (row) {
        this.saleProdutionVisible = !this.saleProdutionVisible;
        this.formData.productionOrder.id = row.id;
        this.formData.productionOrder.code = row.code;
        this.receiver = row.targetCooperator.type == 'ONLINE' ? row.targetCooperator.partner.name : row.targetCooperator.name;
        row.agreements.forEach((item, index) => {
          this.contactCode += item.code;
          if (!(index == row.agreements.length - 1)) {
            this.contactCode += ', ';
          }
        })
        this.countRequestAmount(row.id);
      },
      addApprover () {
        this.formData.approvers.push({});
        this.$nextTick(() => {
          this.$refs.form.clearValidate();
        })
      },
      validateField (name) {
        this.$refs.form.validateField(name);
      },
      validateProductionOrder (rule, value, callback) {
        if (value.code != undefined && value.code != '') {
          callback();
        } else {
          callback(new Error('请选择订单'));
        }
      },
      validateAppeovers (rule, value, callback) {
        if (value[0].name != undefined && value[0].name != '') {
          callback();
        } else {
          callback(new Error('请选择审批人'));
        }
      },
      onConfirm () {
        this.$refs.form.validate((valid) => {
          if (valid) {
            this._onConfirm();
          } else {
            this.$message.error('请完善表单信息！');
            return false;
          }
        });
      },
      async _onConfirm () {
        const url = this.apis().appendPaymentRequest();
        const result = await this.$http.post(url, this.formData, {
          submit: true
        });
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        this.$message.success('创建付款申请单成功');
        this.$router.go(-1);
      },
      onChange (val) {
        // if (this.preApplyAmount == '') {
        //   return;
        // }
        // if (this.parseFloatNotParNaN(val) > this.parseFloatNotParNaN(this.preApplyAmount)) {
        //   this.formData.requestAmount = this.preApplyAmount + '';
        // }
        this.chineseAmount = this.convertCurrency(this.formData.requestAmount);
      },
      onBlur () {
        var reg = /\.$/;
        if (reg.test(this.formData.requestAmount)) {
          // this.$set(row, attribute, parseFloat(row[attribute] + '00'));
          this.formData.requestAmount = this.parseFloatNotParNaN(this.formData.requestAmount);
        }
      },
      // 金额大写转换
      convertCurrency(money) {
        //汉字的数字
        var cnNums = new Array('零', '壹', '贰', '叁', '肆', '伍', '陆', '柒', '捌', '玖');
        //基本单位
        var cnIntRadice = new Array('', '拾', '佰', '仟');
        //对应整数部分扩展单位
        var cnIntUnits = new Array('', '万', '亿', '兆');
        //对应小数部分单位
        var cnDecUnits = new Array('角', '分', '毫', '厘');
        //整数金额时后面跟的字符
        var cnInteger = '整';
        //整型完以后的单位
        var cnIntLast = '元';
        //最大处理的数字
        var maxNum = 999999999999999.9999;
        //金额整数部分
        var integerNum;
        //金额小数部分
        var decimalNum;
        //输出的中文金额字符串
        var chineseStr = '';
        //分离金额后用的数组，预定义
        var parts;
        if (money == '') { return ''; }
        money = parseFloat(money);
        if (money >= maxNum) {
          //超出最大处理数字
          return '';
        }
        if (money == 0) {
          chineseStr = cnNums[0] + cnIntLast + cnInteger;
          return chineseStr;
        }
        //转换为字符串
        money = money.toString();
        if (money.indexOf('.') == -1) {
          integerNum = money;
          decimalNum = '';
        } else {
          parts = money.split('.');
          integerNum = parts[0];
          decimalNum = parts[1].substr(0, 4);
        }
        //获取整型部分转换
        if (parseInt(integerNum, 10) > 0) {
          var zeroCount = 0;
          var IntLen = integerNum.length;
          for (var i = 0; i < IntLen; i++) {
            var n = integerNum.substr(i, 1);
            var p = IntLen - i - 1;
            var q = p / 4;
            var m = p % 4;
            if (n == '0') {
              zeroCount++;
            } else {
              if (zeroCount > 0) {
                chineseStr += cnNums[0];
              }
              //归零
              zeroCount = 0;
              chineseStr += cnNums[parseInt(n)] + cnIntRadice[m];
            }
            if (m == 0 && zeroCount < 4) {
              chineseStr += cnIntUnits[q];
            }
          }
          chineseStr += cnIntLast;
        }
        //小数部分
        if (decimalNum != '') {
          var decLen = decimalNum.length;
          for (var i = 0; i < decLen; i++) {
            var n = decimalNum.substr(i, 1);
            if (n != '0') {
              chineseStr += cnNums[Number(n)] + cnDecUnits[i];
            }
          }
        }
        if (chineseStr == '') {
          chineseStr += cnNums[0] + cnIntLast + cnInteger;
        } else if (decimalNum == '') {
          chineseStr += cnInteger;
        }
        return chineseStr;
      }               
    },
    data () {
      return {
        preApplyAmount: '',
        contactCode: '',
        saleProdutionVisible: false,
        currentUser: this.$store.getters.currentUser,
        receiver: '',
        chineseAmount: '',
        formData: {
          requestAmount: '',
          paymentFor: '',
          bankCardAccount: '',
          bankCardNo: '',
          bank: '',
          productionOrder: {
            id: null,
            name: ''
          },
          approvers: [{
            id: null,
            name: ''
          }],
          remark: '',
          requestVouchers: []
        }
      }
    },
    watch: {
      'formData.productionOrder': function (nval, oval) {
        this.validateField('productionOrder');
      },
      'formData.approvers': function (nval, oval) {
        this.validateField('approvers');
      }
    },
    created () {
      this.$nextTick(() => {
        this.$refs.form.clearValidate();
      })
    },
    destroyed () {
      
    }
  }
</script>

<style scoped>
  .financial-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .payment-request-input {
    width: 194px;
  }

  .payment-request-container >>> .el-upload--picture-card {
    width: 100px;
    height: 100px;
    line-height: 100px;
  }

  .payment-request-container >>> .el-upload-list--picture-card .el-upload-list__item {
    width: 100px;
    height: 100px;
  }

  .create-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    width: 120px;
    height: 40px;
    border-radius: 10px;
  }
</style>