<template>
  <div>
    <el-table ref="resultTable" stripe :data="page.content" :height="autoHeight">
      <el-table-column label="应用名称" prop="appName"></el-table-column>
      <el-table-column label="AppID" prop="appID"></el-table-column>
      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-button type="text" @click="onEdit(scope.row)">编辑</el-button>
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
  name: 'ApplicationManagementList',
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
    onEdit (row) {
      this.$router.push('/miscs/application/' + row.id);
    }
  }  
}
</script>

<style scoped>

</style>