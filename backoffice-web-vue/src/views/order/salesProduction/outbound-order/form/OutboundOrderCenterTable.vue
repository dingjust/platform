<template>
  <div style="margin-top: 20px">
    <el-tabs type="border-card">
      <el-tab-pane label="产品明细">
        <el-table ref="resultTable" stripe :data="page.content">
          <el-table-column label="产品名称" prop="name"></el-table-column>
          <el-table-column label="货号" prop="code"></el-table-column>
          <el-table-column label="品类">
            <template slot-scope="scope">
              <span>{{scope.row.category.name}}</span> </template>
          </el-table-column>
          <el-table-column label="数量" prop="quantity"></el-table-column>
          <el-table-column label="单价/元" prop="price"></el-table-column>
          <el-table-column label="总价/元" prop="totalPrice"></el-table-column>
          <el-table-column label="交货时间">
            <template slot-scope="scope">
              <span>{{scope.row.deliveryTime | timestampToTime}}</span>
            </template>
          </el-table-column>
          <el-table-column label="关联生产工单" prop="production" min-width="100"></el-table-column>
          <el-table-column label="关联采购订单" prop="purchase" min-width="100"></el-table-column>
          <el-table-column label="生产进度" prop="progress"></el-table-column>
          <el-table-column label="操作" min-width="100">
            <template slot-scope="scope">
              <el-row>
                <el-button type="text" @click="onDetails(scope.row)">详情</el-button>
              </el-row>
            </template>
          </el-table-column>
        </el-table>
        <div class="pt-2"></div>
        <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper"
                       @size-change="onPageSizeChanged" @current-change="onCurrentPageChanged" :current-page="page.number + 1"
                       :page-size="page.size" :page-count="page.totalPages" :total="page.totalElements">
        </el-pagination>
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script>
  export default {
    name: 'OutboundOrderCenterTable',
    props: ['page'],
    methods: {
      onPageSizeChanged (val) {
        this.$emit('onAdvancedSearch', 0, val);
      },
      onCurrentPageChanged (val) {
        this.$emit('onAdvancedSearch', val - 1);
      }
    }
  }
</script>

<style scoped>

</style>
