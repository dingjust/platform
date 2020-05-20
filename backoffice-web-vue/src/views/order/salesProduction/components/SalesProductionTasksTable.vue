<template>
  <div>
    <el-table :data="data" stripe style="width: 100%">
      <el-table-column type="selection" width="55">
      </el-table-column>
      <el-table-column prop="product.name" label="产品名称"></el-table-column>
      <el-table-column label="数量">
        <template slot-scope="scope">
          <span>{{getEntryTotalAmount(scope.row)}}</span>
        </template>
      </el-table-column>
      <el-table-column prop="unitPrice" label="预计销售单价/元" min-width="100"></el-table-column>
      <el-table-column label="预计销售总价/元" min-width="100">
        <template slot-scope="scope">
          {{getEntryTotalPrice(scope.row)}}
        </template>
      </el-table-column>
      <el-table-column label="预计总成本">
        <template slot-scope="scope">
          {{getEntryTotalCost(scope.row)}}
        </template>
      </el-table-column>
      <el-table-column label="预计利润">
        <template slot-scope="scope">
          {{getEntryProfit(scope.row)}}
        </template>
      </el-table-column>
      <el-table-column label="预计利润率">
        <template slot-scope="scope">
          {{getEntryProfitPercent(scope.row)}}
        </template>
      </el-table-column>
      <el-table-column label="交货时间">
        <template slot-scope="scope">
          <span>{{scope.row.deliveryDate | timestampToTime}}</span>
        </template>
      </el-table-column>
      <el-table-column label="审核状态">
        <template slot-scope="scope">
          <span>{{scope.row.status!=null? getEnum('SalesProductionOrderEntryAuditStatus', scope.row.auditState):''}}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" min-width="120">
        <template slot-scope="scope">
          <!-- <el-button type="text" @click="onProductDetail(scope.row)">详情</el-button> -->
          <el-button type="text" @click="onModify(scope.$index)">编辑</el-button>
          <el-button slot="reference" type="text" @click="onDelete(scope.$index)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>

<script>
  export default {
    name: 'SalesProductionTasksTable',
    components: {},
    props: {
      data: {
        type: Array
      }
    },
    methods: {
      onProductDetail(row) {
        // this.salesProductDetailsVisible = true;
      },
      onDelete(index) {
        this.$emit('onDelete', index);
      },
      onClose() {

      },
      onModify(index) {
        this.$emit('onModify', index);
      },
      //数量
      getEntryTotalAmount(entry) {
        var result = 0;
        entry.colorSizeEntries.forEach(element => {
          let num = parseFloat(element.quantity);
          if (!Number.isNaN(num)) {
            result += num
          }
        });
        return result;
      },
    },
    data() {
      return {

      }
    }
  }

</script>

<style scoped>

</style>
