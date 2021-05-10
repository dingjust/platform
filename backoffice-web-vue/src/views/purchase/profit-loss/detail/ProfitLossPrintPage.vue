<!--
* @Description: ProfitLossPrintPage 盈亏分析打印页面
* @Date 2021/04/26 09:27
* @Author L.G.Y
-->
<template>
  <div>
    <table cellspacing="2" width="100%" :height="(taskRow.length + 1) * 50" class="order-table">
      <tr style="background: #F5F7FA;color: #909399">
        <th :colspan="3">基本信息</th>
        <th :colspan="3">客户报价</th>
        <th :colspan="3 + additionalCharges.length">成本费用</th>
        <th :colspan="2">盈亏分析</th>
      </tr>
      <tr style="background: #F5F7FA;color: #909399">
        <th>款号</th>
        <th>品类</th>
        <th>颜色</th>
        <th>合同单价</th>
        <th>数量</th>
        <th>合同金额</th>
        <th>单价成本</th>
        <th>成本总额</th>
        <template v-for="additionalCharge in additionalCharges">
          <th :key="additionalCharge.id">{{additionalCharge.remarks}}</th>
        </template>
        <th>总金额</th>
        <th>总盈亏</th>
        <th>盈亏比例</th>
      </tr>
      <template v-for="row in tableData">
        <tr :key="row.id">
          <td>{{row.skuID}}</td>
          <td>{{row.category ? row.category.name : ''}}</td>
          <td>{{colorName(row)}}</td>
          <td>{{row.unitContractAmount}}</td>
          <td>{{row.totalQuantity}}</td>
          <td>{{row.totalContractAmount}}</td>
          <td>{{row.unitCostAmount}}</td>
          <td>{{row.totalCostAmount}}</td>
          <td>{{row.totalAmount}}</td>
          <template v-for="additionalCharge in additionalCharges">
            <td :key="additionalCharge.id">
              {{row.additionalCharges ? additionVal(additionalCharge, row.additionalCharges) : ''}}
            </td>
          </template>
          <td>{{row.totalProfitLossAmount}}</td>
          <td>{{(row.profitLossRatio * 100).toFixed(2)}}%</td>
        </tr>
      </template>
    </table>
  </div>
</template>

<script>
export default {
  name: 'ProfitLossPrintPage',
  props: ['detail', 'taskRow'],
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
      additionalCharges: []
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
    additionVal (column, additionalCharges) {
      const index = additionalCharges.findIndex(item => item.remarks === column.remarks);
      return index > -1 ? additionalCharges[index].amount : '';
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
    initAdditionalCharges () {
      this.taskRow.forEach(item => {
        if (item.additionalCharges && item.additionalCharges.length > 0) {
          item.additionalCharges.forEach(val => {
            if (this.additionalCharges.findIndex(v => v.remarks === val.remarks) < 0) {
              this.additionalCharges.push(val);
            }
          })
        }
      })
    }
  },
  mounted () {
    this.initAdditionalCharges();
  }
}
</script>

<style scoped>
  .order-table {
    border-collapse: collapse;
    margin-bottom: 20px;
  }

  .order-table tr td,
  .order-table tr th {
    border: 1px solid #EBEEF5;
    text-align: center;
    height: 30px;
    font-size: 10px;
  }
</style>