<template>
  <div class="sale-details-b1_body">
    <el-row type="flex" align="top">
      <h6>
        订单当前状态：
        <span v-if="stateJudge" style="color: red;font-weight: bold;">卖家已拒绝退款</span>
        <span v-else style="color: #ffac76;font-weight: bold;">卖家已发货，等待买家确认</span>
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
    <div>
      <el-row type="flex" align="bottom">
        <el-col :span="2" :offset="3">
          <h6 class="sales-details-info">物流信息：</h6>
        </el-col>
      </el-row>
      <el-row type="flex">
        <el-col :span="20" :offset="5">
          <h6>{{slotData.consignment ? slotData.consignment.carrierDetails.name : ''}} 运单号：
            <el-button type="text" @click="selectLogistics">
              <span style="color:blue">{{slotData.consignment.trackingID}}</span>
            </el-button>
          </h6>
        </el-col>
      </el-row>
      <el-row type="flex">
        <el-col :span="20" :offset="5">
          <span style="color:red;font-size:12px;">点击运单号查看物流</span>
        </el-col>
      </el-row>
    </div>
    <el-row type="flex" justify="end" v-if="isBrand()">
      <el-col :span="3">
        <el-button class="sales-order-btn" style="background:white" @click="onReturn">申请退货</el-button>
      </el-col>
      <el-col :span="3">
        <el-button class="sales-order-btn" @click="onSure">确认收货</el-button>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  import ReturnForm from '../form/ReturnForm';

  export default {
    name: 'ReceivingPanel',
    props: ['slotData'],
    components: {
      ReturnForm
    },
    computed: {
      stateJudge: function () {
        if (this.slotData.hasOwnProperty('refundApply') && this.slotData.refundApply.auditMsg != null) {
          return true;
        }
        return false;
      }
    },
    methods: {
      selectLogistics () {
        alert('查询物流');
      },
      onSure () {
        this.$confirm('是否确认收货?', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this.$emit('confirmDelivery');
        });
      },
      onReturn () {
        // this.formShow = true;
        this.$emit('onReturnForm');
      },
      onReturnSubmit () {
        // Todo APi
        this.formShow = false;
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
