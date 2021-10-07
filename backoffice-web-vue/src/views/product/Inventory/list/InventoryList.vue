<template>
  <div class="inventory-list">
    <el-table ref="resultTable" stripe :data="page.content" :height="autoHeight">
      <el-table-column label="产品编号" prop="code"></el-table-column>
      <el-table-column label="款号" prop="skuID"></el-table-column>
      <el-table-column label="创建时间">
        <template slot-scope="scope">
          <span>{{ scope.row.creationtime | formatDate }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-button type="text" @click="onModify(scope.row)" >修改</el-button>
          <el-button type="text" @click="onDelete(scope.row)" >删除</el-button>
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
  name: 'InventoryList',
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
    },
    onModify (row) {
      this.$router.push('/product/inventory/modify/' + row.id)
    },
    onDelete (row) {

    }
  }
}
</script>

<style scoped>
</style>