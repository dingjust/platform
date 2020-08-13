<template>
  <el-form :inline="true">
    <el-form-item label="">
      <el-input placeholder="方案名称" v-model="queryFormData.keyword"></el-input>
    </el-form-item>
    <el-button-group>
      <el-button type="primary" class="toolbar-search_input" @click="onSearch">搜索</el-button>
      <el-button native-type="reset" @click="queryFormData.keyword=''">重置</el-button>
    </el-button-group>
  </el-form>
</template>

<script>
  export default {
    name: 'ReconciliationPlanToolbar',
    props: ['queryFormData'],
    methods: {
      onSearch () {
        this.$emit('onSearch');
      }
    }
  }
</script>

<style scoped>
  .toolbar-search_input{
    background-color: #ffd60c;
    border-color: #ffd60c;
  }
</style>
