<template>
  <div class="logistics-list">
    <el-table ref="resultTable" stripe :data="page.content" :height="autoHeight">
      <el-table-column label="快递编号" prop="code"></el-table-column>
      <el-table-column label="换货编号" prop="relationCode"></el-table-column>
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
      <el-table-column label="创建时间">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | formatDate}}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-button type="text" @click="onEdit(scope.row)">编辑</el-button>
          <el-button type="text" @click="onDelete(scope.row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    <div class="pt-2"></div>
    <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper"
                @size-change="onPageSizeChanged" @current-change="onCurrentPageChanged" :current-page="page.number + 1"
                :page-size="page.size" :page-count="page.totalPages" :total="page.totalElements">
    </el-pagination>
    <el-dialog title="编辑物流单号信息" :visible.sync="visible" width="500px" append-to-body :close-on-click-modal="false">
      <logistics-edit-form v-if="visible" :handleRow="handleRow" @callback="callback" @closeDialog="visible=false" />
    </el-dialog>
  </div>
</template>

<script>
import LogisticsEditForm from '../form/LogisticsEditForm'

export default {
  name: 'LogisticsList',
  components: { LogisticsEditForm },
  props: ['page'],
  methods: {
    onPageSizeChanged (val) {
      this.$emit('onAdvancedSearch', 0, val);

      this.$nextTick(() => {
        this.$refs.resultTable.bodyWrapper.scrollTop = 0
      });
    },
    onCurrentPageChanged (val) {
      this.$emit('onAdvancedSearch', val - 1, this.page.size);

      this.$nextTick(() => {
        this.$refs.resultTable.bodyWrapper.scrollTop = 0
      });
    },
    callback () {
      this.visible = false
      this.$emit('onAdvancedSearch', this.page.number, this.page.size)
    },
    onEdit (row) {
      this.handleRow = row
      this.visible = true
    },
    onDelete (row) {
      this.$confirm('是否删除此信息?', '提示', {
        confirmButtonText: '是',
        cancelButtonText: '否',
        type: 'warning'
      }).then(() => {
        this._onDelete(row)
      });
    },
    async _onDelete (row) {
      const url = this.apis().deleteLogistics(row.id)
      const result = await this.$http.delete(url)

      if (result.code === 1) {
        this.$message.success('操作成功！')
        this.$emit('onAdvancedSearch', this.page.number, this.page.size)
      } else if (result.code === 0) {
        this.$message.error(result.msg)
      } else {
        this.$message.error('操作失败！')
      }
    }
  },
  data () {
    return {
      handleRow: null,
      visible: false
    }
  }
}
</script>

<style scoped>
</style>