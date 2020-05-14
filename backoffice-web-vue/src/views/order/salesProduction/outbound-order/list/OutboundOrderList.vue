<template>
  <div class="animated fadeIn">
    <el-table ref="resultTable" stripe :data="page.content">
      <el-table-column label="生产订单号" prop="code"></el-table-column>
      <el-table-column label="工厂" prop="factory"></el-table-column>
      <el-table-column label="关联产品数" prop="relevanQuantity"></el-table-column>
      <el-table-column label="负责人" prop="charge"></el-table-column>
      <el-table-column label="审批状态" prop="status">
      </el-table-column>
      <el-table-column label="订单标签" min-width="100"></el-table-column>
      <el-table-column label="操作" min-width="100">
        <template slot-scope="scope">
          <el-row>
            <el-button type="text" @click="onDetails(scope.row)" class="purchase-list-button">详情</el-button>
          </el-row>
        </template>
      </el-table-column>
    </el-table>
    <div class="pt-2"></div>
    <!-- <div class="float-right"> -->
    <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper"
                   @size-change="onPageSizeChanged" @current-change="onCurrentPageChanged" :current-page="page.number + 1"
                   :page-size="page.size" :page-count="page.totalPages" :total="page.totalElements">
    </el-pagination>
    <!-- </div> -->
  </div>
</template>

<script>
  export default {
    name: 'OutboundOrderList',
    props: ['page'],
    methods: {
      onPageSizeChanged (val) {
        this.$emit('onAdvancedSearch', 0, val);
      },
      onCurrentPageChanged (val) {
        this.$emit('onAdvancedSearch', val - 1);
      },
      onDetails (row) {

      }
    }
  }
</script>

<style scoped>

</style>
