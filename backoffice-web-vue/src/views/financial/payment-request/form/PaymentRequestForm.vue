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
      <el-form ref="form" :inline="true" :model="formData" label-position="right" label-width="100px"
        :hide-required-asterisk="true">
        <el-row type="flex" justify="start" align="top" style="padding-left: 10px">
          <el-col :span="7">
            <el-form-item label="付款申请单号">
              <el-input placeholder="系统自动生成" :disabled="true" class="payment-request-input"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="9">
            <template v-if="type === 'PROCESS_COST'">
              <el-form-item label="外发订单" prop="productionOrder"
                :rules="[{type: Object, validator: validateProductionOrder, trigger: 'change'}]">
                <el-input class="payment-request-input" v-model="formData.productionOrder.code" :disabled="true">
                </el-input>
                <el-button @click="saleProdutionVisible = !saleProdutionVisible">选择</el-button>
              </el-form-item>
            </template>
            <template v-else-if="type === 'MATERIALS_COST'">
              <el-form-item label="采购单" prop="productionOrder"
                :rules="[{type: Object, validator: validateProductionOrder, trigger: 'change'}]">
                <el-input class="payment-request-input" v-model="formData.productionOrder.code" :disabled="true">
                </el-input>
                <el-button @click="purchaseVisible = !purchaseVisible">选择</el-button>
              </el-form-item>
            </template>
            <template v-else-if="type === 'OTHER_COST'">
              <el-form-item label="单号" prop="productionOrder" 
                            :rules="[{type: Object, validator: validateProductionOrder, trigger: 'change'}]">
                <el-input class="payment-request-input" v-model="formData.productionOrder.code"></el-input>
              </el-form-item>
            </template>
          </el-col>
          <el-col :span="8">
            <template v-if="type === 'OTHER_COST'">
              <el-form-item label="合同号">
                <el-input class="payment-request-input" v-model="formData.agreementCode"></el-input>
              </el-form-item>
            </template>
            <template v-else>
              <el-form-item label="合同号">
                <el-input class="payment-request-input" :disabled="true" v-model="contactCode"></el-input>
              </el-form-item>
            </template>
          </el-col>
        </el-row>
        <el-row type="flex" justify="start" align="top" style="padding-left: 10px">
          <el-col :span="7">
            <el-form-item label="申请部门">
              <el-input class="payment-request-input" v-model="deptName" :disabled="type !== 'OTHER_COST'"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="9">
            <el-form-item label="申请人">
              <el-input :disabled="true" class="payment-request-input" v-model="currentUser.username"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="付款内容" prop="paymentFor"
              :rules="[{required: true, message: '请填写付款内容', trigger: 'change'}]">
              <el-input class="payment-request-input" v-model="formData.paymentFor"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row type="flex" justify="start" align="top" style="padding-left: 10px">
          <el-col :span="7">
            <el-form-item label="收款对象">
              <el-input :disabled="type !== 'OTHER_COST'" class="payment-request-input" v-model="receiver"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="9">
            <el-form-item label="申请金额" style="margin-bottom: 17px" prop="requestAmount"
              :rules="[{required: true, message: '请填写申请金额', trigger: 'change'}]">
              <el-input class="payment-request-input" v-model="formData.requestAmount" @input="onChange"
                v-number-input.float="{min: 0 ,decimal:2}" @blur="onBlur">
                <span slot="suffix">元</span>
              </el-input>
              <h6 v-if="preApplyAmount !== '' || preApplyAmount === 0" style="color: #909399;margin-bottom: 0px">
                可申请金额{{preApplyAmount}}元</h6>
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
            <el-form-item label="收款人" prop="bankCardAccount"
              :rules="[{required: true, message: '请填写收款人', trigger: 'change'}]">
              <el-input class="payment-request-input" v-model="formData.bankCardAccount"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="9">
            <el-form-item label="收款账号" prop="bankCardNo"
              :rules="[{required: true, message: '请填写收款账号', trigger: 'change'}]">
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
          <el-col :span="24">
            <div style="display: flex;flex-wrap: wrap;">
              <template v-for="(item,itemIndex) in formData.approvers">
                <el-form-item :key="'a'+itemIndex" :label="'审批人'+(itemIndex+1)" style="margin-right:10px;margin-bottom: 10px"
                  :prop="'approvers.' + itemIndex" :rules="[{required: true, message: '不能为空', trigger: 'change'}]">
                  <personnal-selection-v2 :vPerson.sync="formData.approvers[itemIndex]" 
                                          :excludeMySelf="true" style="width: 194px" :selectedRow="formData.approvers"/>
                </el-form-item>
              </template>
              <el-button-group>
                <el-button v-if="formData.approvers && formData.approvers.length < 5" style="height: 32px" @click="appendApprover">+ 添加审批人</el-button>
                <el-button v-if="formData.approvers && formData.approvers.length > 1" style="height: 32px" @click="removeApprover">删除</el-button>
              </el-button-group>
            </div>
          </el-col>
        </el-row>
        <el-row type="flex" justify="start" align="top" style="padding-left: 50px">
          <h6 style="color: #F56C6C">* 审批人将按照你选择的顺序逐级审批</h6>
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
              <images-upload :slotData="formData.requestVouchers" ref="upload"></images-upload>
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <el-row type="flex" justify="center" align="middle">
        <el-button class="create-btn" @click="onConfirm">提交</el-button>
      </el-row>
    </el-card>
    <el-dialog :visible.sync="saleProdutionVisible" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <outbound-order-select-page-v-2 v-if="saleProdutionVisible" @onSelect="onSelect" :singleChoice="true" :customQueryFormData="queryFormData"/>
    </el-dialog>
    <el-dialog :visible.sync="purchaseVisible" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <purchase-order-select-page v-if="purchaseVisible" @setPurchaseOrder="setPurchaseOrder"/>
    </el-dialog>
  </div>
</template>

<script>
  import {
    PersonnelSelection,
    ImagesUpload,
    PersonnalSelectionV2
  } from '@/components'
  import PurchaseOrderSelectPage from '@/views/purchase/order/components/PurchaseOrderSelectPage'
  import OutboundOrderSelectPageV2 from '@/views/order/salesProduction/outbound-order/components/OutboundOrderSelectPageV2.vue'
  export default {
    name: 'PaymentRequestForm',
    props: {
      orderData: {
        type: Object
      },
      requestData: {
        type: Object
      },
      type: {
        type: String,
        default: 'PROCESS_COST'
      }
    },
    components: {
      PersonnelSelection,
      ImagesUpload,
      PersonnalSelectionV2,
      PurchaseOrderSelectPage,
      OutboundOrderSelectPageV2
    },
    computed: {

    },
    methods: {
      async countRequestAmount(id) {
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
      parseFloatNotParNaN(data) {
        if (isNaN(parseFloat(data))) {
          return 0;
        } else {
          return parseFloat(data);
        }
      },
      onSelect(selection) {
        let row = selection[0];

        this.saleProdutionVisible = false;
        this.formData.productionOrder.id = row.id;
        this.formData.productionOrder.code = row.code;
        this.receiver = row.targetCooperator.type == 'ONLINE' ? row.targetCooperator.partner.name : row.targetCooperator
          .name;
        this.formData.bankCardAccount =
          row.targetCooperator.type == 'ONLINE' ? row.targetCooperator.partner.contactPerson : row.targetCooperator
          .contactPerson;
        this.formData.bankCardNo = row.targetCooperator.bankAccount;
        this.formData.bank = row.targetCooperator.bankOfDeposit;
        row.agreements.forEach((item, index) => {
          if (item.state !== 'INVALID') {
            this.contactCode += item.code;
            if (!(index == row.agreements.length - 1)) {
              this.contactCode += ', ';
            }
          }
        })
        this.deptName = row.merchandiser.b2bDept ? row.merchandiser.b2bDept.name : '';
        this.countRequestAmount(row.id);
      },
      setPurchaseOrder (row) {
        this.purchaseVisible = false;
        this.formData.productionOrder = {
          id: row.id,
          code: row.code
        }
        if (row.cooperator) {
          this.receiver = row.cooperator.type == 'ONLINE' ? row.cooperator.partner.name : row.cooperator.name;
          this.formData.bankCardAccount =
            row.cooperator.type == 'ONLINE' ? row.cooperator.partner.contactPerson : row.cooperator.contactPerson;
          this.formData.bankCardNo = row.cooperator.bankAccount;
          this.formData.bank = row.cooperator.bankOfDeposit;
        } else {
          this.receiver = row.cooperatorName;
        }

        if (row.attachAgreements && row.attachAgreements.length > 0) {
          row.attachAgreements.forEach(item => {
            if (item.name.lastIndexOf('.') > -1) {
              this.contactCode += item.name.substring(0, item.name.lastIndexOf('.'));
            }
          })
        }
      },
      appendApprover () {
        this.formData.approvers.push({});
      },
      removeApprover () {
        this.formData.approvers.splice(this.formData.approvers.length - 1, 1);
      },
      validateField(name) {
        this.$refs.form.validateField(name);
      },
      validateProductionOrder(rule, value, callback) {
        if (value.code != undefined && value.code != '') {
          callback();
        } else {
          callback(new Error('请选择订单'));
        }
      },
      validateAppeovers(rule, value, callback) {
        if (value[0].name != undefined && value[0].name != '') {
          callback();
        } else {
          callback(new Error('请选择审批人'));
        }
      },
      onConfirm() {
        if (this.$refs.upload.isUploading()) {
          this.$message.error('请等待图片上传完毕');
          return null;
        };

        this.$refs.form.validate((valid) => {
          if (valid) {
            this._onConfirm();
          } else {
            this.$message.error('请完善表单信息！');
            return false;
          }
        });
      },
      async _onConfirm() {
        let data = Object.assign({}, this.formData);
        this.$delete(data, 'productionOrder');
        if (this.type === 'PROCESS_COST' || this.type === 'MATERIALS_COST') {
          this.$set(data, 'order', {
            id: this.formData.productionOrder.id
          })
        } else {
          this.$set(data, 'orderCode', this.formData.productionOrder.code)
        }
        // 人员设置数据处理
        data.approvers = [];
        this.formData.approvers.forEach(item => {
          if (item instanceof Array && item.length > 0) {
            data.approvers.push({
              id: item[item.length - 1]
            });
          }
        })
        this.$set(data, 'type', this.type);

        const url = this.apis().appendPaymentRequest();
        const result = await this.$http.post(url, data, {
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
        if (this.requestData != null) {
          this.$router.go(-2);
        } else {
          this.$router.go(-1);
        }
      },
      onChange(val) {
        this.chineseAmount = this.convertCurrency(this.formData.requestAmount);
      },
      onBlur() {
        var reg = /\.$/;
        if (reg.test(this.formData.requestAmount)) {
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
        if (money == '') {
          return '';
        }
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
      },
      initData () {
        this.receiver = this.requestData.payable.name;
        this.formData = {
          requestAmount: this.requestData.requestAmount,
          paymentFor: this.requestData.paymentFor,
          bankCardAccount: this.requestData.bankCardAccount,
          bankCardNo: this.requestData.bankCardNo,
          bank: this.requestData.bank,
          productionOrder: {
            id: this.requestData.productionOrder.id,
            code: this.requestData.productionOrder.code
          },
          approvers: this.requestData.approvers,
          remark: this.requestData.remark,
          requestVouchers: this.requestData.requestVouchers ? this.requestData.requestVouchers : [] 
        },
        this.deptName = this.requestData.applyUser.b2bDept ? this.requestData.applyUser.b2bDept.name : '';
        this.onChange(this.requestData.requestAmount);
        this.countRequestAmount(this.requestData.productionOrder.id);
      }
    },
    data() {
      return {
        preApplyAmount: '',
        contactCode: '',
        saleProdutionVisible: false,
        purchaseVisible: false,
        currentUser: this.$store.getters.currentUser,
        receiver: '',
        chineseAmount: '',
        formData: {
          agreementCode: '',
          requestAmount: '',
          paymentFor: '',
          bankCardAccount: '',
          bankCardNo: '',
          bank: '',
          productionOrder: {
            id: null,
            name: ''
          },
          approvers: [null],
          remark: '',
          requestVouchers: []
        },
        deptName: '',
        queryFormData: {
          keyword: '',
          targetCooperator: '',
          merchandiser: '',
          state: 'AUDIT_PASSED',
          name: '',
          merchandiserPk: 'isMyself'
        },
      }
    },
    watch: {
      'formData.productionOrder': function (nval, oval) {
        this.validateField('productionOrder');
      },
      'formData.approvers': function (nval, oval) {
        this.formData.approvers.forEach((item, index) => {
          this.validateField('approvers.' + index);
        })
      }
    },
    created() {
      if (this.orderData != null) {
        if (this.type === 'PROCESS_COST') {
          this.setSelectOrder(this.orderData);
        } else if (this.type === 'MATERIALS_COST') {
          this.setPurchaseOrder(this.orderData);
        }
      } else if (this.requestData != null) {
        this.initData();
      }
    },
    mounted() {
      this.$nextTick(() => {
        this.$refs.form.clearValidate();
      });
    },
    destroyed() {

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

  .payment-request-container>>>.el-upload--picture-card {
    width: 100px;
    height: 100px;
    line-height: 100px;
  }

  .payment-request-container>>>.el-upload-list--picture-card .el-upload-list__item {
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
