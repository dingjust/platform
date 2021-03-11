<template>
  <div>
    <el-table ref="resultTable" stripe="" :data="page.content" :height="autoHeight">
      <el-table-column label="单号" prop="code"></el-table-column>
      <el-table-column label="申请用户" prop="applyUser.name"></el-table-column>
      <el-table-column label="联系方式" prop="applyUser.uid"></el-table-column>
      <el-table-column label="汇兑积分" prop="points"></el-table-column>
      <el-table-column label="汇兑金额" prop="exchangeAmount">
        <template slot-scope="scope">
          <span>{{scope.row.exchangeAmount}} 元</span>
        </template>
      </el-table-column>
      <el-table-column label="汇兑用户" prop="exchangeUser.name"></el-table-column>
      <el-table-column label="联系方式" prop="exchangeUser.uid"></el-table-column>
      <el-table-column label="状态">
        <template slot-scope="scope">
          <span>{{getEnum('PointsExchangeState', scope.row.state)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="提交时间" prop="processTime" min-width="120px">
        <template slot-scope="scope">
          <span v-if="scope.row.processTime">{{scope.row.processTime | formatDate}}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-button v-if="scope.row.state === 'SUBMIT'" type="text" style="color: #67C23A" @click="onExchange(scope.row, true)">通过</el-button>
          <el-button v-if="scope.row.state === 'SUBMIT'" type="text" style="color: #F56C6C" @click="onExchange(scope.row, false)">驳回</el-button>
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
  name: 'PointsExchangeList',
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
    onExchange (row, flag) {
      this.$confirm('是否确认' + (flag ? '通过' : '驳回') + '申请', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(async () => {
        this._onExchange(row, flag);
      });
    },
    async _onExchange (row, flag) {
      const url = this.apis().processPointsExchange(row.id);
      const result = await this.$http.post(url, {}, {
        agree: flag
      })
      if (result.code === 1) {
        this.$message.success('操作成功！');
        this.$emit('onAdvancedSearch');
      } else if (result['errors']) {
        this.$message.error(result['errors'][0].message);
      } else if (result.code === 0) {
        this.$message.error(result.msg);
      } else {
        this.$message.error('操作失败！');
      }
    }
  }
}
</script>

<style scoped>

</style>