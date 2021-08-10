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
      <el-table-column label="过期时间" width="120px" min-width="120px">
        <template slot-scope="scope">
          <span>{{scope.row.expireTime | formatDate}}</span>
        </template>
      </el-table-column>
      <el-table-column label="公告类型" width="80px" min-width="80px">
        <template slot-scope="scope">
          <span>{{getEnum('NoticeType', scope.row.type)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="序号" prop="sort" sortable width="80px" min-width="80px" />
      <el-table-column label="操作" width="150px" min-width="150px">
        <template slot-scope="scope">
          <el-switch v-model="scope.row.state" active-value="PUBLISHED" inactive-value="DRAFT" @change="handleSwitch($event, scope.row)"/>
          <el-button type="text" @click="onModify(scope.row)">修改</el-button>
          <el-button type="text" @click="onDelete(scope.row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    <div class="pt-2"></div>
    <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper"
                @size-change="onPageSizeChanged" @current-change="onCurrentPageChanged" :current-page="page.number + 1"
                :page-size="page.size" :page-count="page.totalPages" :total="page.totalElements">
    </el-pagination>
    <el-dialog title="修改公告" :visible.sync="visible" :close-on-click-modal="false" append-to-body>
      <notice-form v-if="visible" :handleRow="handleRow" @callback="callback"/>
    </el-dialog>
  </div>
</template>

<script>
import NoticeForm from '../form/NoticeForm.vue';

export default {
  name: 'NoticeList',
  components: { NoticeForm },
  props: ['page', 'isSelection', 'code'],
  methods: {
    handleSwitch (val, row) {
      // change事件触发值已经改变，这里把值改回原值
      row.state = val === 'DRAFT' ? 'PUBLISHED' : 'DRAFT'
      // 阻止冒泡触发选择列表行
      window.event? window.event.cancelBubble = true : e.stopPropagation();

      this.onPublish(val, row)
    },
    handleSelectionChange (val) {
      this.multipleSelection = val
    },
    rowClick (row) {
      this.$refs.resultTable.toggleRowSelection(row)
    },
    onPublish (val, row) {
      this.$confirm('是否' + (val === 'DRAFT' ? '取消' : '') + '发布此公告?', '提示', {
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
    onModify (row) {
      // 阻止冒泡触发选择列表行
      window.event? window.event.cancelBubble = true : e.stopPropagation();

      this.handleRow = Object.assign({}, row)
      this.visible = true
    },
    callback (flag) {
      this.visible = false

      if (flag) {
        this.$emit('onAdvancedSearch');
      }
    },
    onDelete (row) {
      // 阻止冒泡触发选择列表行
      window.event? window.event.cancelBubble = true : e.stopPropagation();

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
    },
    resetSelection () {
      this.$refs.resultTable.clearSelection()
    }
  },
  data () {
    return {
      multipleSelection: [],
      handleRow: null,
      visible: false
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