<template>
  <div class="recommend-code-list">
    <el-table ref="resultTable" stripe :data="page.content" :height="autoHeight">
      <el-table-column label="标题" prop="title"></el-table-column>
      <el-table-column label="备注" prop="remark"></el-table-column>
      <el-table-column label="url" prop="url"></el-table-column>
      <el-table-column label="编号" prop="code"></el-table-column>
      <el-table-column label="创建时间">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | formatDate}}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-button type="text" @click="onDetail(scope.row)">查看</el-button>
          <el-button type="text" @click="onEdit(scope.row)">编辑</el-button>
          <el-button type="text" v-if="scope.row.enabled" @click="modifyEnable(scope.row, false)">禁用</el-button>
          <el-button type="text" v-else @click="modifyEnable(scope.row, true)">启用</el-button>
          <el-button type="text" @click="onDelete(scope.row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    <div class="pt-2"></div>
    <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper"
                @size-change="onPageSizeChanged" @current-change="onCurrentPageChanged" :current-page="page.number + 1"
                :page-size="page.size" :page-count="page.totalPages" :total="page.totalElements">
    </el-pagination>
    <el-dialog title="渠道码详情" :visible.sync="detailVisible" width="400px" append-to-body :close-on-click-modal="false">
      <recommend-code-detail v-if="detailVisible" :id="detailRow.id" />
    </el-dialog>
  </div>
</template>

<script>
import RecommendCodeDetail from '../detail/RecommendCodeDetail'
export default {
  name: 'RecommendCodeList',
  components: { RecommendCodeDetail },
  props: ['page'],
  methods: {
    onPageSizeChanged(val) {
      this.$emit('onAdvancedSearch', 0, val);

      this.$nextTick(() => {
        this.$refs.resultTable.bodyWrapper.scrollTop = 0
      });
    },
    onCurrentPageChanged(val) {
      this.$emit('onAdvancedSearch', val);

      this.$nextTick(() => {
        this.$refs.resultTable.bodyWrapper.scrollTop = 0
      });
    },
    onDetail (row) {
      this.detailRow = row;
      this.detailVisible = true;
    },
    onEdit (row) {
      this.$emit('onEdit', row);
    },
    modifyEnable (row, flag) {
      this.$confirm('是否' + (flag ? '启用' : '禁用') + '此渠道码?', '', {
        confirmButtonText: '是',
        cancelButtonText: '否',
        type: 'warning'
      }).then(() => {
        this._modifyEnable(row, flag);
      });
    },
    async _modifyEnable (row, flag) {
      const url = this.apis().modifyRecommendCodeEnable(row.id);
      const result = await this.$http.put(url, {}, {
        enable: flag
      });

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
    },
    onDelete (row) {
      this.$confirm('是否删除渠道码?', '', {
        confirmButtonText: '是',
        cancelButtonText: '否',
        type: 'warning'
      }).then(() => {
        this._onDelete(row);
      });
    },
    async _onDelete (row) {
      const url = this.apis().deleteRecommendCode(row.id);
      const result = await this.$http.delete(url);

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
  },
  data () {
    return {
      detailVisible: false,
      detailRow: ''
    }
  }
}
</script>

<style>

</style>