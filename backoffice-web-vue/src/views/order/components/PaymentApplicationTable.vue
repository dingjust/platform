<!--
* @Description: 付款申请单打印表格
* @Date 2021/07/15 09:42
* @Author L.G.Y
-->
<template>
  <div>
    <div id="print-page">
      <div class="payment-application-table">
        <table cellspacing="2" width="100%" class="order-table">
          <tr>
            <th :colspan="7">
              <el-input class="companyName-cell" v-model="form.companyName" />
            </th>
          </tr>
          <tr>
            <th :colspan="7">
              <el-input class="title-cell" v-model="form.title" />
            </th>
          </tr>
          <tr>
            <td v-for="count in 5" :key="count"><el-input v-model="form[count + 'date']"/></td>
            <td><el-input v-model="form.dateTitle"/></td>
            <td>
              <el-date-picker
                v-model="form.date"
                prefix-icon="none"
                type="date"
                placeholder="选择日期"
                :clearable="false"
                format="yyyy 年 MM 月 dd 日">
              </el-date-picker>
            </td>
          </tr>
          <tr>
            <td><el-input v-model="form.applyDeptTitle"/></td>
            <td :colspan="6" class="left-title">
              <el-input v-model="form.applyDept"></el-input>
            </td>
          </tr>
          <tr>
            <td><el-input v-model="form.paymentTypeTitle"/></td>
            <td :colspan="2">
              <div class="radio-cell" style="justify-content: space-between;flex-wrap: wrap;">
                <template v-for="(value, index) in paymentTypes">
                  <label class="radio-cell" :key="index">
                    <input type="radio" name="paymentType" :value="value" v-model="form.paymentType" style="margin-right: 4px;"/>
                    {{value}}
                  </label>
                </template>
              </div>
            </td>
            <td><el-input v-model="form.paymentItemTitle"/></td>
            <td :colspan="3">
              <div class="radio-cell" style="justify-content: space-between">
                <template v-for="(value, index) in paymentItems">
                  <label class="radio-cell" :key="index">
                    <input type="radio" name="paymentItem" :value="value" v-model="form.paymentItem" style="margin-right: 4px;"/>
                    {{value}}
                  </label>
                </template>
              </div>
            </td>
          </tr>
          <tr>
            <td><el-input v-model="form.receiving.companyNameTitle"/></td>
            <td :colspan="6" class="left-title">
              <el-input v-model="form.receiving.companyName" />
            </td>
          </tr>
          <tr>
            <td><el-input v-model="form.receiving.serviceProviderTitle"/></td>
            <td :colspan="6" class="left-title">
              <el-input v-model="form.receiving.serviceProvider" />
            </td>
          </tr>
          <tr>
            <td><el-input v-model="form.receiving.noTitle"/></td>
            <td :colspan="6" class="left-title">
              <el-input v-model="form.receiving.no" />
            </td>
          </tr>
          <tr>
            <td><el-input v-model="form.receiving.nameTitle"/></td>
            <td :colspan="6" class="left-title">
              <el-input v-model="form.receiving.name" />
            </td>
          </tr>
          <tr>
            <th :colspan="7">
              <el-input class="matter-cell" v-model="form.matter" />
            </th>
          </tr>
          <tr>
            <td><el-input v-model="form.contract.codeTitle" /></td>
            <td :colspan="4">
              <el-input v-model="form.contract.code"></el-input>
            </td>
            <td><el-input v-model="form.contract.applyTermTitle" style="min-width: 8em;"/></td>
            <td>
              <el-date-picker
                v-model="form.contract.applyTerm"
                prefix-icon="none"
                type="date"
                :clearable="false"
                format="yyyy 年 MM 月 dd 日">
              </el-date-picker>
            </td>
          </tr>
          <tr>
            <td><el-input v-model="form.contract.totalTitle" /></td>
            <td><el-input v-model="form.contract.totalLowerTitle" /></td>
            <td><el-input v-model="form.contract.total" v-number-input.float="{ min: 0, decimal: 2 }"/></td>
            <td><el-input v-model="form.contract.totalCapTitle" /></td>
            <td :colspan="3">{{convertCurrency(form.contract.total)}}</td>
          </tr>
          <tr>
            <td><el-input v-model="form.reconciliation.title" /></td>
            <td><el-input v-model="form.reconciliation.lowerTitle" /></td>
            <td><el-input v-model="form.reconciliation.total" v-number-input.float="{ min: 0, decimal: 2 }"/></td>
            <td><el-input v-model="form.reconciliation.capTitle" /></td>
            <td :colspan="3">{{convertCurrency(form.reconciliation.total)}}</td>
          </tr>
          <tr>
            <td ><el-input v-model="form.contract.clauseTitle" /></td>
            <td :colspan="6"><el-input v-model="form.contract.clause" type="textarea" :rows="3"/></td>
          </tr>
          <tr>
            <td><el-input v-model="form.payment.title" /></td>
            <td><el-input v-model="form.payment.frist" /></td>
            <td><el-input v-model="form.payment.second" /></td>
            <td><el-input v-model="form.payment.third" /></td>
            <td><el-input v-model="form.payment.fourth" /></td>
            <td><el-input v-model="form.payment.deduction" /></td>
            <td><el-input v-model="form.payment.total" /></td>
          </tr>
          <tr>
            <td><el-input v-model="form.paymentPrice.title" /></td>
            <td><el-input v-model="form.paymentPrice.frist" /></td>
            <td><el-input v-model="form.paymentPrice.second" /></td>
            <td><el-input v-model="form.paymentPrice.third" /></td>
            <td><el-input v-model="form.paymentPrice.fourth" /></td>
            <td><el-input v-model="form.paymentPrice.deduction" /></td>
            <td><el-input v-model="form.paymentPrice.total" /></td>
          </tr>
          <tr>
            <td><el-input v-model="form.contractPaid.title" /></td>
            <td><el-input v-model="form.contractPaid.lowerTitle" /></td>
            <td><el-input v-model="form.contractPaid.total" v-number-input.float="{ min: 0, decimal: 2 }"/></td>
            <td><el-input v-model="form.contractPaid.capTitle" /></td>
            <td :colspan="3">{{convertCurrency(form.contractPaid.total)}}</td>
          </tr>
          <tr>
            <td><el-input v-model="form.thisApply.title" style="width: 11em;"/></td>
            <td><el-input v-model="form.thisApply.lowerTitle" /></td>
            <td><el-input v-model="form.thisApply.total" v-number-input.float="{ min: 0, decimal: 2 }"/></td>
            <td><el-input v-model="form.thisApply.capTitle" /></td>
            <td :colspan="3">{{convertCurrency(form.thisApply.total)}}</td>
          </tr>
          <tr>
            <td :colspan="7"><el-input v-model="form.paymentContent" type="textarea" :rows="3"/></td>
          </tr>
          <tr>
            <td><el-input v-model="form.apply.title" /></td>
            <td :colspan="2"><el-input v-model="form.apply.name" /></td>
            <td :colspan="2"><el-input v-model="form.apply.deptTitle" /></td>
            <td :colspan="2"><el-input v-model="form.apply.deptName" /></td>
          </tr>
          <tr>
            <td><el-input v-model="form.apply.managerTile" /></td>
            <td :colspan="2"><el-input v-model="form.apply.managerName" /></td>
            <td :colspan="2"><el-input v-model="form.apply.financeTitle" /></td>
            <td :colspan="2"><el-input v-model="form.apply.financeName" /></td>
          </tr>
        </table>
      </div>
    </div>
    <el-row type="flex" justify="center" style="margin-top: 10px">
      <printer-button v-print="printObj" />
    </el-row>
  </div>
</template>

<script>
import { PrinterButton } from '@/components/index.js'
export default {
  name: 'PaymentApplicationTable',
  components: { PrinterButton },
  props: ['detail'],
  computed: {
    contracts: function () {
      if (this.detail.agreements) {
        return this.detail.agreements.filter(item => item.state !== 'INVALID');
      }
      return [];
    }
  },
  methods: {
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
    },
    init () {
      this.form.companyName = this.$store.getters.currentUser.companyName
      const detail = JSON.parse(JSON.stringify(this.detail))

      if (detail.paymentAccount) {
        this.form.receiving.companyName = detail.belongTo.name
        this.form.receiving.name = detail.paymentAccount.name
        this.form.receiving.no = detail.paymentAccount.no
        this.form.receiving.serviceProvider = detail.paymentAccount.serviceProvider
      }
      if (this.contracts && this.contracts.length > 0) {
        this.form.contract.code = this.contracts[0].code
      } else {
        this.form.contract.code = detail.code
      }
      if (detail.totalPrimeCost != 0) {
        this.form.contract.total = detail.totalPrimeCost
      } else {
        let totalAmount = 0;
        detail.taskOrderEntries.forEach(item => {
          totalAmount += (item.unitPrice * item.quantity);
        })
        this.form.contract.total = totalAmount.toFixed(2)
      }

      const serviceFeePercent = detail.serviceFeePercent ? detail.serviceFeePercent : 0
      let str = ''
      if (detail.paymentOrders && detail.paymentOrders.length > 0) {
        let payAmount = 0
        detail.paymentOrders.reverse()
        detail.paymentOrders.forEach((item, index) => {
          if (index > 3) {
            return
          } 
          this.form.paymentPrice[this.arr[index][0]] = item.payAmount
          payAmount += item.payAmount

          str += '第' + this.arr[index][1] + '次付款：' + (item.payAmount * (1 - serviceFeePercent)).toFixed(2) + '元' + (index < detail.paymentOrders.length - 1 ? '，' : '')
        })

        this.form.paymentPrice.deduction = (payAmount * serviceFeePercent).toFixed(2)
        this.form.paymentPrice.total = payAmount - this.form.paymentPrice.deduction

        this.form.thisApply.title = '此次申请第（' + detail.paymentOrders.length + '）次数'
        this.form.thisApply.total = (detail.paymentOrders[detail.paymentOrders.length - 1].payAmount * (1 - serviceFeePercent)).toFixed(2)
      }

      this.form.paymentContent = '付款内容：' + this.form.contract.code + ' 订单生产总价：' + this.form.contract.total + '元，' + 
                                '总服务费' + (serviceFeePercent * 100).toFixed(2) + '%：' + this.form.paymentPrice.deduction + '元' + 
                                (str !== '' ? ('，' + str) : '')
    }
  },
  data () {
    return {
      printObj: {
        id: "print-page",
      },
      form: {
        companyName: '宁波衣加衣供应链管理有限公司',
        title: '付款申请单',
        dateTitle: '日期：',
        date: new Date(),
        applyDeptTitle: '申请付款部门',
        applyDept: '平台业务部',
        paymentTypeTitle: '付款方式',
        paymentType: null,
        paymentItemTitle: '付款项目',
        paymentItem: null,
        receiving: {
          companyNameTitle: '收款公司全称',
          serviceProviderTitle: '开户行',
          noTitle: '账号/卡号',
          nameTitle: '收款人户名',
          companyName: '',
          serviceProvider: '',
          no: '',
          name: ''
        },
        matter: '汇款事项 （结算明细）',
        contract: {
          codeTitle: '合同订单号',
          code: '',
          applyTermTitle: '此次申请付款期限',
          applyTerm: null,
          totalTitle: '合同总金额',
          totalLowerTitle: '小写：',
          total: '',
          totalCapTitle: '大写：',
          totalCap: '',
          clauseTitle: '合同付款条款：',
          clause: ''
        },
        reconciliation: {
          title: '对账单金额（修订后）',
          lowerTitle: '小写：',
          total: '',
          capTitle: '大写：',
          totalCap: ''
        },
        payment: {
          title: '项目',
          frist: '第一次付款',
          second: '第二次付款',
          third: '第三次付款',
          fourth: '第四次付款',
          deduction: '扣技术服务款',
          total: '合计金额',
        },
        paymentPrice: {
          title: '',
          frist: '',
          second: '',
          third: '',
          fourth: '',
          deduction: '',
          total: '',
        },
        contractPaid: {
          title: '合同已付金额',
          lowerTitle: '小写：',
          total: '',
          capTitle: '大写：',
          totalCap: ''
        },
        thisApply: {
          title: '此次申请第（*）次款',
          lowerTitle: '小写：',
          total: '',
          capTitle: '大写：',
          totalCap: ''
        },
        paymentContent: '',
        apply: {
          title: '申请人：',
          name: '',
          deptTitle: '部门负责人：',
          deptName: '',
          managerTile: '总经理：',
          managerName: '',
          financeTitle: '财务负责人：',
          financeName: ''
        }
      },
      paymentTypes: ['转账汇款', '现金'],
      paymentItems: ['成品', '工程类', '研发面辅料采购', '固定资产', '其他'],
      arr: {
        0: ['frist', '一'],
        1: ['second', '二'],
        2: ['third', '三'],
        3: ['fourth', '四']
      }
    }
  },
  created () {
    this.init()
  }
}
</script>

<style scoped>
  @page {
    size: auto;
    width: 100%;
  }

  @media print {
    #print-page p {
      width: 100%;
      height: 100%;
    }
  }

  .payment-application-table >>> .el-input__inner {
    border: none;
    padding: 0px;
    color: #303133;
  }
  .payment-application-table >>> .el-input__inner {
    border: none;
    padding: 0px;
    color: #303133;
  }
  .payment-application-table >>> .el-textarea__inner {
    border: none;
    color: #303133!important;
    padding: 12px 0px;
  }
  
  .companyName-cell >>> .el-input__inner{
    font-size: 20px;
    font-weight: bold;
    color: #303133;
    text-align: center;
  }
  .title-cell >>> .el-input__inner{
    font-size: 18px;
    font-weight: bold;
    color: #303133;
    text-align: center;
  }
  .matter-cell >>> .el-input__inner{
    font-size: 14px;
    font-weight: bold;
    color: #303133;
    text-align: center;
  }
  .payment-application-table >>> .order-table {
    width: 100%;
    height: 100%; 
    border-collapse: collapse;
    margin-bottom: 20px;
    border: 1px solid #909399;
  }
  .payment-application-table >>> .order-table tr td,
  .payment-application-table >>> .order-table tr th {
    padding: 0px 16px;
    text-align: center;
    height: 40px;
    font-size: 14px;
    border-right: 1px solid #909399;
    border-bottom: 1px solid #909399;
    background-color: #FFFFFF;
  }
  .payment-application-table >>> .order-table label {
    margin: 0;
  }
  .radio-cell {
    display: flex;
    align-items: center;
  }
  .left-title {
    text-align: left!important;
  }
</style>