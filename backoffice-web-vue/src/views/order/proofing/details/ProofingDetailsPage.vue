<template>
  <div class="animated fadeIn">
    <el-row class="info-title-row" type="flex" justify="space-between">
      <div class="info-title">
        <h6 class="info-title-text">打样单详情</h6>
      </div>
      <!--<i class="el-icon-edit" @click="onEdit" style="cursor:pointer;font-size: 20px"></i>-->
    </el-row>
    <el-row type="flex" align="middle" style="margin-bottom: 20px">
      <el-col :span="8">
        <span>打样订单号：{{slotData.code}}</span>
      </el-col>
      <el-col :span="8">
        <span>当前状态：<span :style="{color: statusColor}">{{getEnum('proofingOrderStatuses',slotData.status)}}</span></span>
      </el-col>
      <el-col :span="8">
        <el-row type="flex" justify="end">
          <span>发布日期：{{slotData.creationtime | formatDate}}</span>
        </el-row>
      </el-col>
    </el-row>

    <div class="titleCardClass">
      <el-row type="flex">
        <el-col :span="18">
          <el-row>
            <div class="titleClass">
              <h6>打样详情</h6>
            </div>
          </el-row>
          <proofing-basic-info-page :slotData="slotData" style="padding:20px 0px 20px 20px">

          </proofing-basic-info-page>
        </el-col>
        <el-divider direction="vertical"></el-divider>
        <el-col :span="6">
          <el-row>
            <div class="titleClass">
              <h6>合作商信息</h6>
            </div>
          </el-row>
          <proofing-supplier-info-page :slotData="slotData" style="margin: 20px 0px 20px 20px"></proofing-supplier-info-page>
          <el-row>
            <div class="titleClass">
              <h6>人员设置</h6>
            </div>
          </el-row>
          <proofing-q-c-info-page :slotData="slotData" style="margin: 20px 0px 20px 20px"></proofing-q-c-info-page>
        </el-col>
      </el-row>
    </div>

    <el-row type="flex" justify="space-around" style="margin-top: 30px">
      <!--<el-button v-if="isBrand() && slotData.status == 'PENDING_PAYMENT'" class="btn-class" @click="onPayment">去付款</el-button>-->
      <el-button v-if="deliveryShow" class="btn-class" @click="onDelivery">去发货</el-button>
      <el-button v-if="confirmReceive" class="btn-class" @click="onConfirmReceive">确认收货</el-button>
    </el-row>

    <el-dialog :visible.sync="paymentDialogVisible" width="80%"  class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <proofing-payment-page :slotData="slotData" :readOnly="false">

      </proofing-payment-page>
    </el-dialog>
    <el-dialog :visible.sync="deliveryDialogVisible" width="50%"  class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <consignment-form @onSubmit="onConfirmDelivery" v-if="deliveryDialogVisible">

      </consignment-form>
    </el-dialog>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';
  import ProofingBasicInfoPage from '../info/ProofingBasicInfoPage';
  import ProofingSupplierInfoPage from '../info/ProofingSupplierInfoPage';
  import ProofingQCInfoPage from '../info/ProofingQCInfoPage';
  import ProofingPaymentPage from '../payment/ProofingPaymentPage';
  import ConsignmentForm from '../../../../components/custom/ConsignmentForm';

  const {mapGetters, mapMutations, mapActions} = createNamespacedHelpers('ProofingsModule');

  export default {
    name: 'ProofingDetailsPage',
    props: {
      slotData: {
        type: Object,
        required: true
      },
      readOnly: {
        type: Boolean,
        default: true
      }
    },
    components: {
      ConsignmentForm,
      ProofingPaymentPage,
      ProofingQCInfoPage,
      ProofingSupplierInfoPage,
      ProofingBasicInfoPage
    },
    computed: {
      ...mapGetters({

      }),
      deliveryShow: function () {
        return this.isFactory() && this.slotData.status == 'PENDING_DELIVERY';
      },
      confirmReceive: function () {
        return this.isBrand() && this.slotData.status == 'SHIPPED';
      },
      statusColor: function () {
        var color = '';
        switch (this.slotData.status) {
          case 'PENDING_PAYMENT':
            color = 'red';
            break;
          case 'PENDING_DELIVERY':
            color = 'red';
            break;
          case 'SHIPPED':
            color = 'red';
            break;
          case 'COMPLETED':
            color = 'green';
            break;
          case 'CANCELLED':
            color = 'grey';
            break;
        }
        return color;
      }
    },
    methods: {
      ...mapMutations({
      }),
      ...mapActions({
      }),
      onPayment () {
        this.paymentDialogVisible = !this.paymentDialogVisible;
      },
      onDelivery () {
        this.deliveryDialogVisible = !this.deliveryDialogVisible;
      },
      async onConfirmDelivery (consignment) {
        const url = this.apis().confirmDeliveringOfProofing(this.slotData.code);
        const result = await this.$http.put(url, {
          isOfflineConsignment: consignment.isOffline,
          consignment: consignment
        });
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$emit('onRefresh', this.slotData.code);
        this.deliveryDialogVisible = false;
        this.$message.success('确认发货成功');
        this.$emit('onAdvancedSearch');
      },
      async onConfirmReceive () {
        this.$confirm('是否确认收货', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(async () => {
          const url = this.apis().completedOfProofing(this.slotData.code);
          const result = await this.$http.put(url);
          if (result['errors']) {
            this.$message.error(result['errors'][0].message);
            return;
          }
          this.$emit('onRefresh', this.slotData.code);
          this.$message.success('确认收货成功');
          this.$emit('onAdvancedSearch');
        });
      }
    },
    data () {
      return {
        paymentDialogVisible: false,
        deliveryDialogVisible: false
      }
    },
    created () {
    }
  }
</script>

<style scoped>
   .info-title {
    width: 100%;
    border-left: 2px solid #FFD60C;
    padding-left: 10px;
    height: 14px;
  }

   .info-title-text {
    font-size: 12px;
    font-weight: bold;
    color: rgba(0, 0, 0, 1);
    opacity: 0.65;
  }

   .info-title-row {
    margin-bottom: 20px;
  }

  /deep/ .el-divider--vertical{
    height: auto;
    margin: 0px;
  }

   /deep/ .el-divider--horizontal{
    margin: 0px 0px -1px 0px;
  }

   .buttonClass{
    padding: 8px 35px 8px 35px;
    margin-bottom: 10px;
    background-color: #ffd60c;
    color: #0b0e0f;
  }

   .box{
    width: 50px;
    position: fixed;
    right: 152px;
    top: 300px;
    z-index:1;
  }
   .boxButton{
    width: 50px;
    height: 50px;
    font-size: 10px;
    cursor: pointer;
    border: 1px solid #DCDFE6;
  }

   .buttonIconClass{
    width: 30px;
    height: 30px;
    margin-bottom: -8px;
  }

   .buttonTextClass{
    font-size: 12px;
    transform:scale(0.7);
  }

   .titleClass{
    padding: 10px 0px 1px 10px;
    background-color: #F0F0F0;
  }

   .titleCardClass{
    border-style: solid;
    border-width: 1px;
    border-top: white;
    border-color: #DCDCDC;
  }

</style>
