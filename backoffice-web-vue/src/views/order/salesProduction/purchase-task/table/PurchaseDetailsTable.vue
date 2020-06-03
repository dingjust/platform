<template>
  <div>
    <el-table v-if="isHeightComputed" ref="resultTable" stripe :data="formData" :height="autoHeight">
      <el-table-column label="物料名称" prop="name" min-width="120" fixed/>
      <el-table-column label="物料编号" prop="code" min-width="120" fixed/>
      <el-table-column label="物料规格" prop="spec" min-width="120"/>
      <el-table-column label="物料单位" prop="unit" min-width="80"/>
      <el-table-column label="物料属性" prop="property" min-width="80"/>
      <el-table-column label="单位实际用量" prop="unitQuantity" min-width="100"/>
      <el-table-column label="物料颜色" prop="color" min-width="80"/>
      <el-table-column label="对应成衣颜色" prop="sampleColor" min-width="100"/>
      <el-table-column label="订单数" prop="orderQuantity" min-width="80"/>
      <el-table-column label="物料需求数" prop="materialQuantity" min-width="100"/>
      <el-table-column label="加减数量" prop="floatQuantity" min-width="80"/>
      <el-table-column label="实际采购数" prop="quantity" min-width="100"/>
      <el-table-column label="实际采购总数数" prop="countQuantity" min-width="110"/>
      <el-table-column label="含税单价" prop="taxPrice" min-width="100"/>
      <el-table-column label="含税总价" prop="totalPrice" min-width="120"/>
      <el-table-column label="采购期望" prop="expected" min-width="100"/>
      <el-table-column label="操作" min-width="100" fixed="right">
        <template slot-scope="scope">
          <el-button type="text">详情</el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>

<script>
  export default {
    name: 'PurchaseDetailsTable',
    props: ['formData']
  }
</script>

<style scoped>

</style>
