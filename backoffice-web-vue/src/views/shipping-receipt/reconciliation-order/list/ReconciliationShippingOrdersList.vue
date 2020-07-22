<template>
  <div class="table-container">
    <el-table ref="table" :data="reconciliationShippingOrders" style="width: 100%"
      @selection-change="handleSelectionChange" show-summary :summary-method="getSummaries">
      <el-table-column type="selection" width="55" v-if="!readOnly"></el-table-column>
      <el-table-column label="发货单号" prop="code"></el-table-column>
      <el-table-column label="发货数" prop="totalQuantity"></el-table-column>
      <el-table-column label="收货单">
        <template slot-scope="scope">
          <el-row v-for="item in scope.row.receiptSheets" :key="item.id">
            <el-button type="text" @click="onReceiptDetail(item)">{{item.code}}</el-button>
          </el-row>
        </template>
      </el-table-column>
      <el-table-column label="收货时间">
        <template slot-scope="scope">
          <span>{{scope.row.receiptSheets[0].creationtime | timestampToTime}}</span>
        </template>
      </el-table-column>
      <el-table-column label="收货数量" prop="expectedQuantity">
        <template slot-scope="scope">
          {{receiptNum(scope.row.receiptSheets)}}
        </template>
      </el-table-column>
      <el-table-column label="收货总额" prop="totalPrice">
        <template slot-scope="scope">
          <span>{{totalReceiptAmount(scope.row.receiptSheets)}}</span>
        </template>
      </el-table-column>
    </el-table>
    <el-dialog :visible.sync="receiptOrderVisible" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <receipt-order-detail v-if="receiptOrderVisible" :id="receiptId" />
    </el-dialog>
  </div>
</template>

<script>
  import ReceiptOrderDetail from '../../receipt-order/details/ReceiptOrderDetail'

  export default {
    name: 'ReconciliationShippingOrdersList',
    props: {
      formData: {
        type: Object,
        required: true
      },
      readOnly: {
        type: Boolean,
        default: false
      }
    },
    components: {
      ReceiptOrderDetail
    },
    computed: {
      //筛选待对账发货单
      reconciliationShippingOrders: function () {
        let data = this.formData.shippingTask.shippingSheets.filter(sheet => sheet.state == 'PENDING_RECONCILED');
        if (data != null && data.length > 0) {          
          return data;
        } else {
          return [];
        }
      }
    },
    methods: {
      handleSelectionChange(selectionList) {
        this.$set(this.formData, 'shippingSheets', selectionList);
      },
      onReceiptDetail(item) {
        // this.$router.push('/receipt/orders/' + item.id);
        this.$set(this, 'receiptId', item.id);
        this.receiptOrderVisible = true;
      },
      //收货数
      receiptNum(sheets) {
        let result = 0;
        if (sheets != null) {
          sheets.forEach(element => {
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
      //收货总额
      totalReceiptAmount(sheets) {
        let unitPrice = 0;
        if (this.formData.productionTaskOrder.unitPrice) {
          unitPrice = this.formData.productionTaskOrder.unitPrice;
        }
        let totalNum = this.receiptNum(sheets);
        return unitPrice * totalNum;
      },
      getSummaries(param) {
        const {
          columns,
          data
        } = param;
        const sums = [];
        columns.forEach((column, index) => {
          if (index === 2) {
            sums[index] = '合计';
            return;
          }
          //合计选中收货总数
          if (index === 5) {
            let result = 0;
            this.formData.shippingSheets.forEach(element => {
              element.receiptSheets.forEach(entry => {
                let num = parseInt(entry.totalQuantity);
                if (!Number.isNaN(num)) {
                  result += num;
                }
              })
            });
            sums[index] = result;

            //总额
            let unitPrice = 0;
            if (this.formData.productionTaskOrder.unitPrice) {
              unitPrice = this.formData.productionTaskOrder.unitPrice;
            }
            sums[index + 1] = result * unitPrice;
            return;
          }
        });

        return sums;
      },
      currentSelect() {

      }
    },
    data() {
      return {
        receiptOrderVisible: false,
        receiptId: '',
      }
    },
    watch: {
      'formData.shippingTask.shippingSheets': function (newVal, oldVal) {
        this.$nextTick(() => {
          this.currentSelect();
        })
      }
    }
  }

</script>

<style scoped>
  .table-container {
    border: 1px solid #E5E5E5;
    border-bottom: 0px;
  }

  .table-container>>>.el-table--enable-row-hover .el-table__body tr:hover>td {
    background-color: white;
  }

</style>
