<template>
  <div class="pend-out-view-toolbar">
    <el-form :inline="true">
      <el-form-item label="订单信息" prop="name">
        <el-input placeholder="请输入订单号，订单名称" v-model="queryFormData.keyword"></el-input>
      </el-form-item>
      <el-form-item label="合作商" prop="name">
        <el-input placeholder="请输入合作商名称" v-model="queryFormData.cooperator"></el-input>
      </el-form-item>
      <el-form-item label="渠道码" prop="name">
        <el-input placeholder="请输入合作商名称" v-model="queryFormData.channelCode"></el-input>
      </el-form-item>
      <el-button-group>
        <el-button type="primary" class="toolbar-search_input" @click="onAdvancedSearch">搜索</el-button>
        <el-button native-type="reset" @click="onReset">重置</el-button>
      </el-button-group>
    </el-form>
  </div>
</template>

<script>
export default {
  name: 'PendOutViewToolbar',
  props: ['queryFormData'],
  methods: {
    onAdvancedSearch() {
      this.$emit('onAdvancedSearch', 0);
    },
    onReset() {
      this.queryFormData.keyword = '';
      this.queryFormData.cooperator = '';
      this.queryFormData.channelCode = '';
    }
  }
}
</script>

<style scoped>
  .toolbar-search_input {
    background-color: #ffd60c;
    border-color: #ffd60c;
  }

  .pend-out-view-toolbar >>> .el-form-item {
    margin-bottom: 5px;
  }

  .pend-out-view-toolbar >>> .el-dialog__body {
    padding: 10px 20px!important;
  }
</style>
