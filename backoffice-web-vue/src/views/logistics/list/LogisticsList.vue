<template>
  <div class="logistics-list">
    <el-table ref="resultTable" stripe :data="page.content" :height="autoHeight">
      <el-table-column label="快递单号" prop="code"></el-table-column>
      <el-table-column label="快递类型" prop="type">
        <template slot-scope="scope">
          <span>{{getEnum('ExpressType', scope.row.type)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="款号" prop="skuID"></el-table-column>
      <el-table-column label="产品名称" prop="productName"></el-table-column>
      <el-table-column label="颜色"  show-overflow-tooltip>
        <template slot-scope="scope">
          <span>{{scope.row.colors.join(', ')}}</span>
        </template>
      </el-table-column>
      <el-table-column label="尺码" show-overflow-tooltip>
        <template slot-scope="scope">
          <span>{{scope.row.sizes.join(', ')}}</span>
        </template>
      </el-table-column>
      <el-table-column label="质量问题" >
        <template slot-scope="scope">
          <span>{{scope.row.defected ? '有' : '无'}}</span>
        </template>
      </el-table-column>
      <el-table-column label="备注" prop="remarks"></el-table-column>
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
  name: 'LogisticsList',
  props: ['page'],
  methods: {
    onPageSizeChanged (val) {
      this.$emit('onAdvancedSearch', 0, val);

      this.$nextTick(() => {
        this.$refs.resultTable.bodyWrapper.scrollTop = 0
      });
    },
    onCurrentPageChanged (val) {
      this.$emit('onAdvancedSearch', val, this.page.size);

      this.$nextTick(() => {
        this.$refs.resultTable.bodyWrapper.scrollTop = 0
      });
    }
  }
}
</script>

<style scoped>
</style>