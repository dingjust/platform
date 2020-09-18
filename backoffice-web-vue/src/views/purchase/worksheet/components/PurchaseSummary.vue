<template>
  <div>
    <el-row type="flex" justify="center">
      <el-col :span="22">
        <h5>完成采购汇总</h5>
      </el-col>
    </el-row>
    <el-row type="flex" justify="center">
      <el-col :span="20">
        <table cellspacing="2" width="100%" class="order-table">
          <!-- 表头 -->
          <tr class="order-table_body-wrapper">
            <template v-for="item in titleRow">
              <th :key="item">{{item}}</th>
            </template>
          </tr>
          <tr>
            <td>{{purchaseName}}</td>
            <td>{{purchaseColor}}</td>
            <td>{{purchaseQuantity}}</td>
            <td>{{purchasePrice}}</td>
            <td>{{purchaseTotalPrice}}</td>
          </tr>
        </table>
      </el-col>
    </el-row>
  </div>
</template>

<script>
export default {
  name: 'PurchaseSummary',
  props: ['formData'],
  computed: {
    purchaseName: function () {
      return '123456';
    },
    purchaseColor: function () {
      return '345678';
    },
    purchaseQuantity: function () {
      return '456789';
    },
    purchasePrice: function () {
      return '678900';
    },
    purchaseTotalPrice: function () {
      return '1678900';
    },
  },
  data () {
    return {
      titleRow: ['物料名称', '物料颜色', '实际采购数量', '实际采购单价', '采购总价']
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