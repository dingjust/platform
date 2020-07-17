<template>
  <div class="table-container">
    <el-table ref="table" :data="formData.shippingSheets" style="width: 100%" show-summary
      :summary-method="getSummaries">
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
  </div>
</template>

<script>
  export default {
    name: 'ShippingOrdersList',
    props: {
      formData: {
        type: Object,
        required: true
      },
    },
    components: {

    },
    computed: {},
    methods: {
      handleSelectionChange(selectionList) {
        this.$set(this.formData, 'shippingSheets', selectionList);
      },
      onReceiptDetail(item) {
        this.$router.push('/receipt/orders/' + item.id);
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
          if (index === 4) {
            let result = 0;
            if (this.formData.shippingSheets) {
              this.formData.shippingSheets.forEach(element => {
                if (element.receiptSheets != null) {
                  element.receiptSheets.forEach(entry => {
                    let num = parseInt(entry.totalQuantity);
                    if (!Number.isNaN(num)) {
                      result += num;
                    }
                  })
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
