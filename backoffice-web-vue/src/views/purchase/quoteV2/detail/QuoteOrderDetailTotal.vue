<template>
  <div>
    <el-row type="flex" justify="start">
      <h6 class="additional-title">成本总额：{{totalCost}}</h6>
    </el-row>
    <div>
      <h6 class="additional-title">&#12288;利润率：{{detail.profitRate * 100}}%
        <span style="margin-left: 20px">{{totalProfit.toFixed(2)}}</span>
      </h6>
    </div>
    <div>
      <h6 class="additional-title">档口报价：{{detail.stallQuote}}</h6>
    </div>
    <div>
      <h6 class="additional-title">公司核价：{{detail.companyPricing}}</h6>
    </div>
    <el-row style="margin-top: 10px">
      <h6 class="additional-title">其他备注：<span style="color: #909399">{{detail.remarks ? '' : '无'}}</span></h6>
    </el-row>
    <el-row style="margin-left: 28px" v-if="detail.remarks">
      <h6 class="additional-title">{{detail.remarks}}</h6>
    </el-row>
  </div>
</template>

<script>
export default {
  name: 'QuoteOrderDetailTotal',
  props: ['detail'],
  computed: {
    totalCost: function () {
      let totalCost = 0;
      this.detail.costOrder.workOrders.forEach(item => {
        if (!Number.isNaN(Number.parseFloat(item.totalPrice))) {
          totalCost += Number.parseFloat(item.totalPrice);
        }
      })

      this.detail.costOrder.customRows.forEach(item => {
        if (!Number.isNaN(Number.parseFloat(item.price))) {
          totalCost += Number.parseFloat(item.price);
        }
      })

      return totalCost.toFixed(4);
    },
    totalProfit: function () {
      let profitRate = Number.isNaN(Number.parseFloat(this.detail.profitRate)) ? 
                        0 : Number.parseFloat(this.detail.profitRate);
      return this.totalCost * (1 + profitRate / 100);
    }
  }
}
</script>

<style scoped>
  .purchase-container {
    display: flex;
    flex-wrap: wrap;
    justify-content: space-between;
    align-items: center;
  }

  .additional-title {
    color: #606266;
  }
</style>