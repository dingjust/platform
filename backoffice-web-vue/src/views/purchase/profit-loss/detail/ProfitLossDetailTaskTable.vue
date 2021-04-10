<!--
* @Description: 盈亏分析详情工单信息表
* @Date 2021/03/25 14:34
* @Author L.G.Y
-->
<template>
  <div class="detail-container">
    <div v-if="!showWhole">
      <h6 class="table-title">生产工单：{{taskRow[0].productionTaskOrderCode}}</h6>
    </div>
    <el-table ref="reusltTable" border :data="tableData">
      <el-table-column label="基本信息" header-align="center">
        <el-table-column label="款号" prop="skuID"></el-table-column>
        <el-table-column label="品类" prop="category.name"></el-table-column>
        <el-table-column label="颜色">
          <template slot-scope="scope">
            <span>{{colorName(scope.row)}}</span>
          </template>
        </el-table-column>
      </el-table-column>
      <el-table-column label="客户报价" header-align="center">
        <el-table-column label="合同单价" prop="unitContractAmount"></el-table-column>
        <el-table-column label="数量" prop="totalQuantity"></el-table-column>
        <el-table-column label="合同金额" prop="totalContractAmount"></el-table-column>
      </el-table-column>
      <el-table-column label="成本费用" header-align="center">
        <el-table-column label="单价成本" prop="unitCostAmount"></el-table-column>
        <el-table-column label="成本总额" prop="totalCostAmount"></el-table-column>
        <template v-if="taskRow[0].additionalCharges && taskRow[0].additionalCharges.length > 0">
          <el-table-column v-for="(column, index) in taskRow[0].additionalCharges" :key="column.id">
            <template slot="header" slot-scope="scope">
              <div style="display: flex;align-items: center">
                <span>{{column.remarks}}</span>
              </div>
            </template>
            <template slot-scope="scope">
              <span v-if="scope.row.additionalCharges">{{scope.row.additionalCharges[index].amount}}</span>
            </template>
          </el-table-column>
        </template>
        <el-table-column label="总金额" prop="totalAmount"></el-table-column>
      </el-table-column>
      <el-table-column label="盈亏分析" header-align="center">
        <el-table-column label="总盈亏" prop="totalProfitLossAmount"></el-table-column>
        <el-table-column label="盈亏比列" prop="profitLossRatio">
          <template slot-scope="scope">
            <span>{{(scope.row.profitLossRatio * 100).toFixed(2)}}%</span>
          </template>
        </el-table-column>
      </el-table-column>
      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-button v-if="scope.row.skuID !== '合计' && !scope.row.purchaseTaskId" type="text" @click="onCreatePurchase(scope.row)">创建采购</el-button>
          <el-button type="text" v-if="scope.row.purchaseTaskId" @click="onPurchaseDetail(scope.row)">采购详情</el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>

<script>
export default {
  name: 'ProfitLossDetailTaskTable',
  props: ['detail', 'taskRow', 'showWhole'],
  computed: {
    tableData: function () {
      let stack = [];
      stack = stack.concat(this.taskRow);

      stack.push({
        skuID: '合计',
        totalQuantity: this.countColumn(this.taskRow, 'totalQuantity').toFixed(0),
        totalContractAmount: this.countColumn(this.taskRow, 'totalContractAmount').toFixed(2),
        totalCostAmount: this.countColumn(this.taskRow, 'totalCostAmount').toFixed(2),
        totalAmount: this.countColumn(this.taskRow, 'totalAmount').toFixed(2),
        totalProfitLossAmount: this.totalProfitLossAmount.toFixed(2),
        profitLossRatio: this.profitLossRatio
      })
      return stack;
    },
    totalProfitLossAmount: function () {
      return this.countColumn(this.taskRow, 'totalContractAmount') - this.countColumn(this.taskRow, 'totalAmount');
    },
    profitLossRatio: function () {
      return this.totalProfitLossAmount / this.countColumn(this.taskRow, 'totalContractAmount');
    }
  },
  methods: {
    countColumn (arr, attribute) {
      let count = 0;
      arr.forEach(item => {
        if (!Number.isNaN(Number.parseFloat(item[attribute]))) {
          count += Number.parseFloat(item[attribute]);
        }
      })
      
      return arr.some(item => !Number.isNaN(Number.parseFloat(item[attribute]))) ? count : 0;
    },
    colorName (row) {
      if (row.colors) {
        let str = ''
        row.colors.forEach(item => {
          str += (item.name + ',')
        })
  
        return str.substring(0, str.length - 2);
      }
    },
    onCreatePurchase (row) {
      this.$router.push({
        name: '创建采购需求',
        params: {
          row: {
            id: row.id,
            name: row.skuID + ' / ' + this.colorName(row),
            workOrders: row.costOrder.purchaseMaterials.map(item => {
              return {
                name: item.name,
                materialsType: item.materialsType,
                code: item.code,
                unit: item.unit,
                modelName: item.specList[0].modelName ? item.specList[0].modelName : '',
                specName: item.specList[0].specName ? item.specList[0].specName : '',
                colorName: item.specList[0].colorName ? item.specList[0].colorName : '',
                unitQuantity: item.specList[0].unitQuantity ? item.specList[0].unitQuantity : '',
                estimatedLoss: item.specList[0].estimatedLoss ? item.specList[0].estimatedLoss : '',
                estimatedUsage: item.specList[0].estimatedUsage ? item.specList[0].estimatedUsage : '',
                orderCount: item.specList[0].orderCount ? item.specList[0].orderCount : '',
                emptySent: item.specList[0].emptySent ? item.specList[0].emptySent : '',
                requiredAmount: item.specList[0].requiredAmount ? item.specList[0].requiredAmount : '',
                price: item.specList[0].price ? item.specList[0].price : '',
                totalPrice: item.specList[0].totalPrice ? item.specList[0].totalPrice : ''
              }
            })
          }
        }
      })
    },
    onPurchaseDetail (row) {
      this.$router.push('/purchase/requirement/' + row.purchaseTaskId);
    }
  }
}
</script>

<style scoped>
  .detail-container {
    margin: 0px 0px 20px 20px;
  }

  /deep/ .el-table--enable-row-hover .el-table__body tr:hover > td {
    background-color: #ffffff !important;
  }

  .table-title {
    font-size: 14px;
    color: #606266;
  }
</style>