<template>
  <div>
    <el-row type="flex" justify="start">
      <h6 class="additional-title">成本总额：{{detail.costOrder.totalCost}}</h6>
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
    totalProfit: function () {
      return this.detail.costOrder.totalCost * (1 + this.detail.profitRate)
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