<template>
  <div>
    <reconciliation-info-table :formData="order"/>
    <el-row type="flex" justify="center" style="margin-top: 20px">
      <el-button class="sumbit-btn" @click="onModify">修改</el-button>
    </el-row>
  </div>
</template>

<script>
import ReconciliationInfoTable from './ReconciliationInfoTable'
export default {
  name: 'ReconciliationOrderModifyForm',
  props: ['order'],
  components: {
    ReconciliationInfoTable
  },
  methods: {
    onModify () {
      if (this.order.entries.some(item => item.product.id === '')) {
        this.$message.error('存在对账内容没有产品，请先进行处理');
        return;
      }

      this.$confirm('是否进行修改操作?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this._onModify();
      });
    },
    async _onModify () {
      const form = this.order;

      const url = this.apis().reconciliationOrderModify();
      const result = await this.$http.put(url, form);

      if (result.code === 1) {
        this.$message.success('操作成功！');
        this.$emit('callback', result.data);
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
  .sumbit-btn {
    background-color: #ffd60c;
    border-color: #ffd60c;
    color: #606266;
    width: 80px;
  }
</style>