<template>
  <div class="pend-out-view-list">
    <el-table ref="resultTable" stripe :data="page" :height="autoHeight">
      <el-table-column label="银行名" prop="bankName" />
      <el-table-column label="卡号" prop="cardNumber" />
      <el-table-column label="户名" prop="accountName" />
      <el-table-column label="银行网点" prop="bankOutlet" />
      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-button type="text" @click="onUpdate(scope.row)">修改</el-button>
          <el-button type="text" @click="onDelete(scope.row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>

<script>
export default {
  name: 'BankList',
  props: ['page'],
  methods: {
    onUpdate (row) {
      this.$emit('onUpdate', row)
    },
    onDelete (row) {
      this.$confirm('是否删除此配置?', '', {
        confirmButtonText: '是',
        cancelButtonText: '否',
        type: 'warning'
      }).then(() => {
        this._onDelete(row)
      });
    },
    async _onDelete (row) {
      const url = this.apis().deleteBank(row.id)
      const result = await this.$http.delete(url)

      if (result.code === 1) {
        this.$message.success('操作成功！')
        this.$emit('onAdvancedSearch')
      } else if (result.code === 0) {
        this.$message.error(result.msg)
      } else {
        this.$message.success('操作失败！')
      }
    }
  }
}
</script>

<style scoped>

</style>
