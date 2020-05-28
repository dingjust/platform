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
<!--      <div class="pt-2"></div>-->
      <outbound-order-top-info :slotData="formData"/>
      <outbound-order-center-table :slot-data="formData" @onDetail="onDetail"/>
<!--      <el-row v-if="isFactory()">-->
<!--        <outbound-order-receipt-info :slotData="formData"/>-->
<!--      </el-row>-->
<!--      <el-row v-if="isBrand()">-->
<!--        <outbound-order-payment-info :slot-data="formData"/>-->
<!--      </el-row>-->
      <el-row class="basic-form-row" type="flex" align="middle">
        <h6>备注及附件</h6>
      </el-row>
      <el-row type="flex" style="padding-left: 20px">
        <el-col>
          <el-input type="textarea" autosize v-model="formData.remarks" :autosize="{ minRows: 4, maxRows: 6 }"/>
        </el-col>
      </el-row>
    </el-card>
    <el-dialog :visible.sync="taskDetailVisible" width="80%"  class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <production-task-details v-if="taskDetailVisible" :id="productionTaskId"/>
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
  import OutboundOrderReceiptInfo from '../form/OutboundOrderReceiptInfo';
  import OutboundOrderPaymentInfo from '../form/OutboundOrderPaymentInfo';
  import ProductionTaskDetails from "../../production-task/details/ProductionTaskDetail";
  export default {
    name: 'OutboundOrderDetail',
    props: ['code'],
    components: {
      ProductionTaskDetails,
      OutboundOrderPaymentInfo,
      OutboundOrderReceiptInfo,
      OutboundOrderCenterTable,
      OutboundOrderTopInfo
    },
    computed: {
      ...mapGetters({
        formData: 'formData'
      })
    },
    methods: {
      ...mapActions({
        clearFormData: 'clearFormData',
      }),
      async getDetail () {
        const url = this.apis().getoutboundOrderDetail(this.code);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$store.state.OutboundOrderModule.formData = Object.assign({}, result);
      },
      onDetail (row) {
        this.taskDetailVisible = true;
        this.productionTaskId = row.productionTask.id;
      }
    },
    data () {
      return {
        productionTaskId: '',
        taskDetailVisible: false
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
</style>
