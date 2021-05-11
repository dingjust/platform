<template>
  <div class="temp-form">
    <el-row type="flex" justify="start" align="middle">
      <h6>固定条款</h6>
    </el-row>
    <el-row type="flex">
      <el-input v-model="detail.header" type="textarea" :rows="20"></el-input>
    </el-row>
    <el-row type="flex" justify="start" align="middle" style="margin-top: 30px">
      <h6>自定义条款</h6>
    </el-row>
    <el-row type="flex">
      <el-input v-model="detail.content" type="textarea" :rows="20"></el-input>
    </el-row>
    <el-row type="flex" justify="center" align="middle">
      <el-button type="primary" class="save-btn" @click="onSave">修改</el-button>
    </el-row>
  </div>
</template>

<script>
export default {
  name: 'ContractBackTempForm',
  props: ['detail'],
  methods: {
    onSave () {
      this.$confirm('是否执行修改 ' + this.detail.title +' 模板操作?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this._onSave();
      });
    },
    async _onSave () {
      const form = {
        title: this.detail.title,
        code: this.detail.code,
        header: this.detail.header,
        content: this.detail.content,
        type: this.detail.type,
        available: true
      };

      const url = this.apis().updateContractTempOnPlatform();
      const result = await this.$http.post(url, form);

      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }
      if (result.code === 0) {
        this.$message.error(result.msg);
        return;
      }

      this.$emit('callback', this.detail.code);
    }
  }
}
</script>

<style scoped>
  .clause-detail {
    padding: 5px;
    border: 1px solid #e6e6e6;
  }

  .save-btn {
    margin-top: 20px;
    width: 120px;
    height: 40px;
  }
</style>