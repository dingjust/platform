<!--
* @Description: 盈亏分析详情button
* @Date 2021/04/06 13:50
* @Author L.G.Y
-->
<template>
  <el-row type="flex" justify="center" :gutter="50" v-if="detail.status !== 'CANCELLED'">
    <el-button type="text" @click="onCancel">取消</el-button>
    <el-button class="create-btn" @click="onEdit">编辑</el-button>
  </el-row>
</template>

<script>
export default {
  name: 'ProfitLossDetailBtn',
  props: ['detail'],
  methods: {
    onCancel () {
      this.$confirm('是否执行取消盈亏分析表操作?', '', {
        confirmButtonText: '是',
        cancelButtonText: '否',
        type: 'warning'
      }).then(() => {
        this._onCancel();
      });
    },
    async _onCancel () {
      const url = this.apis().cancelProfitLoss(this.detail.id);
      const result = await this.$http.put(url);

      if (result.code === 1) {
        this.$emit('callback');
      } else if (result.code === 0) {
        this.$message.error(result.msg);
      } else if (result['errors']) {
        this.$message.error(result['errors'][0].message);
      }
    },
    onEdit () {
      this.$confirm('是否前往编辑盈亏分析表页面?', '', {
        confirmButtonText: '是',
        cancelButtonText: '否',
        type: 'warning'
      }).then(() => {
        this._onEdit();
      });
    },
    _onEdit () {
      this.$router.push('/purchase/profitloss/edit/' + this.detail.id);
    }
  }
}
</script>

<style>
  .create-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    width: 120px;
    height: 40px;
  }
</style>