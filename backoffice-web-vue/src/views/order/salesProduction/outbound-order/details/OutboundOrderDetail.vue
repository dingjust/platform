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
      <outbound-order-top-info :slotData="formData" :payPlan="payPlan"/>
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
      <el-row type="flex" justify="center" align="middle" style="margin-top: 20px" v-if="isBelongTo">
        <el-button class="purchase-order-btn2" @click="onGenerateUniqueCode" v-if="canGenerate">唯一码</el-button>
        <el-button class="purchase-order-btn2" @click="onCancel" v-if="this.formData.status != ''">取消订单</el-button>
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

  import OutboundOrderTopInfo from '../form/OutboundOrderTopInfo';
  import OutboundOrderCenterTable from '../form/OutboundOrderCenterTable';
  import UniqueCodeGenerateForm from '../form/UniqueCodeGenerateForm';
  import { SalesProductionTabs } from '@/views/order/salesProduction/components/'

  export default {
    name: 'OutboundOrderDetail',
    props: ['code'],
    components: {
      OutboundOrderCenterTable,
      OutboundOrderTopInfo,
      UniqueCodeGenerateForm,
      SalesProductionTabs
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
      }
    },
    methods: {
      ...mapActions({
        clearFormData: 'clearFormData'
      }),
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

</style>
