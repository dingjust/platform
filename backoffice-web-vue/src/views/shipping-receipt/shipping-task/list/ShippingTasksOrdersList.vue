<template>
  <div>
    <el-table ref="resultTable" stripe :data="formData.shippingSheets" :height="autoHeight">
      <el-table-column label="发货单号" prop="code" min-width="120">
        <template slot-scope="scope">
          <el-button type="text" @click="onShippingSheetDetail(scope.row.id)">{{scope.row.code}}</el-button>
        </template>
      </el-table-column>
      <el-table-column label="发货数量" prop="totalQuantity"></el-table-column>
      <el-table-column label="发货时间">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | formatDate}}</span>
        </template>
      </el-table-column>
      <el-table-column label="收货单">
        <template slot-scope="scope">
          <template v-for="(sheet,sheetIndex) in scope.row.receiptSheets">
            <el-row :key="'sheet'+sheetIndex" type="flex">
              <el-button type="text" @click="onReceiptDetail(scope.row.receiptSheets[sheetIndex].id)">
                {{scope.row.receiptSheets[sheetIndex].code}}</el-button>
            </el-row>
          </template>
        </template>
      </el-table-column>
      <el-table-column label="收货数">
        <template slot-scope="scope" v-if="scope.row.receiptSheets!=null">
          <span>{{countTotalSheetsNum(scope.row.receiptSheets)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="收货时间">
        <template slot-scope="scope" v-if="scope.row.receiptSheets!=null">
          <span>{{scope.row.receiptSheets[0].creationtime | formatDate}}</span>
        </template>
      </el-table-column>
      <el-table-column label="退货单">
        <template slot-scope="scope" v-if="scope.row.returnSheets!=null">
          <template v-for="(sheet,sheetIndex) in scope.row.returnSheets">
            <el-row :key="'sheet'+sheetIndex" type="flex">
              <el-button type="text" @click="onReturnDetail(scope.row.returnSheets[sheetIndex].id)">
                {{scope.row.returnSheets[sheetIndex].code}}</el-button>
            </el-row>
          </template>
        </template>
      </el-table-column>
      <el-table-column label="退货数">
        <template slot-scope="scope" v-if="scope.row.returnSheets!=null">
          <span>{{countTotalSheetsNum(scope.row.returnSheets)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="差异数" prop="diffQuantity"></el-table-column>
      <el-table-column align="right" min-width="120" v-if="!readOnly">
        <template slot="header">
          <el-button @click="onCreate">创建发货订单</el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>

<script>
  export default {
    name: 'ShippingTasksOrdersList',
    props: ['formData', 'readOnly'],
    components: {

    },
    computed: {},
    methods: {
      onCreate() {
        this.$emit('onCreate');
      },
      onShippingSheetDetail(id) {
        this.$router.push('/shipping/orders/' + id);
      },
      onReceiptDetail(id) {
        this.$router.push('/receipt/orders/' + id);
      },
      onReturnDetail(id) {

      },
      //统计单数
      countTotalSheetsNum(sheets) {
        let result = 0;
        sheets.forEach(element => {
          let num = parseInt(element.totalQuantity);
          if (!Number.isNaN(num)) {
            result += num;
          }
        });
        return result;
      }
    },
    data() {
      return {

      }
    },
    create() {

    }
  }

</script>

<style scope>

</style>
