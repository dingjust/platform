<template>
  <div class="table-container">
    <el-table ref="table" :data="tableData" style="width: 100%" 
      :header-cell-style="{'text-align':'center'}" :cell-style="cellStyle"
      :span-method="arraySpanMethod"
      @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" v-if="!readOnly"></el-table-column>
      <el-table-column label="发货单号" prop="code"></el-table-column>
      <el-table-column label="单价" prop="price"></el-table-column>
      <el-table-column label="发货数" prop="quantity"></el-table-column>
      <el-table-column label="收货时间">
        <template slot-scope="scope">
          <span>{{scope.row.expectedDeliveryDate | timestampToTime}}</span>
        </template>
      </el-table-column>
      <el-table-column label="收货数量" prop="expectedQuantity"></el-table-column>
      <el-table-column label="收货总额" prop="totalPrice">
        <template slot-scope="scope">
          <span>{{scope.row.totalPrice}}元</span>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>

<script>
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

    },
    computed: {
      tableData: function () {
        // TODO 处理展示表单数据
        let showData = Object.assign([], this.formData.testData);
        let totalRow = {
          code: '合计',
          expectedQuantity: 0,
          totalPrice: 0
        };
        this.formData.testData.forEach(item => {
          totalRow.expectedQuantity += item.expectedQuantity;
          totalRow.totalPrice += item.totalPrice;
        })
        showData.push(totalRow);
        return showData;
      }
    },
    methods: {
      handleSelectionChange (selectionList) {
        console.log(selectionList);
      },
      cellStyle ({ row, column, rowIndex, columnIndex }) {
        let obj = {'text-align': 'center'};
        if (rowIndex === this.tableData.length - 1 && columnIndex != 1) {
          obj = {
            'text-align': 'center',
            'border-left': '1px solid #E5E5E5'
          }
        }
        return obj;
      },
      // 合并表单单元格
      arraySpanMethod({ row, column, rowIndex, columnIndex }) {
        if (this.tableData.length <= 0) {
          return;
        }
        if (rowIndex === this.tableData.length - 1 && !this.readOnly) {
          if (columnIndex === 0 || (columnIndex < 5 && columnIndex > 1)) {
            return [0, 0];
          } else  if (columnIndex === 1) {
            return [1, 5];
          } else if (columnIndex > 5) {
            return [1, 1];
          }
        } else if (rowIndex === this.tableData.length - 1 && this.readOnly) {
          if (columnIndex == 0) {
            return [1, 4];
          } else if (columnIndex > 3) { 
            return [1, 1];
          } else {
            return [0, 0];
          }
        }
      },
    },
    data () {
      return {

      }
    },
    created () {
    }    
  }
</script>

<style scoped>
  .table-container {
    border: 1px solid #E5E5E5;
    border-bottom: 0px;
  }

  .table-container >>> .el-table--enable-row-hover .el-table__body tr:hover > td {
    background-color: white;
  }
</style>