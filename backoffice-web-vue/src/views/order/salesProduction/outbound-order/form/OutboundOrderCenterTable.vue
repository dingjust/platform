<template>
  <div style="margin-top: 20px">
    <el-tabs type="border-card">
      <el-tab-pane label="产品明细">
        <el-table ref="resultTable" stripe :data="slotData.entries" highlight-current-row :height="autoHeight">
          <el-table-column label="产品名称" prop="product.name"></el-table-column>
          <el-table-column label="货号" prop="product.skuID"></el-table-column>
          <el-table-column label="品类">
            <template slot-scope="scope">
              <span>{{scope.row.product.category ? scope.row.product.category.name : ''}}</span> </template>
          </el-table-column>
          <el-table-column label="数量" prop="totalQuantity"></el-table-column>
          <el-table-column label="单价/元" prop="billPrice"></el-table-column>
          <el-table-column label="总价/元" prop="totalPrice"></el-table-column>
          <el-table-column label="交货时间">
            <template slot-scope="scope">
              <span>{{scope.row.expectedDeliveryDate | timestampToTime}}</span>
            </template>
          </el-table-column>
<!--          <el-table-column label="关联生产工单" prop="production" min-width="100"></el-table-column>-->
<!--          <el-table-column label="关联采购订单" prop="purchase" min-width="100"></el-table-column>-->
<!--          <el-table-column label="生产进度" prop="progress"></el-table-column>-->
          <el-table-column label="操作" min-width="100">
            <template slot-scope="scope">
              <el-row>
                <el-button type="text" @click="onDetails(scope.row)">详情</el-button>
              </el-row>
            </template>
          </el-table-column>
        </el-table>
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script>
  export default {
    name: 'OutboundOrderCenterTable',
    props: ['slotData'],
    methods: {
      onDetails (row) {
        this.$emit('onDetail', row);
      }
    }
  }
</script>

<style scoped>

</style>
