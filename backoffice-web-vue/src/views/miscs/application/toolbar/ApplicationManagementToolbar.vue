<template>
  <div class="application-toolbar">
    <el-form :inline="true">
      <el-row type="flex" justify="space-between">
        <el-col :span="22">
          <el-form-item label="应用信息">
            <el-input v-model="queryFormData.keyword"></el-input>
          </el-form-item>
          <el-button-group>
            <el-button type="primary" class="toolbar-search_input" @click="onAdvancedSearch">搜索</el-button>
            <el-button native-type="reset" @click="onReset">重置</el-button>
          </el-button-group>
        </el-col>
        <el-col :span="2">
          <el-button class="create-button" @click="onAdd">添加</el-button>
        </el-col>
      </el-row>
    </el-form>
  </div>
</template>

<script>
export default {
  name: 'ApplicationManagementToolbar',
  props: ['queryFormData'],
  methods: {
    onAdvancedSearch () {
      this.$emit('onAdvancedSearch');
    },
    onReset () {
      this.queryFormData.keyword = '';
    },
    onAdd () {
      this.$router.push('/miscs/create/application');
    }
  }  
}
</script>

<style scoped>
  .application-toolbar >>> .el-form-item {
    margin-bottom: 0px;
  }

  .create-button {
    background-color: #ffd60c;
    border-color: #DCDFE6;
    width: 80px;
    color: #606266;
  }

  .toolbar-search_input {
    background-color: #ffd60c;
    border-color: #ffd60c;
  }
</style>