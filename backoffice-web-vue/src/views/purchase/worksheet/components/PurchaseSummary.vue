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
          <template v-if="formData.materials.specList && formData.materials.specList.length> 0">
            <template v-for="item in formData.materials.specList">
              <tr :key="item.id">
                <td>{{formData.materials.name}}</td>
                <td>{{item.colorName}}</td>
                <td>{{item.actuallyOrderQuantity ? item.actuallyOrderQuantity : 0}}</td>
                <td>{{item.actuallyPrice ? item.actuallyPrice : 0}}</td>
                <td>{{item.actuallyTotalPrice ? item.actuallyTotalPrice : 0}}</td>
                <td>{{item.receiveQuantity ? item.receiveQuantity : 0}}</td>
                <td>{{item.remainQuantity ? item.remainQuantity : getRemainQuantity(item.actuallyOrderQuantity, item.receiveQuantity)}}</td>
              </tr>
            </template>
          </template>
          <template v-else>
            <tr>
              <td :colspan="titleRow.length">暂无数据</td>
            </tr>
          </template>
        </table>
      </el-col>
    </el-row>
  </div>
</template>

<script>
export default {
  name: 'PurchaseSummary',
  props: ['formData', 'purchaseOrderList'],
  methods: {
    getRemainQuantity (actuallyOrderQuantity, receiveQuantity) {
      let actQuantity = Number.isNaN(Number.parseFloat(actuallyOrderQuantity)) ? 0 : Number.parseFloat(actuallyOrderQuantity); 
      let recQuantity = Number.isNaN(Number.parseFloat(receiveQuantity)) ? 0 : Number.parseFloat(receiveQuantity);
      return (actQuantity - recQuantity) > 0 ? (actQuantity - recQuantity).toFixed(2) : 0;
    }
  },
  data () {
    return {
      titleRow: ['物料名称', '物料颜色', '实际采购数量', '实际采购单价', '采购总价', '实际回料数', '缺料数']
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