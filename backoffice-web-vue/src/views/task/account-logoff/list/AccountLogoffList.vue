<template>
  <div class="recommend-code-list">
    <el-table ref="resultTable" stripe :data="page.content" :height="autoHeight">
      <el-table-column label="申请账号">
        <template slot-scope="scope">
          <span>{{scope.row.applyUser.name}}</span>
          <!-- <el-tag type="danger" v-if="scope.row.applyUser.root">主账号</el-tag> -->
        </template>
      </el-table-column>
      <el-table-column label="申请账号uid" prop="applyUser.uid"/>
      <el-table-column label="联系方式" prop="applyUser.contactPhone"/>
      <el-table-column label="所属公司" prop="applyCompany.name"/>
      <el-table-column label="所属公司uid" prop="applyCompany.uid"/>
      <el-table-column label="申请时间">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | formatDate}}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" min-width="80px">
        <template slot-scope="scope">
          <el-button type="text" @click="onAudit(scope.row, true)">通过</el-button>
          <el-button type="text" @click="onAudit(scope.row, false)">拒绝</el-button>
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
  name: 'AccountLogoffList',
  props: ['page'],
  methods: {
    onAudit (row, flag) {
      if (flag) {
        this.$confirm('是否通过此注销申请？', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this._onAudit({
            id: row.id,
            state: "AUDIT_PASSED"
          })
        })
      } else {
        this.$prompt('请输入申请不通过原因', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
        }).then(({
          value
        }) => {
          this._onAudit({
            id: row.id,
            state: "CLOSED",
            processRemark: value
          });
        })
      }
    },
    async _onAudit (data) {
      const url = this.apis().auditAccountLogoff()
      const result = await this.$http.post(url, data)

      if (result.code === 1) {
        this.$emit('onAdvancedSearch', this.page.number, this.page.size);
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
  .el-dropdown-link {
    cursor: pointer;
    color: #409EFF;
    font-size: 12px;
  }
  .el-icon-arrow-down {
    font-size: 12px;
  }
</style>