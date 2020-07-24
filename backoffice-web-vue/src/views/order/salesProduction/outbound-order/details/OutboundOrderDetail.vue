<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="6">
          <div class="outbound-list-title">
            <h6>外发订单详情</h6>
          </div>
        </el-col>
      </el-row>
      <outbound-order-top-info :slotData="formData" :payPlan="payPlan" @callback="callback"/>
      <div style="margin: 20px 0px 0px 10px;">
        <sales-production-tabs :canChangeProduct="false" :canUpdate="false" :form="formData"/>
      </div>
      <el-row class="basic-form-row" type="flex" align="middle">
        <h6>备注及附件</h6>
      </el-row>
      <el-row type="flex" style="padding-left: 20px">
        <el-col>
          <el-input type="textarea" autosize v-model="formData.remarks" :disabled="true"
            :autosize="{ minRows: 4, maxRows: 6 }" />
        </el-col>
      </el-row>
      <el-row class="basic-form-row" type="flex" align="middle" 
        v-if="formData.uniqueCode && formData.state == 'TO_BE_ACCEPTED'">
        <h6>唯一码：<span style="color: #F56C6C">{{formData.uniqueCode}}</span></h6>
      </el-row>
      <div v-if="showFinancial">
        <div style="padding-left: 10px;margin-top: 20px">
          <el-row v-if="formData.payPlan != null">
            <purchase-order-info-payment-finance :slotData="formData" />
          </el-row>
        </div>
        <div v-if="formData.paymentBill != null">
          <financial-tabs :formData="formData.paymentBill" belongTo="PAYABLE_PAGE"/>
        </div>
      </div>
      <el-row type="flex" justify="center" align="middle" style="margin-top: 20px" v-if="isBelongTo">
        <el-button class="purchase-order-btn2" @click="onGenerateUniqueCode" v-if="canGenerate">唯一码</el-button>
        <el-button class="purchase-order-btn2" @click="onCancel" v-if="this.formData.status != ''">取消订单</el-button>
      </el-row>
      <el-row type="flex" justify="space-around" align="middle" style="margin-top: 20px" v-if="canAudit">
        <el-col :span="3">
          <el-button class="material-btn_red" @click="onApproval(false)">审核拒绝</el-button>
        </el-col>
        <el-col :span="3">
          <el-button class="material-btn" @click="onApproval(true)">审核通过</el-button>
        </el-col>
      </el-row>
    </el-card>
    <el-dialog :visible.sync="uniqueCodeFormVisible" width="30%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <unique-code-generate-form :order="formData" />
    </el-dialog>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';

  const {
    mapGetters,
    mapActions
  } = createNamespacedHelpers(
    'OutboundOrderModule'
  );

  import PurchaseOrderInfoPaymentFinance from '@/views/order/purchase/info/PurchaseOrderInfoPaymentFinance';
  import PurchaseOrderInfoReceiptFinance from '@/views/order/purchase/info/PurchaseOrderInfoReceiptFinance';
  import OutboundOrderTopInfo from '../form/OutboundOrderTopInfo';
  import OutboundOrderCenterTable from '../form/OutboundOrderCenterTable';
  import UniqueCodeGenerateForm from '../form/UniqueCodeGenerateForm';
  import { SalesProductionTabs } from '@/views/order/salesProduction/components/'
  import { FinancialTabs } from '@/views/financial/index.js'

  export default {
    name: 'OutboundOrderDetail',
    props: ['code'],
    components: {
      OutboundOrderCenterTable,
      OutboundOrderTopInfo,
      UniqueCodeGenerateForm,
      SalesProductionTabs,
      PurchaseOrderInfoPaymentFinance,
      PurchaseOrderInfoReceiptFinance,
      FinancialTabs
    },
    computed: {
      ...mapGetters({
        formData: 'formData'
      }),
      isReceiver: function () {
        // const uid = this.$store.getters.currentUser.companyCode;
        // return !(uid == this.formData.belongTo.uid) && this.formData.status == 'PENDING_CONFIRM';
      },
      isBelongTo: function () {
        // const uid = this.$store.getters.currentUser.companyCode;
        // return uid == this.formData.belongTo.uid && this.formData.status != 'CONFIRMED' && this.formData.status !=
        //   'CANCELLED';
      },
      canGenerate: function () {
        // if (this.formData.cooperator != null && this.formData.cooperator.type == 'OFFLINE' && this.formData.status ==
        //   'PENDING_CONFIRM') {
        //   //TODO判断有无唯一码
        //   return true;
        // } else {
        //   return false;
        // }
      },
      canAudit: function () {
        // 订单审核状态在审核中且登陆账号为审核人
        return this.formData.sendAuditState == 'AUDITING' && 
          this.formData.sendApprovers[0].uid == this.$store.getters.currentUser.uid;
      },
      showFinancial: function () {
        return this.formData.sendAuditState == 'PASSED' &&
                this.formData.state != 'TO_BE_ACCEPTED' && 
                this.formData.state != 'TO_BE_SUBMITTED';
      }
    },
    methods: {
      ...mapActions({
        clearFormData: 'clearFormData'
      }),
      callback () {
        this.getDetail();
      },
      async getDetail() {
        const url = this.apis().getoutboundOrderDetail(this.code);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$store.state.OutboundOrderModule.formData = Object.assign({}, result.data);
        this.setPayPlan(result.data.payPlan);
      },
      setPayPlan (payPlan) {
        this.payPlan.name = payPlan.name;
        this.payPlan.isHaveDeposit = payPlan.isHaveDeposit;
        this.payPlan.payPlanType = payPlan.payPlanType;
        payPlan.payPlanItems.forEach((item) => {
          switch (item.moneyType) {
            case 'PHASEONE':
              this.payPlan.balance1.percent = item.payPercent * 100;
              this.payPlan.balance1.event = item.triggerEvent;
              this.payPlan.balance1.time = item.triggerDays;
              this.payPlan.balance1.range = item.triggerType;
              break;
            case 'PHASETWO':
              this.payPlan.balance2.percent = item.payPercent * 100;
              this.payPlan.balance2.event = item.triggerEvent;
              this.payPlan.balance2.time = item.triggerDays;
              this.payPlan.balance2.range = item.triggerType;
              break;
            case 'DEPOSIT':
              this.payPlan.deposit.percent = item.payPercent * 100;
              this.payPlan.deposit.event = item.triggerEvent;
              this.payPlan.deposit.time = item.triggerDays;
              this.payPlan.deposit.range = item.triggerType;
              break;
            case 'MONTHLY_SETTLEMENT':
              this.payPlan.monthBalance.event = item.triggerEvent;
              this.payPlan.monthBalance.time = item.triggerDays;
              break;
          }
        });
        this.$set(this.payPlan,'1',1);
      },
      //审批
      onApproval(isPass) {
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
      },
      async _onApproval(isPass, auditMsg) {
        let formData = {
          id: this.formData.sendAuditWorkOrder.id,
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
        // this.$router.go(-1);
        this.getDetail();
      },
      async onCancel() {
        const url = this.apis().cancelOutboundOrder(this.formData.code);
        const result = await this.$http.put(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$message.success('取消订单成功');
        await this.getDetail();
      },
      async onConfirm() {
        const url = this.apis().acceptOutboundOrder(this.formData.code);
        const result = await this.$http.put(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$message.success('接单成功');
        await this.getDetail();
      },
      async onRejected() {
        const url = this.apis().rejectedOutboundOrder(this.formData.code);
        const result = await this.$http.put(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$message.success('拒绝接单成功');
        await this.getDetail();
      },
      async onGenerateUniqueCode() {
        this.uniqueCodeFormVisible = true;
      }
    },
    data() {
      return {
        uniqueCodeFormVisible: false,
        payPlan: {
          deposit: {},
          balance1: {},
          balance2: {},
          monthBalance: {}
        }
      }
    },
    created() {
      this.getDetail();
    },
    destroyed() {
      this.clearFormData();
    }
  }

</script>

<style scoped>
  .outbound-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .basic-form-row {
    margin-top: 20px;
    padding-left: 10px;
  }

  .purchase-order-btn2 {
    /* background: red;
    color: #fff; */
    width: 200px;
  }

  .purchase-order-btn {
    background: #FFD60C;
    color: rgba(0, 0, 0, 0.85);
    width: 200px;
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

</style>
