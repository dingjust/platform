<template>
  <div class="recommend-code-list">
    <el-table ref="resultTable" stripe :data="page.content" :height="autoHeight">
      <el-table-column label="申请公司" prop="belongTo.name"></el-table-column>
      <el-table-column label="申请公司uid" prop="belongTo.uid"></el-table-column>
      <el-table-column label="申请人" prop="creator.name"></el-table-column>
      <el-table-column label="创建时间">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | formatDate}}</span>
        </template>
      </el-table-column>
      <el-table-column label="状态">
        <template slot-scope="scope">
          <span>{{scope.row.isProcessed ? '已处理' : '未处理'}}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" >
        <template slot-scope="scope">
          <el-button v-if="!scope.row.isProcessed" type="text" @click="onSumbit(scope.row)">处理</el-button>
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
  name: 'TrusteeshipList',
  props: ['page'],
  methods: {
    onSumbit (row) {
      this.$confirm('是否通过此托管申请?', '', {
        confirmButtonText: '是',
        cancelButtonText: '否',
        type: 'warning'
      }).then(() => {
        this._onSumbit(row)
      });
    },
    async _onSumbit (row) {
      const url = this.apis().proccessedTrusteeship(row.id)
      const result = await this.$http.put(url)

      if (result.code === 1) {
        this.$message.success('操作成功！')
        this.$emit('onAdvancedSearch');
      } else if (result.code === 0) {
        this.$message.error(result.msg)
      } else {
        this.$message.error('操作失败！')
      }
    },
    onPageSizeChanged(val) {
      this.$emit('onAdvancedSearch', 0, val);

      this.$nextTick(() => {
        this.$refs.resultTable.bodyWrapper.scrollTop = 0
      });
    },
    onCurrentPageChanged(val) {
      this.$emit('onAdvancedSearch', val - 1, this.page.size);

      this.$nextTick(() => {
        this.$refs.resultTable.bodyWrapper.scrollTop = 0
      });
    }
  }
}
</script>

<style scoped>
</style>