<template>
  <div class="logistics-toolbar">
    <el-form label-width="auto">
      <el-row type="flex" justify="space-between">
        <el-row type="flex">
          <el-form-item label="">
            <el-input v-model="queryFormData.keyword" placeholder="输入快递单号，产品名，产品款号"></el-input>
          </el-form-item>
          <el-button-group>
            <el-button class="toolbar-search_input" @click="onAdvancedSearch">搜索</el-button>
            <el-button @click="onReset">重置</el-button>
          </el-button-group>
        </el-row>
        <div>
          <el-button type="primary" @click="onAdd">添加</el-button>
          <el-button type="primary" @click="onImport">导出</el-button>
        </div>
      </el-row>
    </el-form>
  </div>
</template>

<script>
export default {
  name: 'LogisticsToolbar',
  props: ['queryFormData'],
  methods: {
    onAdvancedSearch () {
      this.$emit('onAdvancedSearch');
    },
    onReset () {
      this.queryFormData.keyword = '';
    },
    onAdd () {
      this.$router.push('/logistics/form')
    },
    onImport () {
      this.$emit('onImport')
    }
  }
}
</script>

<style scoped>
.logistics-toolbar >>> .el-form-item {
    margin-bottom: 0px;
}

.toolbar-search_input {
  background-color: #ffd60c;
  border-color: #ffd60c;
}
</style>