<template>
  <div>
    <el-table ref="resultTable" stripe="" :data="page.content" :height="autoHeight">
      <el-table-column label="单号" prop="code"></el-table-column>
      <el-table-column label="关联成本单" prop="refCostOrderCode"></el-table-column>
      <el-table-column label="创建人" prop="creator.name"></el-table-column>
      <el-table-column label="创建时间" min-width="80">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | timestampToTime}}</span>
        </template>
      </el-table-column>
      <el-table-column label="状态">
        <template slot-scope="scope">
          <span style="color: #F56C6C">{{scope.row.status === 'CANCELLED' ? '已取消' : ''}}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="100" min-width="100">
        <template slot-scope="scope">
          <el-button type="text" @click="onDetail(scope.row)">详情</el-button>
          <el-button type="text" v-if="scope.row.status !== 'CANCELLED'" @click="onEdit(scope.row)">编辑</el-button>
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
  name: 'QuoteOrderListV2',
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
      this.$router.push('/purchase/quote/' + row.id);
    },
    onEdit (row) {
      this.$router.push('/purchase/quote/edit/' + row.id);
    }
  }
}
</script>

<style scoped>

</style>