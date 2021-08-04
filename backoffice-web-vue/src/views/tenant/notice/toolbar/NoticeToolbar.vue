<template>
  <div class="agent-operation-toolbar">
    <el-form :inline="true">
      <el-row type="flex" justify="space-between">
        <div>
          <el-form-item label="">
            <el-input v-model="queryFormData.keyword" placeholder=""></el-input>
          </el-form-item>
          <el-button-group>
            <el-button class="toolbar-search_input" @click="onAdvancedSearch">搜索</el-button>
            <el-button @click="onReset">重置</el-button>
          </el-button-group>
        </div>
        <div>
          <el-button type="primary" @click="onNew">添加公告</el-button>
        </div>
      </el-row>
    </el-form>
  </div>
</template>

<script>
export default {
  name: 'NoticeToolbar',
  props: ['queryFormData'],
  methods: {
    onNew () {
      this.$prompt('请输入公告信息', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        inputPattern: /^[\s\S]*.*[^\s][\s\S]*$/,
        inputErrorMessage: '请输入',
        closeOnClickModal: false,
        closeOnPressEscape: false
      }).then(({ value }) => {
        this._onNew(value)
      })
    },
    async _onNew (value) {
      const url = this.apis().createNotice()
      const result = await this.$http.post(url, {
        content: value
      })

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
    onAdvancedSearch () {
      this.$emit('onAdvancedSearch');
    },
    onReset () {
      this.queryFormData.keyword = '';
    }
  }
}
</script>

<style scoped>
.agent-operation-toolbar >>> .el-form-item {
    margin-bottom: 0px;
}

.toolbar-search_input {
  background-color: #ffd60c;
  border-color: #ffd60c;
}
</style>