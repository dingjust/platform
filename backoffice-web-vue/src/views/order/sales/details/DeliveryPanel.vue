<template>
  <div class="sale-details-b1_body">
    <el-dialog :visible.sync="formShow" width="75%"
      class="purchase-dialog" :close-on-click-modal="false">
      <delivery-form v-if="formShow" @onSubmit="onDeliverySubmit" :slotData="slotData"/>
    </el-dialog>
    <el-row type="flex" align="top">
      <h6>
        订单当前状态：
        <span v-if="stateJudge" style="color: red;font-weight: bold;">卖家已拒绝退款</span>
        <span v-else style="color: #ffac76;font-weight: bold;">买家已付款，等待卖家发货</span>
      </h6>
    </el-row>
    <el-row type="flex" align="bottom" v-if="stateJudge">
      <el-col :span="10" :offset="3">
        <h6 class="sales-details-info">拒绝理由：</h6>
      </el-col>
    </el-row>
    <el-row type="flex" v-if="stateJudge">
      <el-col :span="20" :offset="5">
        <h6 style="color: #F56C6C">{{this.slotData.refundApply.auditMsg}}</h6>
      </el-col>
    </el-row>
    <el-divider v-if="stateJudge"/>
    <el-row type="flex" align="bottom">
      <el-col :span="2" :offset="3">
        <h6 class="sales-details-info">您可以</h6>
      </el-col>
      <el-col :span="6">
        <el-button class="sales-order-btn" @click="onDelivery" v-if="isFactory()">去发货</el-button>
        <el-button class="sales-order-btn" @click="onReturnForm" v-if="isBrand()">申请退款</el-button>
        <el-button type="text" @click="remindDelivery" v-if="isBrand()" :disabled="!allowRemind">提醒发货</el-button>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  import DeliveryForm from '../form/DeliveryForm';

  export default {
    name: 'DeliveryPanel',
    props: ['slotData'],
    components: {
      DeliveryForm
    },
    computed: {
      stateJudge: function () {
        if (this.slotData.hasOwnProperty('refundApply') && this.slotData.refundApply.auditMsg != null) {
          return true;
        }
        return false;
      },
      allowRemind: function () {
        if (!this.slotData.hasOwnProperty('nextReminderDeliveryTime')) {
          return true;
        }
        const nextTime = this.slotData.nextReminderDeliveryTime;
        const now = new Date().getTime();
        if (now - nextTime > 0) {
          return true;
        }
        return false;
      }
    },
    methods: {
      onDelivery () {
        this.formShow = true;
      },
      async onDeliverySubmit (formData) {
        // alert('去发货');
        // return;
        const url = this.apis().updateConsignment(this.slotData.code);
        const result = await this.$http.post(url, formData);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
        }
        this.$emit('getSalesOrderDetails');
        this.formShow = false;
      },
      remindDelivery (row) {
        this.$confirm('是否要提醒商家发货?', '', {
          confirmButtonText: '是',
          cancelButtonText: '否',
          type: 'warning'
        }).then(() => {
          this.$emit('remindDelivery');
        });
      },
      onReturnForm () {
        this.$emit('onReturnForm');
      }
    },
    data () {
      return {
        formShow: false
      }
    },
    created () {

    },
    mounted () {}
  };
</script>
<style>
</style>
