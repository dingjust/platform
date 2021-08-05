<template>
  <div class="recommend-code-list">
    <el-table ref="resultTable" stripe :data="page.content" :height="autoHeight" row-key="id"
              @selection-change="handleSelectionChange" @row-click="rowClick">
      <el-table-column v-if="isSelection" type="selection" :reserve-selection="true" width="55" />
      <el-table-column label="公告内容" prop="content" ></el-table-column>
      <el-table-column label="创建时间" width="120px" min-width="120px">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | formatDate}}</span>
        </template>
      </el-table-column>
      <el-table-column label="公告类型" width="80px" min-width="80px">
        <template slot-scope="scope">
          <span>{{getEnum('NoticeType', scope.row.type)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="110px" min-width="110px">
        <template slot-scope="scope">
          <el-button type="text" @click="onPublish(scope.row)">{{scope.row.state === 'DRAFT' ? '发布' : '取消发布'}}</el-button>
          <el-button type="text" @click="onDelete(scope.row)">删除</el-button>
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
  name: 'NoticeList',
  props: ['page', 'isSelection', 'code'],
  methods: {
    handleSelectionChange (val) {
      this.multipleSelection = val
    },
    rowClick (row) {
      this.$refs.resultTable.toggleRowSelection(row)
    },
    onPublish (row) {
      this.$confirm('是否发布此公告?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this._onPublish(row)
      })
    },
    async _onPublish (row) {
      const url = this.apis().publishNotice(row.id)
      const result = await this.$http.get(url)

      if (result.code === 1) {
        this.$message.success('操作成功！')
        this.$emit('onAdvancedSearch');
      } else if (result.code === 0) {
        this.$message.error(result.msg)
      } else if (result['errors']) {
        this.$message.error(result['errors'][0].message)
      } else {
        this.$message.error('操作失败')
      }
    },
    onDelete (row) {
      this.$confirm('是否删除此公告?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this._onDelete(row)
      })
    },
    async _onDelete (row) {
      const url = this.apis().delectNotice(row.id)
      const result = await this.$http.delete(url)

      if (result.code === 1) {
        this.$message.success('操作成功！')
        this.$emit('onAdvancedSearch');
      } else if (result.code === 0) {
        this.$message.error(result.msg)
      } else if (result['errors']) {
        this.$message.error(result['errors'][0].message)
      } else {
        this.$message.error('操作失败')
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
  },
  watch: {
    'isSelection': function (nval, oval) {
      if (nval === false) {
        this.$refs.resultTable.clearSelection()
      }
    }
  }
}
</script>

<style scoped>
</style>