<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="2">
          <div class="orders-list-title">
            <h6>订单详情</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <el-row type="flex" justify="center">
        <el-col :span="20">
          <div class="sale-details-b1">
            <div class="sale-details-stepbox" v-if="formData.status != 'CANCELLED'">
              <el-steps :active="active" align-center finish-status="success" v-if="formData.refunding && formData.status == 'PENDING_DELIVERY'">
                <el-step title="买家付款"></el-step>
                <el-step title="退款/售后"></el-step>
                <el-step title="交易完成"></el-step>
              </el-steps>
              <el-steps :active="active" align-center finish-status="success" v-else>
                <el-step title="买家付款"></el-step>
                <el-step title="卖家发货"></el-step>
                <!-- <el-step v-if="!formData.refunding" title="确认收货"></el-step>
                <el-step v-if="formData.refunding" title="退款/售后"></el-step> -->
                <el-step v-if="!formData.refunding && formData.refundStatus != 'COMPLETED'" title="确认收货"></el-step>
<el-step v-if="formData.refunding || formData.refundStatus == 'COMPLETED'" title="退款/售后"></el-step>
                <el-step title="交易完成"></el-step>
              </el-steps>
            </div>
            <div class="_sale-details-stepbox" v-else>
              <el-row type="flex" align="middle" justify="center">
                <h6 style="color: #d2d1d1;font-size: 16px">该订单已关闭</h6>
              </el-row>
            </div>
            <payment-panel v-if="paymentPanelShow" :slotData="formData" @cannelOrder="cannelOrder"/>
            <delivery-panel v-if="deliveryPanelShow" :slotData="formData" @getSalesOrderDetails="getSalesOrderDetails" @onReturnForm="onReturnForm" @remindDelivery="remindDelivery"/>
            <receiving-panel v-if="receivingPanelShow" :slotData="formData" @onReturnForm="onReturnForm" @confirmDelivery="confirmDelivery"/>
            <return-panel v-if="returnPanelShow" :formData="formData.refundApply" @returnAudit="returnAudit" @onRefuseReturnForm="onRefuseReturnForm"
                          @platformIntervene="platformIntervene" @cannelApply="cannelApply"/>
            <completed-panel v-if="completedPanelShow" :slotData="formData"/>
<!--            <div class="_sale-details-stepbox" style="padding: 40px;" v-if="auditMsgShow">-->
<!--              <el-divider/>-->
<!--              <el-row type="flex">-->
<!--                <h6>-->
<!--                  <span style="color:red;font-weight: bold;">卖家拒绝退款</span>-->
<!--                </h6>-->
<!--              </el-row>-->
<!--              <el-row type="flex">-->
<!--                <h6>-->
<!--                  拒绝理由：-->
<!--                  <span style="color:red;font-weight: bold;">{{this.formData.refundApply.auditMsg}}</span>-->
<!--                </h6>-->
<!--              </el-row>-->
<!--            </div>-->
          </div>
          <div class="sale-details-b2">
            <div class="sale-details-b2_title">
              <el-row type="flex">
                <h5>订单信息</h5>
              </el-row>
            </div>
            <div class="sale-details-b2_body">
              <el-row type="flex">
                <el-col :span="14">
                  <h6>收货信息</h6>
                </el-col>
                <el-col :span="10">
                  <h6>卖家信息</h6>
                </el-col>
              </el-row>
              <div style="padding-left:20px;margin-top:10px">
                <el-row type="flex" class="sales-detail-row">
                  <el-col :span="14">
                    <h6>订单编号：{{formData.code}}</h6>
                  </el-col>
                  <el-col :span="10">
                    <h6>供应商：{{formData.seller.name}}</h6>
                  </el-col>
                </el-row>
                <el-row type="flex" class="sales-detail-row">
                  <el-col :span="14">
                    <h6>姓名：{{formData.deliveryAddress.fullname}}</h6>
                  </el-col>
                  <el-col :span="10">
                    <h6>联系方式：{{formData.seller.contactPhone}}</h6>
                  </el-col>
                </el-row>
                <el-row type="flex" class="sales-detail-row">
                  <el-col :span="14">
                    <h6>联系方式：{{formData.deliveryAddress.cellphone}}</h6>
                  </el-col>
                  <el-col :span="10">
                    <h6>地址：{{formData.seller.locationAddress}}</h6>
                  </el-col>
                </el-row>
                <el-row type="flex" class="sales-detail-row">
                  <el-col :span="14">
                    <h6>地址：{{formData.deliveryAddress.details}}</h6>
                  </el-col>
                </el-row>
                <order-rows-table style="margin-top:20px;" :slotData="formData" @summary="summary"/>
                <el-row type="flex" justify="end" style="margin-top:50px">
                  <h6>总计：<span class="sales-total-price">{{total}}</span>元</h6>
                </el-row>
              </div>
            </div>
          </div>
        </el-col>
      </el-row>
    </el-card>
    <el-dialog :visible.sync="returnFormVisible" width="60%" class="purchase-dialog" :close-on-click-modal="false">
      <return-form v-if="returnFormVisible" @submitReturnForm="submitReturnForm" :code="this.code"/>
    </el-dialog>
    <el-dialog :visible.sync="refuseReturnFormVisible" width="60%" class="purchase-dialog" :close-on-click-modal="false">
      <refuse-return-form v-if="refuseReturnFormVisible" @returnAudit="returnAudit" :code="this.code"/>
    </el-dialog>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';

  const {
    mapGetters,
    mapActions,
    mapMutations
  } = createNamespacedHelpers(
    'SalesOrdersModule'
  );

  import OrderRowsTable from './OrderRowsTable';
  import PaymentPanel from './PaymentPanel';
  import DeliveryPanel from './DeliveryPanel';
  import ReceivingPanel from './ReceivingPanel';
  import ReturnPanel from './ReturnPanel';
  import ReturnForm from '../form/ReturnForm';
  import CompletedPanel from './CompletedPanel';
  import RefuseReturnForm from "../form/RefuseReturnForm";
  import {formatDate} from '@/common/js/filters';

  export default {
    name: 'SalesOrderDetailsPage',
    props: ['code'],
    components: {
      RefuseReturnForm,
      CompletedPanel,
      ReturnForm,
      OrderRowsTable,
      PaymentPanel,
      DeliveryPanel,
      ReceivingPanel,
      ReturnPanel
    },
    computed: {
      ...mapGetters({
        formData: 'formData'
      }),
      active: function () {
        if (this.formData.status == 'PENDING_PAYMENT') {
          return 0;
        } else if (this.formData.status == 'PENDING_DELIVERY' && this.formData.refundStatus != 'IN_REFUND') {
          return 1;
        } else if ((this.formData.status == 'PENDING_CONFIRM' && this.formData.refundStatus != 'IN_REFUND') || (this.formData.refundStatus == 'IN_REFUND' && this.formData.status == 'PENDING_DELIVERY')){
          return 2;
        } else if ((this.formData.status == 'PENDING_DELIVERY' && this.formData.refundStatus == 'COMPLETED') || (this.formData.status == 'PENDING_CONFIRM' && this.formData.refundStatus == 'IN_REFUND')){
          return 3;
        } else if (this.formData.status == 'COMPLETED'){
          return 4;
        }
      },
      paymentPanelShow: function () {
        return this.formData.status === 'PENDING_PAYMENT';
      },
      deliveryPanelShow: function () {
        return this.formData.status === 'PENDING_DELIVERY' && !this.formData.refunding;
      },
      receivingPanelShow: function () {
        return this.formData.status === 'PENDING_CONFIRM' && !this.formData.refunding;
      },
      returnPanelShow: function () {
        return this.formData.refunding;
      },
      completedPanelShow: function () {
        if (this.formData.refundStatus) {
          return this.formData.status === 'COMPLETED' || this.formData.refundStatus === 'COMPLETED';
        } else {
          return this.formData.status === 'COMPLETED';
        }
      }
    },
    methods: {
      getTime (time) {
        if (time === null || time == '') {
          return '';
        }
        let date = new Date(time);
        return formatDate(date, 'yyyy-MM-dd hh:mm');
      },
      async getSalesOrderDetails () {
        const url = this.apis().getSalesOrderDetails(this.code);
        const result = await this.$http.get(url);
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        this.$store.state.SalesOrdersModule.formData = Object.assign({}, result);
      },
      onReturnForm () {
        this.returnFormVisible = true;
      },
      async submitReturnForm (data) {
        const url = this.apis().orderRefundApply();
        const result = await this.$http.post(url, data);
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        this.$message.success('申请退款成功！');
        this.getSalesOrderDetails();
        this.returnFormVisible = false;
      },
      summary (total) {
        this.total = total;
      },
      async cannelOrder () {
        const url = this.apis().cannelSalesOrder(this.code);
        const result = await this.$http.put(url);
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        this.$message.success('取消订单成功！')
        this.getSalesOrderDetails();
      },
      // async remindDelivery () {
      //   // const nextTime = this.formData.nextReminderDeliveryTime;
      //   // const now = new Date().getTime();
      //   // if (this.formData.hasOwnProperty('reminderDeliveryTime')) {
      //   //   const nextTime = this.formData.nextReminderDeliveryTime;
      //   //   const now = new Date().getTime();
      //   //   if (now - nextTime > 0) {
      //   //     this._remindDelivery();
      //   //   } else {
      //   //     this.$message.error('24小时内只能提醒一次发货！');
      //   //   }
      //   // } else {
      //     this._remindDelivery();
      //   }/
      // },
      async remindDelivery () {
        const url = this.apis().reminderSalesOrderDelivery(this.code);
        const result = await this.$http.get(url);
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        this.$message.success('提醒发货成功！');
        this.getSalesOrderDetails();
      },
      async confirmDelivery () {
        const url = this.apis().confirmReceived(this.code);
        const result = await this.$http.put(url);
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        this.$message.success('确认收货成功！')
        this.getSalesOrderDetails();
      },
      onRefuseReturnForm () {
        this.refuseReturnFormVisible = true;
      },
      async returnAudit (flag, data) {
        let formData;
        if (flag) {
          formData = {
            code: this.code,
            agree: flag
          }
        } else {
          formData = Object.assign({}, data)
        }
        const url = this.apis().auditRefundApply();
        const result = await this.$http.post(url, formData);
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        const msg = flag ? '同意退款成功！' : '拒绝退款成功！'
        this.$message.success(msg);
        this.refuseReturnFormVisible = false;
        this.getSalesOrderDetails();
      },
      platformIntervene () {
        alert('平台介入');
      },
      async cannelApply () {
        const url = this.apis().cancelRefundApply(this.code);
        const result = await this.$http.get(url);
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        this.$message.success('撤销退款操作成功');
        this.getSalesOrderDetails();
      }
    },
    data () {
      return {
        total: '',
        returnFormVisible: false,
        refuseReturnFormVisible: false,
        returnFormData: ''
      };
    },
    created () {
      this.getSalesOrderDetails();
    },
    mounted () {}
  };
</script>
<style>
  .report {
    margin-bottom: 10px;
  }

  .sale-details-b1 {
    border: #d2d1d1 solid 0.5px;
     padding: 20px;
    padding: 20px 0 0px 0;
  }

  .sale-details-b1_body {
    padding: 40px;
  }

  .sale-details-b2 {
    border: #d2d1d1 solid 0.5px;
    margin-top: 20px;
    padding: 0.5px 0.5px 0px 0.5px;
  }

  .sale-details-b2_title {
    background-color: #fafafa;
    border-bottom: #d2d1d1 solid 0.5px;
    padding: 10px 15px 10px 15px;
  }

  .sale-details-b2_body {
    padding: 30px 40px 30px 40px;
  }

  .sales-order-btn {
    background: #ffd60c;
    color: rgba(0, 0, 0, 0.85);
    width: 80px;
  }

  .sales-details-info {
    padding-top: 8px;
  }

  .sale-details-stepbox {
    border-bottom: #d2d1d1 solid 0.5px;
    padding: 20px 0px 20px 0px;
  }
  ._sale-details-stepbox {
    padding: 20px 0px 20px 0px;
  }
  .sale-details-stepbox1 {
    /*border-bottom: #d2d1d1 solid 0.5px;*/
    padding: 20px 0px 0px 40px;
  }

  .sales-total-price {
    color: red;
    font-size: 14px;
  }

  .sales-detail-row {
    margin-bottom: 10px;
  }

</style>
