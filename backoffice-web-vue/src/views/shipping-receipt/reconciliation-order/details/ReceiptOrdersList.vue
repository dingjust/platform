<template>
  <div class="table-container">
    <el-table ref="table" :data="formData.receiptSheets" style="width: 100%" show-summary
      :summary-method="getSummaries">
      <el-table-column label="发货单号" prop="code"></el-table-column>
      <el-table-column label="发货数" prop="totalQuantity"></el-table-column>
      <el-table-column label="收货单">
        <template slot-scope="scope">
          <el-button type="text" @click="onReceiptDetail(scope.row)">{{scope.row.code}}</el-button>
        </template>
      </el-table-column>
      <el-table-column label="收货时间">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | timestampToTime}}</span>
        </template>
      </el-table-column>
      <el-table-column label="收货数量" prop="totalQuantity" />
      <el-table-column label="收货总额" prop="totalPrice">
        <template slot-scope="scope">
          <span>{{totalReceiptAmount(scope.row)}}</span>
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
    name: 'ReceiptOrdersList',
    props: {
      formData: {
        type: Object,
        required: true
      },
    },
    components: {
      ReceiptOrderDetail
    },
    computed: {},
    methods: {
      handleSelectionChange(selectionList) {
        this.$set(this.formData, 'receiptSheets', selectionList);
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
      totalReceiptAmount(sheet) {
        let unitPrice = 0;
        if (this.formData.productionTaskOrder.unitPrice) {
          unitPrice = this.formData.productionTaskOrder.unitPrice;
        }
        return unitPrice * sheet.totalQuantity;
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
          if (index === 4) {
            let result = 0;
            if (this.formData.receiptSheets) {
              this.formData.receiptSheets.forEach(element => {
                let num = parseInt(element.totalQuantity);
                if (!Number.isNaN(num)) {
                  result += num;
                }
              });
            }
            sums[index] = result;

            //总额
            let unitPrice = 0;
            if (this.formData.productionTaskOrder && this.formData.productionTaskOrder.unitPrice) {
              unitPrice = this.formData.productionTaskOrder.unitPrice;
            }
            sums[index + 1] = result * unitPrice;
            return;
          }
        });
        return sums;
      }
    },
    data() {
      return {
        receiptOrderVisible: false,
        receiptId: '',
      }
    },
    created() {}
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
