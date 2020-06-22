<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="4">
          <div class="title">
            <h6>收发货列表</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <shipping-receipt-toolbar :queryFormData="queryFormData" @onAdvancedSearch="onAdvancedSearch"/>
      <el-row type="flex" justify="end">
        <el-col :span="3">
          <el-button type="text" class="list-btn" @click="shippingListVisible = !shippingListVisible">发货单</el-button>
        </el-col>
        <el-col :span="3">
          <el-button type="text" class="list-btn" @click="receiptListVisible = !receiptListVisible">收货单</el-button>
        </el-col>
        <el-col :span="3">
          <el-button type="text" class="list-btn" @click="returnListVisible = !returnListVisible">退货单</el-button>
        </el-col>
      </el-row>
    </el-card>
    <el-dialog :visible.sync="shippingListVisible" width="80%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <shipping-orders-page v-if="shippingListVisible"/>
    </el-dialog>
    <el-dialog :visible.sync="receiptListVisible" width="80%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <receipt-orders-page v-if="receiptListVisible"/>
    </el-dialog>
    <el-dialog :visible.sync="returnListVisible" width="80%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <return-orders-page v-if="returnListVisible"/>
    </el-dialog>
  </div>
</template>

<script>
  import ShippingReceiptToolbar from './toolbar/ShippingReceiptToolbar'
  import ShippingOrdersPage from '../shipping-order/ShippingOrdersPage'
  import ReceiptOrdersPage from '../receipt-order/ReceiptOrdersPage'
  import ReturnOrdersPage from '../return-order/ReturnOrdersPage'
  export default {
    name: 'ShippingReceiptPage',
    components: {
      ShippingReceiptToolbar,
      ShippingOrdersPage,
      ReceiptOrdersPage,
      ReturnOrdersPage
    },
    computed: {
    },
    methods: {
      onAdvancedSearch () {

      }
    },
    data() {
      return {
        shippingListVisible: false,
        receiptListVisible: false,
        returnListVisible: false,
        queryFormData: {
          keyword: '',
          productionLeaderName: '',
          operatorName: '',
          creationtimeStart: '',
          creationtimeEnd: '',
          status: ''
        }
      }
    },
    created() {
    },
    destroyed() {

    }
  }

</script>

<style scoped>
  .title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .list-btn {
    font-size: 16px;
    color: #606266;
  }
</style>
