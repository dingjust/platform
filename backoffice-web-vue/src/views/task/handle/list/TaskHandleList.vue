<template>
  <div>
    <el-table ref="resultTable" stripe :data="page.content" :height="autoHeight">
      <el-table-column label="订单编号" prop="code"></el-table-column>
      <el-table-column label="订单类型" prop="typeLabel"></el-table-column>
      <el-table-column label="创建人" prop="creator.name"></el-table-column>
      <el-table-column label="创建时间">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | timestampToTime}}</span>
        </template>
      </el-table-column>
      <el-table-column label="交货时间">
        <template slot-scope="scope">
          <span>{{scope.row.deliverytime | timestampToTime}}</span>
        </template>
      </el-table-column>
      <el-table-column label="任务状态">
        <template slot-scope="scope">
          <span>{{scope.row.status}}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-button type="text" size="mini" @click="onDetail(scope.row)">查看</el-button>
          <el-divider direction="vertical"/>
          <el-button type="text" size="mini" @click="onUndertake(scope.row)">承接</el-button>
          <el-divider direction="vertical"/>
          <el-button type="text" size="mini" @click="onAssignment (scope.row)">分配</el-button>
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
    name: 'TaskHandleList',
    props: ['page'],
    methods: {
      onDetail (row) {
        this.$emit('onDetail', row);
      },
      onUndertake (row) {
        this.$emit('onUndertake', row);
      },
      onAssignment (row) {
        this.$emit('onAssignment', row);
      },
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
