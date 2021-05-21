<template>
  <div class="recommend-code-toolbar">
    <el-form :inline="true">
      <el-row type="flex" justify="space-between">
        <div>
          <el-form-item label="">
            <el-input v-model="queryFormData.keyword" placeholder="渠道码信息"></el-input>
          </el-form-item>
          <el-button-group>
            <el-button class="toolbar-search_input" @click="onAdvancedSearch">搜索</el-button>
            <el-button @click="onReset">重置</el-button>
          </el-button-group>
        </div>
        <el-button type="primary" @click="onCreate">新增渠道码</el-button>
      </el-row>
    </el-form>
  </div>
</template>

<script>
export default {
  name: 'RecommendCodeToolbar',
  props: ['queryFormData'],
  methods: {
    onAdvancedSearch () {
      this.$emit('onAdvancedSearch');
    },
    onReset () {
      this.queryFormData.keyword = '';
    },
    onCreate () {
      this.$emit('onCreate');
    }
  },
  data () {
    return {
      dialogTitle: '',
      appendVisible: false
    }
  }
}
</script>

<style scoped>
.recommend-code-toolbar >>> .el-form-item {
    margin-bottom: 0px;
}

.toolbar-search_input {
  background-color: #ffd60c;
  border-color: #ffd60c;
}
</style>