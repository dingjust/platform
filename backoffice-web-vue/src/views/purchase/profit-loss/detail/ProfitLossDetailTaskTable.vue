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
        <el-table-column label="单价成本" prop="unitCostAmount">
          <template slot-scope="scope">
            <div class="top-row">
              <span>{{scope.row.unitCostAmount}}</span>
              <div v-if="scope.row.skuID !== '合计'">
                <el-button style="padding: 0px" type="text" @click="onCostDetail(scope.row)">详情</el-button>
              </div>
            </div>
          </template>
        </el-table-column>
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
          <el-button v-if="canPurchase(scope.row)" type="text" @click="onCreatePurchase(scope.row)">创建采购</el-button>
          <el-button type="text" v-if="scope.row.purchaseTaskId" @click="onPurchaseDetail(scope.row)">采购详情</el-button>
        </template>
      </el-table-column>
    </el-table>
    <el-dialog :visible.sync="costVisible" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <cost-order-detail v-if="costVisible" :id="costId" :isFormDialog="true" @callback="costVisible=false"/>
    </el-dialog>
  </div>
</template>

<script>
import CostOrderDetail from '../../cost/details/CostOrderDetail.vue';
export default {
  name: 'ProfitLossDetailTaskTable',
  props: ['detail', 'taskRow', 'showWhole'],
  components: {
    CostOrderDetail
  },
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
  data () {
    return {
      costVisible: false,
      costId: null
    }
  },
  methods: {
    onCostDetail (row) {
      this.costVisible = true;
      this.costId = row.costOrder.id;
    },
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
    canPurchase (row) {
      return row.skuID !== '合计' && !row.purchaseTaskId && this.detail.status !== 'CANCELLED';
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
                cooperatorName: item.factoryName,
                modelName: item.specList[0].modelName ? item.specList[0].modelName : '',
                specName: item.specList[0].specName ? item.specList[0].specName : '',
                colorName: item.specList[0].colorName ? item.specList[0].colorName : '',
                unitQuantity: row.totalQuantity,
                estimatedLoss: item.specList[0].estimatedLoss ? item.specList[0].estimatedLoss : '',
                estimatedUsage: item.specList[0].estimatedUsage ? item.specList[0].estimatedUsage : '',
                orderCount: item.specList[0].orderCount ? item.specList[0].orderCount : '',
                emptySent: item.specList[0].emptySent ? item.specList[0].emptySent : '',
                requiredAmount: item.specList[0].requiredAmount ? item.specList[0].requiredAmount : '',
                price: item.specList[0].price ? item.specList[0].price : '',
                totalPrice: item.specList[0].totalPrice ? item.specList[0].totalPrice : '',
                composition: item.specList[0].composition ? item.specList[0].composition : '',
                purpose: item.specList[0].purpose ? item.specList[0].purpose : '',
                quoteLossRate: item.specList[0].quoteLossRate ? item.specList[0].quoteLossRate : '',
                quoteAmount: item.specList[0].quoteAmount ? item.specList[0].quoteAmount : '',
                remarks: item.specList[0].remarks ? item.specList[0].remarks : ''
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

  .top-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
  }
</style>