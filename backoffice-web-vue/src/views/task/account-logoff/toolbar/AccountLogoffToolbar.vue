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
      </el-row>
    </el-form>
  </div>
</template>

<script>
export default {
  name: 'AccountLogoffToolbar',
  props: ['queryFormData'],
  methods: {
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