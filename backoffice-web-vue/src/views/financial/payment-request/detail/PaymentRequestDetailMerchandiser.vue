<template>
  <div class="animated fadeIn content payment-request-container">
    <el-card>
      <div class="financial-plan-triangle_box">
        <div class="financial-plan-triangle" :style="getTriangleColor">
          <h6 class="financial-plan-triangle_text">{{auditState}}</h6>
        </div>
      </div>
      <el-row type="flex" justify="space-between">
        <el-col :span="4">
          <div class="financial-list-title">
            <h6>付款申请单</h6>
          </div>
        </el-col>
        <el-col :span="6">
          <h6 style="color: #F56C6C" v-if="showTips">申请金额超过未付款金额</h6>
        </el-col>
        <el-col :span="4">
          <h6>创建时间：{{formData.creationtime | timestampToTime}}</h6>
        </el-col>
        <el-col :span="4">
          <h6>状态：{{getEnum('PaymentRequestState', formData.state)}}</h6>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <el-row type="flex" justify="center">
        <el-col :span="22">
          <el-row type="flex" justify="start" align="middle" style="margin-bottom: 15px">
            <el-col :span="8">
              <h6>申请单号：{{formData.code}}</h6>
            </el-col>
            <el-col :span="8">
              <h6>订单号：{{formData.productionOrder.code}}</h6>
            </el-col>
            <el-col :span="8">
              <h6>合同号：
                <template v-for="item in agreementsCode">
                  <el-button type="text" :key="item.code" @click="openPreviewPdf(item)">{{item.code}}</el-button>
                </template>
              </h6>
            </el-col>
          </el-row>
          <el-row type="flex" justify="start" align="middle" style="margin-bottom: 15px">
            <el-col :span="8">
              <h6>申请部门：</h6>
            </el-col>
            <el-col :span="8">
              <h6>申请人：{{formData.applyUser.name}}</h6>
            </el-col>
            <el-col :span="8">
              <h6>付款内容：{{formData.paymentFor}}</h6>
            </el-col>
          </el-row>
          <el-row type="flex" justify="start" align="middle" style="margin-bottom: 15px">
            <el-col :span="8">
              <h6>收款对象：{{formData.payable.name}}</h6>
            </el-col>
            <el-col :span="8">
              <h6>申请金额：{{formData.requestAmount}}元</h6>
            </el-col>
            <el-col :span="8">
              <h6>金额大写：{{convertCurrency(formData.requestAmount)}}</h6>
            </el-col>
          </el-row>
          <el-row type="flex" justify="start" align="middle" style="margin-bottom: 15px">
            <el-col :span="8">
              <h6>收款人：{{formData.bankCardAccount}}</h6>
            </el-col>
            <el-col :span="8">
              <h6>收款账号：{{formData.bankCardNo}}</h6>
            </el-col>
            <el-col :span="8">
              <h6>开户行：{{formData.bank}}</h6>
            </el-col>
          </el-row>
          <!-- <el-row type="flex" justify="start" align="middle" style="margin-bottom: 15px">
            <el-col :span="8">
              <h6>审批人：{{approvers}}</h6>
            </el-col>
          </el-row> -->
          <el-row type="flex" justify="start" align="middle" style="margin-bottom: 15px">
            <el-col :span="8">
              <h6>备注：{{formData.remark}}</h6>
            </el-col>
          </el-row>
          <el-row type="flex" justify="start" align="middle" style="margin-top: 20px">
            <el-col :span="24">
              <h6>上传凭证：</h6>
              <el-row style="margin-left: 20px" v-if="formData.requestVouchers && formData.requestVouchers.length > 0">
                <images-upload :slotData="formData.requestVouchers" :limit="formData.requestVouchers.length"
                  :disabled="true" />
              </el-row>
            </el-col>
          </el-row>
        </el-col>
      </el-row>
      <template v-if="formData.currentAuditWork && formData.currentAuditWork.processes && formData.currentAuditWork.processes.length > 0">
        <el-row type="flex" justify="center">
          <el-col :span="22">
            <order-audit-detail style="padding-left: 10px" :processes="formData.currentAuditWork.processes" />
          </el-col>
        </el-row>
      </template>
      <el-row type="flex" justify="center" v-if="formData.state === 'PAID'">
        <el-col :span="23">
          <payment-records-list :formData="formData" :tableData="[formData.paymentRecords]" />
        </el-col>
      </el-row>
      <el-row type="flex" justify="space-around" style="margin-top: 20px" :gutter="50" v-if="canAudit">
        <el-col :span="3">
          <authorized :permission="['DO_AUDIT']">
            <el-button class="material-btn_red" @click="onApproval(false)">审核拒绝</el-button>
          </authorized>
        </el-col>
        <el-col :span="3">
          <authorized :permission="['DO_AUDIT']">
            <el-button class="material-btn" @click="onApproval(true)">审核通过</el-button>
          </authorized>
        </el-col>
      </el-row>
      <el-row type="flex" justify="space-around" style="margin-top: 20px" :gutter="50" v-if="formData.state === 'AUDIT_FAIL'">
        <el-col :span="3">
          <authorized :permission="['DO_AUDIT']">
            <el-button class="material-btn" @click="onReapply">重新申请</el-button>
          </authorized>
        </el-col>
      </el-row>
    </el-card>
    <el-dialog :visible.sync="paymentVisible" width="50%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <payment-form v-if="paymentVisible" :id="id" @callback="callback" />
    </el-dialog>
    <el-dialog :visible.sync="pdfVisible" :show-close="true" width="80%" style="width: 100%" append-to-body
      :close-on-click-modal="false">
      <pdf-preview v-if="pdfVisible" :fileUrl="fileUrl" />
    </el-dialog>
  </div>
</template>

<script>
  import {
    PersonnelSelection,
    ImagesUpload,
    PdfPreview
  } from '@/components/index.js'
  import {
    PaymentRecordsList
  } from '@/views/financial'
  import PaymentForm from '../form/PaymentForm'
  import {
    OrderAuditDetail
  } from '@/views/order/salesProduction/components/'
  export default {
    name: 'PaymentRequestDetailMerchandiser',
    props: ['id'],
    components: {
      PersonnelSelection,
      ImagesUpload,
      PaymentForm,
      PaymentRecordsList,
      PdfPreview,
      OrderAuditDetail
    },
    computed: {
      canAudit: function () {
        const uid = this.$store.getters.currentUser.uid;
        if (this.formData.approvers && this.formData.approvers.length > 0) {
          let flag = this.formData.approvers.some(item => item.uid === uid);
          console.log(flag);
          if (this.formData.currentAuditWork) {
            return this.formData.currentAuditWork.currentUserAuditState === 'AUDITING' && flag;
          } else {
            return false;
          }
        }
      },
      agreementsCode: function () {
        let arr = [];
        if (!this.formData.productionOrder.agreements && this.formData.productionOrder.agreements.length <= 0) {
          return [];
        }
        return this.formData.productionOrder.agreements.filter(item => item.state !== 'INVALID');
      },
      auditState: function () {
        switch (this.formData.state) {
          case 'AUDITING':
            return '待审核';
          case 'AUDIT_FAIL':
            return '已驳回';
          default:
            return '已审核';
        }
      },
      getTriangleColor: function () {
        switch (this.formData.state) {
          case 'AUDITING':
            return 'border-right: 70px solid #114EE8;';
          case 'AUDIT_FAIL':
            return 'border-right: 70px solid #D91A17;';
          default:
            return 'border-right: 70px solid #4DE811;';
        }
      },
      approvers: function () {
        let str = '';
        if (this.formData.approvers && this.formData.approvers.length > 0) {
          str += this.formData.approvers[0].name;
          if (this.formData.approvers.length > 1) {
            str = str + ',' + this.formData.approvers[1].name;
          }
        }
        return str;
      },
      isFinance: function () {
        return true;
      },
      canPay: function () {
        return this.formData.state === 'WAIT_TO_PAY';
      },
      showTips: function () {
        if (this.preApplyAmount != '') {
          return this.formData.requestAmount > this.preApplyAmount;
        }
        return false;
      }
    },
    methods: {
      async getDetail() {
        const url = this.apis().getPaymentRequestDetail(this.id);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        this.formData = result.data;
        this.countRequestAmount(result.data.productionOrder.id);
      },
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
      callback() {
        this.paymentVisible = !this.paymentVisible;
        this.getDetail();
      },
      async openPreviewPdf(item) {
        const url = this.apis().downContract(item.code);
        const result = await this.$http.get(url);

        const aa = '/b2b/user/agreement/download/' + result.data;
        this.fileUrl = 'static/pdf/web/viewer.html?file=' + encodeURIComponent(aa)

        this.pdfVisible = true;
      },
      onApproval(isPass) {
        if (this.formData.currentAuditWork.auditingUser.uid === this.$store.getters.currentUser.uid &&
          this.formData.currentAuditWork.currentUserAuditState === 'AUDITING') {
          if (isPass) {
            this.$confirm('是否确认审核通过?', '提示', {
              confirmButtonText: '确定',
              cancelButtonText: '取消',
              type: 'warning'
            }).then(() => {
              this._onApproval(isPass, '');
            });
          } else {
            this.$prompt('请输入不通过原因', '提示', {
              confirmButtonText: '确定',
              cancelButtonText: '取消',
            }).then(({
              value
            }) => {
              this._onApproval(isPass, value);
            }).catch(() => {
              //TODO:取消操作
            });
          }
        } else if (this.formData.currentAuditWork.currentUserAuditState === 'AUDITING' &&
          this.formData.currentAuditWork.auditingUser.uid !== this.$store.getters.currentUser.uid) {
          this.$message.warning('此订单暂未轮到您进行审批。')
        } else if (this.formData.currentAuditWork.currentUserAuditState === 'PASSED') {
          this.$message.warning('您已对此订单进行了审批。');
        }
      },
      async _onApproval(isPass, auditMsg) {
        let formData = {
          id: this.formData.currentAuditWork.id,
          auditMsg: auditMsg,
          state: isPass ? 'PASSED' : 'AUDITED_FAILED'
        };
        const url = this.apis().taskAudit();
        const result = await this.$http.post(url, formData);
        if (result.code == 0) {
          this.$message.error(result.msg);
          return
        }
        this.$message.success('审批成功');
        this.getDetail();
      },
      onReapply () {
        this.$router.push({
          name: '创建付款申请单',
          params: {
            requestData: this.formData
          }
        });
      },
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
        if (money === '') {
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
      }
    },
    data() {
      return {
        paymentVisible: false,
        preApplyAmount: '',
        formData: {
          productionOrder: {
            code: '',
            agreements: []
          },
          requestAmount: '',
          applyUser: {
            name: ''
          },
          payable: {
            name: ''
          },
          belongTo: {},
          approvers: [{}],
          paymentRecords: {
            paymentVouchers: []
          }
        },
        detailId: '',
        isFormFincance: false,
        pdfVisible: false,
        fileUrl: ''
      }
    },
    created() {
      this.getDetail();
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

  .material-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    width: 90px;
    height: 35px;
  }

  .material-btn_red {
    background-color: red;
    /* border-color: #FFD5CE; */
    color: white;
    width: 90px;
    height: 35px;
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

  .financial-plan-triangle_box {
    margin-top: 1px;
    position: absolute;
    right: 0;
    top: 0;
  }

  .financial-plan-triangle {
    width: 0;
    height: 0;
    border-right: 70px solid white;
    border-bottom: 70px solid transparent;
    z-index: 0;
  }

  .financial-plan-triangle_text {
    width: 80px;
    padding-top: 10px;
    padding-left: 37px;
    transform: rotateZ(45deg);
    color: white;
    font-size: 12px;
  }

</style>
