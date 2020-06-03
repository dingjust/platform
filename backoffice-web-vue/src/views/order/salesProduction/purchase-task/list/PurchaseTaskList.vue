<template>
  <div>
    <el-table ref="resultTable" stripe :data="page.content" :height="autoHeight">
      <el-table-column label="采购任务单号" prop="code"></el-table-column>
      <el-table-column label="关联款号" prop="skuID"></el-table-column>
      <el-table-column label="关联订单" prop="orderCode"></el-table-column>
      <el-table-column label="创建人" prop="creator.name"></el-table-column>
      <el-table-column label="采购员" prop="purchaser.name"></el-table-column>
      <el-table-column label="创建时间">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | timestampToTime}}</span>
        </template>
      </el-table-column>
      <el-table-column label="审批状态">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | timestampToTime}}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-button type="text" @click="onDetail(scope.row)">详情</el-button>
          <el-divider direction="vertical"></el-divider>
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
    name: 'PurchaseTaskList',
    props: ['page'],
    methods: {
      onPageSizeChanged (val) {
        this.$emit('onAdvancedSearch', 0, val);
        this.$nextTick(() => {
          this.$refs.resultTable.bodyWrapper.scrollTop = 0
        });
      },
      onCurrentPageChanged (val) {
        this.$emit('onAdvancedSearch', val - 1);
        this.$nextTick(() => {
          this.$refs.resultTable.bodyWrapper.scrollTop = 0
        });
      },
      onDetail (row) {

      },
      onEdit(row) {

      }
    }
  }
</script>

<style scoped>

</style>
