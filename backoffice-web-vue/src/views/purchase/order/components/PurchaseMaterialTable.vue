<template>
  <div class="purchase-material-table">
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
      <template v-if="formData.entries && formData.entries.length > 0">
        <template v-for="(item, index) in formData.entries">
          <tr :key="index">
            <td>{{item.name}}</td>
            <td>{{item.color}}</td>
            <td>{{item.spec}}</td>
            <td>{{item.guige}}</td>
            <td style="min-width: 100px">
              <el-input v-model="item.emptionQuantity" type="number" v-number-input.float="{ min: 0, decimal: 0}" />
            </td>
            <td style="min-width: 100px">
              <el-input v-model="item.materialPrice" type="number" v-number-input.float="{ min: 0, decimal: 2}" />
            </td>
            <td style="min-width: 100px">{{item.totalPrice}}</td>
            <td>
              <el-date-picker v-model="item.time" style="width: 130px" type="date" placeholder="选择日期" value-format="timestamp" />
            </td>
          </tr>
        </template>
      </template>
      <template v-else>
        <tr>
          <td :colspan="titleRow.length">暂无数据</td>
        </tr>
      </template>
      <tr>
        <td :colspan="5">总计</td>
        <td>1</td>
        <td>2</td>
        <td>3</td>
      </tr>
    </table>
  </div>
</template>

<script>
export default {
  name: 'PurchaseMaterialTable',
  props: ['formData'],
  data () {
    return {
      titleRow: ['物料名称', '物料颜色', '幅宽/型号', '克重/规格', '下单数', '物料单价', '总金额', '到料时间']
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

  .purchase-material-table >>> .el-input__inner {
    text-align: center;
    border: 0px solid #DCDFE6;
  }
</style>