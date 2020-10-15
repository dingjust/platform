<template>
  <div>
    <el-row type="flex" justify="end">
      <h6 style="margin-right: 20px">单位：{{'米'}}</h6>
    </el-row>
    <table cellspacing="2" width="100%" class="order-table">
      <!-- 表头 -->
      <tr class="order-table_body-wrapper">
        <template v-for="item in titleRow">
          <th :key="item">{{item}}</th>
        </template>
      </tr>
      <template v-if="materials && materials.length > 0">
        <template v-for="(item, index) in materials">
          <tr :key="index">
            <td>{{item.name}}</td>
            <td>{{item.colorName}}</td>
            <td>{{item.modelName}}</td>
            <td>{{item.specName}}</td>
            <td>{{item.unitQuantity}}</td>
            <td>{{item.estimatedLoss * 100}}%</td>
            <td>{{item.estimatedUsage}}</td>
            <td>{{item.orderCount}}</td>
            <td>{{item.emptySent * 100}}%</td>
            <td>{{item.requiredAmount}}</td>
            <td>{{item.price}}</td>
            <td>{{item.totalPrice}}</td>
          </tr>
        </template>
      </template>
      <template v-else>
        <tr>
          <td :colspan="titleRow.length">暂无数据</td>
        </tr>
      </template>
      <tr>
        <td :colspan="7">总计</td>
        <td>{{totalOrderCount}}</td>
        <td></td>
        <td>{{totalRequiredAmount}}</td>
        <td></td>
        <td>{{totalMaterialPrice}}</td>
      </tr>
    </table>
  </div>
</template>

<script>
export default {
  name: 'PurchaseInfoTable',
  props: ['materials'],
  computed: {
    totalOrderCount: function () {
      let count = 0;
      this.materials.forEach(item => {
        if (typeof item.orderCount === 'number') {
          count += item.orderCount;
        }
      })
      return count;  
    },
    totalRequiredAmount: function () {
      let count = 0;
      this.materials.forEach(item => {
        if (typeof item.requiredAmount === 'number') {
          count += item.requiredAmount;
        }
      })  
      return count.toFixed(2);  
    },
    totalMaterialPrice: function () {
      let count = 0;
      this.materials.forEach(item => {
        if (typeof item.totalPrice === 'number') {
          count += item.totalPrice;
        }
      })  
      return count.toFixed(2);  
    }
  },
  data () {
    return {
      titleRow: ['物料名称', '物料颜色', '幅宽/型号', '克重/规格', '单件用量', '耗量', '实际用量', '订单数', '空差', '需求总数', '物料单价', '总金额']
    }
  }  
}
</script>

<style scoped>
  .order-table {
    width: 100%;
    height: 100%; 
    border-collapse: collapse;
    margin-bottom: 20px;
    border: 2px solid #EBEEF5;;
  }

  .order-table tr td,
  .order-table tr th {
    text-align: center;
    height: 40px;
    font-size: 10px;
    border-right: 2px solid #EBEEF5;
    border-bottom: 2px solid #EBEEF5;
  }
</style>