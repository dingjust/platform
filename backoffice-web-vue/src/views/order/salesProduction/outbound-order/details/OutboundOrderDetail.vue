<template>
  <div class="animated fadeIn">
    <el-card>
      <el-row type="flex" justify="space-between" align="middle">
        <div class="sales-plan-form-title">
          <h6 class="title-info">外发订单详情</h6>
        </div>
        <h6 class="title-info">订单号：{{formData.code}}</h6>
        <h6 class="title-info">创建时间：{{formData.creationtime | timestampToTime}}</h6>
        <div>
          <el-row type="flex">
            <h6 class="title-info">标签/状态：{{getEnum('SalesProductionOrderState', formData.state)}}</h6>
            <audit-tag :state="formData.auditState" class="audit-tag" />
          </el-row>
        </div>
        <twinkle-warning-button v-if="isApplyCanceling" @click="canelingDialogVisible=true" label="订单取消申请处理" />
      </el-row>
      <outbound-order-top-info :slotData="formData" :payPlan="payPlan" @callback="callback" />
      <div style="margin: 20px 0px 0px 10px;">
        <sales-production-tabs :canChangeProduct="false" :canUpdate="false" :form="formData" />
      </div>
      <el-row class="basic-form-row" type="flex" align="middle">
        <h6>备注及附件</h6>
      </el-row>
      <el-row type="flex" style="padding-left: 20px">
        <el-col>
          <h6>{{formData.remarks?formData.remarks:''}}</h6>
          <!-- <el-input type="textarea" v-model="formData.remarks" :disabled="true"
            :autosize="{ minRows: 4, maxRows: 6 }" /> -->
        </el-col>
      </el-row>
      <el-row class="basic-form-row" type="flex" align="middle"
        v-if="formData.uniqueCode && formData.state == 'TO_BE_ACCEPTED'">
        <h6>唯一码：<span style="color: #F56C6C">{{formData.uniqueCode}}</span></h6>
      </el-row>
      <template
        v-if="formData.sendAuditWorkOrder && formData.sendAuditWorkOrder.processes && formData.sendAuditWorkOrder.processes.length > 0">
        <order-audit-detail style="padding-left: 10px" :processes="formData.sendAuditWorkOrder.processes" />
      </template>
      <div v-if="showFinancial" style="margin-top:20px">
        <!-- <div style="padding-left: 10px;margin-top: 20px">
          <el-row v-if="formData.payPlan != null">
            <purchase-order-info-payment-finance :slotData="formData" />
          </el-row>
        </div> -->
        <div v-if="formData.paymentBill != null">
          <financial-tabs :formData="formData.paymentBill" belongTo="PAYABLE_PAGE" :outboundOrder="formData" />
        </div>
      </div>
      <el-row type="flex" justify="center" align="middle" style="margin-top: 20px" v-if="isSendBy">
        <el-button class="purchase-order-btn2" @click="onOrderWithdraw" v-if="canOrderWithdraw" type="text">撤回
        </el-button>
        <el-button class="purchase-order-btn2" @click="cancelFormVisible=true" v-if="canCancel" type="text">取消订单
        </el-button>
      </el-row>
      <el-row type="flex" justify="space-around" align="middle" style="margin-top: 20px" v-if="canAudit">
        <el-col :span="3">
          <authorized :permission="['DO_AUDIT']">
            <el-button class="material-btn_red" @click="onApproval(false)">审核驳回</el-button>
          </authorized>
        </el-col>
        <el-col :span="3">
          <authorized :permission="['DO_AUDIT']">
            <el-button class="material-btn" @click="onApproval(true)">审核通过</el-button>
          </authorized>
        </el-col>
      </el-row>
      <el-row type="flex" justify="space-around" align="middle" style="margin-top: 20px"
        v-if="formData.state === 'AUDIT_REJECTED' && isSendBy">
        <el-col :span="3">
          <el-button class="material-btn" @click="onModify">修改</el-button>
        </el-col>
      </el-row>
    </el-card>
    <el-dialog :visible.sync="cancelFormVisible" width="60%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <outbound-cancel-form :order="formData" @callback="callback" v-if="cancelFormVisible" />
    </el-dialog>
    <el-dialog :visible.sync="canelingDialogVisible" width="60%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <sales-order-cancel-dialog v-if="canelingDialogVisible" :order="formData" @callback="callback" />
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
  import OutboundCancelForm from '../form/OutboundCancelForm';
  import SalesOrderCancelDialog from '../../components/SalesOrderCancelDialog';

  import {
    SalesProductionTabs,
    OrderAuditDetail
  } from '@/views/order/salesProduction/components/'
  import {
    FinancialTabs
  } from '@/views/financial/index.js'
  import {
    TwinkleWarningButton
  } from '@/components'


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
      FinancialTabs,
      OutboundCancelForm,
      OrderAuditDetail,
      TwinkleWarningButton,
      SalesOrderCancelDialog
    },
    computed: {
      ...mapGetters({
        formData: 'formData'
      }),
      isReceiver: function () {
        // const uid = this.$store.getters.currentUser.companyCode;
        // return !(uid == this.formData.belongTo.uid) && this.formData.status == 'PENDING_CONFIRM';
      },
      //能否接单撤回(待接单)
      canOrderWithdraw: function () {
        return this.formData.state == 'TO_BE_ACCEPTED';
      },
      //是否外发单创建人（不是接单方creator）
      isSendBy: function () {
        if (this.currentUser.id != null && this.formData.sendBy != null) {
          return this.currentUser.id == this.formData.sendBy.id;
        } else {
          return false;
        }
      },
      //是否在申请取消
      isCanceling: function () {
        if (this.formData.currentCancelApply) {
          return this.formData.currentCancelApply.state == 'PENDING';
        }
        return false;
      },
      canCancel: function () {
        //无未处理的申请单
        return this.formData.state == 'AUDIT_PASSED' && !this.isCanceling;
      },
      canAudit: function () {
        if (this.formData.state !== 'AUDITING') {
          return false;
        }
        // 订单审核状态在待审核且登陆账号为审核人
        if (this.formData.sendApprovers != null) {
          let flag = this.formData.sendApprovers.some(item => item.uid === this.$store.getters.currentUser.uid);
          return this.formData.sendAuditWorkOrder.currentUserAuditState == 'AUDITING' && flag;
        } else {
          return false;
        }
      },
      showFinancial: function () {
        return this.formData.sendAuditState == 'PASSED' &&
          this.formData.state != 'TO_BE_ACCEPTED' &&
          this.formData.state != 'TO_BE_SUBMITTED';
      },
      //是否有正在申请取消订单
      isApplyCanceling: function () {
        if (this.formData.currentCancelApply != null && this.formData.currentCancelApply.state == 'PENDING') {
          return true;
        }
        return false;
      }
    },
    methods: {
      ...mapActions({
        clearFormData: 'clearFormData'
      }),
      callback() {
        this.cancelFormVisible = false;
        this.getDetail();
      },
      onModify() {
        let data = this.setFormData(this.formData);
        this.$router.push({
          name: '创建外发订单',
          params: {
            formData: data
          }
        });
      },
      setFormData(data) {
        let formData = {
          id: data.id,
          managementMode: data.managementMode,
          outboundCompanyName: data.targetCooperator.type == 'ONLINE' ? data.targetCooperator.partner.name : data
            .targetCooperator.name,
          outboundContactPerson: data.targetCooperator.type == 'ONLINE' ? data.targetCooperator.partner
            .contactPerson : data.targetCooperator.contactPerson,
          outboundContactPhone: data.targetCooperator.type == 'ONLINE' ? data.targetCooperator.partner.contactPhone :
            data.targetCooperator.contactPhone,
          targetCooperator: {
            id: data.targetCooperator.id
          },
          taskOrderEntries: data.taskOrderEntries,
          cooperationMode: data.cooperationMode,
          invoiceNeeded: data.invoiceNeeded,
          invoiceTaxPoint: data.invoiceTaxPoint,
          freightPayer: data.freightPayer,
          remarks: data.remarks,
          sendAuditNeeded: data.sendAuditNeeded,
          payPlan: data.payPlan,
          attachments: data.attachments ? data.attachments : [],
          sendApprovers: data.sendApprovers,
          merchandiser: data.merchandiser,
          // state: data.state
        }
        return formData;
      },
      async getDetail() {
        const url = this.apis().getoutboundOrderDetail(this.code);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$store.state.OutboundOrderModule.formData = Object.assign({}, result.data);
        this.payPlan = result.data.payPlan;
        // this.setPayPlan(result.data.payPlan);
      },
      setPayPlan(payPlan) {
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
        this.$set(this.payPlan, '1', 1);
      },
      //审批
      onApproval(isPass) {
        if (this.formData.sendAuditWorkOrder.auditingUser.uid === this.$store.getters.currentUser.uid &&
          this.formData.sendAuditWorkOrder.currentUserAuditState === 'AUDITING') {
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
        } else if (this.formData.sendAuditWorkOrder.currentUserAuditState === 'AUDITING' &&
          this.formData.sendAuditWorkOrder.auditingUser.uid !== this.$store.getters.currentUser.uid) {
          this.$message.warning('此订单暂未轮到您进行审批。')
        } else if (this.formData.sendAuditWorkOrder.currentUserAuditState === 'PASSED') {
          this.$message.warning('您已对此订单进行了审批。');
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

        const loading = this.$loading({
          lock: true,
          text: 'Loading',
          spinner: 'el-icon-loading',
          background: 'rgba(0, 0, 0, 0.7)'
        });
        setTimeout(() => {
          loading.close();
          this.getDetail();
        }, 1000);
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
      //订单撤回
      onOrderWithdraw() {
        this.$confirm('是否确撤回订单?', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this._onOrderWithdraw();
        });
      },
      async _onOrderWithdraw() {
        const url = this.apis().outboundOrderWithdraw(this.formData.id);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        if (result['code'] == '1') {
          this.$message.success('撤回成功');
          await this.getDetail();
          return true;
        } else {
          this.$message.error(result['msg']);
          return false;
        }
      }
    },
    data() {
      return {
        cancelFormVisible: false,
        canelingDialogVisible: false,
        currentUser: this.$store.getters.currentUser,
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

  .audit-tag {
    margin-left: 10px;
  }

  .title-info {
    margin-top: 5px;
  }

</style>
