<template>
  <div>
    <el-table ref="resultTable" stripe="" :data="page.content" :height="autoHeight">
      <el-table-column label="单号" prop="code"></el-table-column>
      <el-table-column label="关联产品" prop="product.name"></el-table-column>
      <el-table-column label="款号" prop="product.skuID"></el-table-column>
      <el-table-column label="创建人" prop="creator.name"></el-table-column>
      <el-table-column label="创建时间" min-width="80">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | timestampToTime}}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="100" min-width="100">
        <template slot-scope="scope">
          <el-button type="text" @click="onDetail(scope.row)">详情</el-button>
          <el-button type="text" @click="onEdit(scope.row)" v-if="scope.row.status === 'PENDING_ACCOUNT'">编辑</el-button>
        </template>
      </el-table-column>
    </el-table>
    <div class="pt-2"></div>
    <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper"
      @size-change="onPageSizeChanged" @current-change="onCurrentPageChanged" :current-page="page.number + 1"
      :page-size="page.size" :page-count="page.totalPages" :total="page.totalElements">
    </el-pagination>
  </div>
</template>

<script>
export default {
  name: 'CostOrderList',
  props: ['page'],
  methods: {
    onPageSizeChanged(val) {
      this.$emit('onAdvancedSearch', 0, val);

      this.$nextTick(() => {
        this.$refs.resultTable.bodyWrapper.scrollTop = 0
      });
    },
    onCurrentPageChanged(val) {
      this.$emit('onAdvancedSearch', val - 1);

      this.$nextTick(() => {
        this.$refs.resultTable.bodyWrapper.scrollTop = 0
      });
    },
    onDetail (row) {
      this.$router.push('/purchase/cost/' + row.id);
    },
    onEdit (row) {
      this.$router.push('/purchase/cost/edit/' + row.id);
    }
  }
}
</script>

<style scoped>

</style>