<template>
  <div>
    <el-table ref="resultTable" stripe="" :data="page.content" :height="autoHeight">
      <el-table-column label="用户名" prop="belongUser.name"></el-table-column>
      <el-table-column label="联系电话" prop="belongUser.uid"></el-table-column>
      <el-table-column label="活动类型" prop="event">
        <template slot-scope="scope">
          <span>{{getEnum('ActivityEvent', scope.row.event)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="积分" prop="points"></el-table-column>
      <el-table-column label="总积分" prop="updatedTotalPoints"></el-table-column>
      <el-table-column label="更新时间" prop="updateTime">
        <template slot-scope="scope">
          <span>{{scope.row.updateTime | formatDate}}</span>
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
  name: 'PointsRecordList',
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
    }
  }
}
</script>

<style scoped>

</style>