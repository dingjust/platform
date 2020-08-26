<template>
  <div>
    <el-row type="flex" :gutter="20">
      <el-col :span="12">
        <el-table ref="shipTable" stripe :data="formData.receiptSheets" :height="autoHeight">
          <!-- <el-table-column align="left" min-width="120">
            <template slot="header">
              <el-tooltip effect="light" :content="tips" placement="top">
                <span>发货单号<i class="el-icon-question" /></span>
              </el-tooltip>
            </template>
            <template slot-scope="scope">
              <el-button type="text" @click="onShipDetail(scope.row.id)">{{scope.row.code}}</el-button>
            </template>
          </el-table-column>
          <el-table-column label="发货数量" prop="totalQuantity"></el-table-column> -->
          <el-table-column label="收货单">
            <template slot-scope="scope">
              <el-button type="text" @click="onReceiptDetail(scope.row)">{{scope.row.code}}</el-button>
            </template>
          </el-table-column>
          <el-table-column label="收货数量" prop="totalQuantity" />          
          <el-table-column label="收货时间">
            <template slot-scope="scope">
              <span>{{scope.row.creationtime| timestampToTime}}</span>
            </template>
          </el-table-column>
          <el-table-column label="状态">
            <template slot-scope="scope">
              <span>{{getEnum('ShippingSheetState',scope.row.state)}}</span>
            </template>
          </el-table-column>
        </el-table>
      </el-col>
      <el-col :span="12">
        <el-table ref="reconciliationTable" stripe :data="formData.reconciliationSheets" :height="autoHeight">
          <el-table-column label="对账单号">
            <template slot-scope="scope">
              <el-button type="text" @click="onReconciliationDetail(scope.row.id)">{{scope.row.code}}</el-button>
            </template>
          </el-table-column>
          <el-table-column label="对账数量" prop="reconciliationQuantity"></el-table-column>
          <el-table-column label="对账金额" prop="reconciliationAmount"></el-table-column>
          <el-table-column label="扣款金额" prop="deductionAmount"></el-table-column>
          <el-table-column label="增款金额" prop="increaseAmount"></el-table-column>
          <el-table-column label="实付金额" prop="amountDue"></el-table-column>
          <el-table-column label="状态">
            <template slot-scope="scope">
              <span>{{getEnum('ReconciliationOrderState',scope.row.state)}}</span>
            </template>
          </el-table-column>
        </el-table>
      </el-col>
    </el-row>
    <el-dialog :visible.sync="shipOrderVisible" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <shipping-orders-detail v-if="shipOrderVisible" :id="shipId" />
    </el-dialog>
    <el-dialog :visible.sync="receiptOrderVisible" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <receipt-order-detail v-if="receiptOrderVisible" :id="receiptId" />
    </el-dialog>
    <el-dialog :visible.sync="reconciliationOrderVisible" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <reconciliation-orders-detail v-if="reconciliationOrderVisible" :id="reconciliationId" />
    </el-dialog>
  </div>
</template>

<script>
  import ReceiptOrderDetail from '../../receipt-order/details/ReceiptOrderDetail'
  import ShippingOrdersDetail from '../../shipping-order/details/ShippingOrdersDetail'
  import ReconciliationOrdersDetail from '../../reconciliation-order/details/ReconciliationOrdersDetail'

  export default {
    name: 'ReconciliationTasksOrdersList',
    props: ['formData'],
    components: {
      ReceiptOrderDetail,
      ShippingOrdersDetail,
      ReconciliationOrdersDetail
    },
    computed: {},
    methods: {
      onShipDetail(id) {
        this.$set(this, 'shipId', id);
        this.shipOrderVisible = true;
      },
      onReceiptDetail(item) {
        // this.$router.push('/receipt/orders/' + item.id);
        this.$set(this, 'receiptId', item.id);
        this.receiptOrderVisible = true;
      },
      onReconciliationDetail(id) {
        this.$set(this, 'reconciliationId', id);
        this.reconciliationOrderVisible = true;
      },
      //收货数
      receiptNum(row) {
        let result = 0;
        if (row.receiptSheets != null) {
          row.receiptSheets.forEach(element => {
            if (element.totalQuantity != null) {
              let num = parseInt(element.totalQuantity);
              if (!Number.isNaN(num)) {
                result += num;
              }
            }
          });
        }
        return result;
      },
      //赠款
      totalIncrease(row) {
        if (row.increases != null) {

        }
      }
    },
    data() {
      return {
        tips: '这里只显示待对账及已对账状态下的收货单',
        shipOrderVisible: false,
        shipId: '',
        receiptOrderVisible: false,
        receiptId: '',
        reconciliationOrderVisible: false,
        reconciliationId: ''
      }
    },
    create() {

    }
  }

</script>

<style scope>
  .purchase-dialog .el-dialog {
    border-radius: 10px !important;
  }

  .purchase-dialog-header {
    padding: 0px !important;
  }

  .purchase-dialog .el-dialog__header {
    padding: 0px !important;
  }

</style>
